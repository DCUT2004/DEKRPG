class MutDruidRPG extends Mutator
	config(UT2004RPG);

var MutUT2004RPG RPGMut;
var RPGRules rules;
var config class<RPGDamageGameRules> DamageRules;
const DEK_PAWN_CLASS = "DEKRPG999X.DEKPawn";

struct ArtifactKeyConfig
{
	Var String Alias;
	var Class<RPGArtifact> ArtifactClass;
};
var config Array<ArtifactKeyConfig> ArtifactKeyConfigs;

function PostBeginPlay()
{
	local GameRules G;
	
	Enable('Tick');
	G = Spawn(class'StatusEffectGameRules');
	if ( Level.Game.GameRulesModifiers == None )
		Level.Game.GameRulesModifiers = G;
	else    
		Level.Game.GameRulesModifiers.AddGameRules(G);
        
	RPGMut = class'MutUT2004RPG'.static.GetRPGMutator(Level.Game);
	Level.Game.DefaultPlayerClassName = DEK_PAWN_CLASS;
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	local DEKRPGWeaponPickup p;

	if (Other == None)
	{
		return true;
	}

    // update the Weapon Pickups - everything else is handled in MutUT2004RPG
	// don't affect the translocator because it breaks bots
	// don't affect Weapons of Evil's Sentinel Deployer because it doesn't work at all
	if (Other.IsA('WeaponPickup') && !Other.IsA('TransPickup') && !Other.IsA('DEKRPGWeaponPickup')
		&& !Other.IsA('SentinelDeployerPickup') )
	{
		p = DEKRPGWeaponPickup(ReplaceWithActor(Other, "DEKRPG999X.DEKRPGWeaponPickup"));
		if (p != None)
		{
            if (RPGMut != None)
                p.RPGMut = RPGMut;
			p.FindPickupBase();
			p.GetPropertiesFrom(class<WeaponPickup>(Other.Class));
		}
		return false;
	}

	return true;
}

//Replace an actor and then return the new actor
function Actor ReplaceWithActor(actor Other, string aClassName)
{
	local Actor A;
	local class<Actor> aClass;

	if ( aClassName == "" )
		return None;

	aClass = class<Actor>(DynamicLoadObject(aClassName, class'Class'));
	if ( aClass != None )
		A = Spawn(aClass,Other.Owner,Other.tag,Other.Location, Other.Rotation);
	if ( Other.IsA('Pickup') )
	{
		if ( Pickup(Other).MyMarker != None )
		{
			Pickup(Other).MyMarker.markedItem = Pickup(A);
			if ( Pickup(A) != None )
			{
				Pickup(A).MyMarker = Pickup(Other).MyMarker;
				A.SetLocation(A.Location
					+ (A.CollisionHeight - Other.CollisionHeight) * vect(0,0,1));
			}
			Pickup(Other).MyMarker = None;
		}
		else if ( A.IsA('Pickup') )
			Pickup(A).Respawntime = 0.0;
	}
	if ( A != None )
	{
		A.event = Other.event;
		A.tag = Other.tag;
		return A;
	}
	return None;
}

function ModifyPlayer(Pawn Other)
{	// for the keys and subclasses
	Local GiveItemsInv GIInv;
	local MissionMultiplayerHUDInv MMPIHUD;

	super.ModifyPlayer(Other);

	if (Other == None || Other.Controller == None || !Other.Controller.IsA('PlayerController'))
		return;
		
	MMPIHUD = MissionMultiplayerHUDInv(Other.FindInventoryType(class'MissionMultiplayerHUDInv'));
	
	if (MMPIHUD == None)
	{
		MMPIHUD = Other.Spawn(class'MissionMultiplayerHUDInv');
		MMPIHUD.GiveTo(Other);
	}

	//add the default items to their inventory..
	GIInv = class'GiveItemsInv'.static.GetGiveItemsInv(Other.Controller);
	if(GIInv != None)
		return;
	
	// ok, no GiveItemsInv. Let's create one
	GIInv = Spawn(class'GiveItemsInv', Other);
	
	GIInv.KeysMut = self;
	
	// first put on controller inventory. Put at start of Inv to make sure RPGStatsInv doesn't delete it
	GIInv.Inventory = Other.Controller.Inventory;
	Other.Controller.Inventory = GIInv;

	GIInv.SetOwner(Other.Controller);
	
	// then initialise keys and subclass info
	GIInv.InitializeKeyArray();
	GIInv.InitializeSubClasses(Other);
	GIInv.InitializeMaterials();
}

function Tick(float deltaTime)
{
	local GameRules G;
	local RPGDamageGameRules DG;

	if(rules != None)
	{
		Disable('Tick');
		return; //already initialized
	}

	// Need to add DruidRPGGameRules after RPGRules, and DruidRPGDamageGameRules before RPGRules.
	if ( Level.Game.GameRulesModifiers == None )
		warn("Warning: There is no UT2004RPG Loaded. DruidsRPG cannot function.");
	else
	{
		for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
		{
			if(G.isA('RPGRules'))
				rules = RPGRules(G);
			if(G.NextGameRules == None)
			{
				if(rules == None)
				{
					warn("Warning: There is no UT2004RPG Loaded. DruidsRPG cannot function.");
					return;
				}
			}
		}
		// ok, so we have a RPGRules in the list. lets add RPGDamageGameRules before it, if required
		Log("DamageRules:" $ DamageRules);
		if (DamageRules != None)
		{
			DG = spawn(DamageRules);
			if (Level.Game.GameRulesModifiers != None && Level.Game.GameRulesModifiers.IsA('RPGRules'))
			{
				// RPGRules is at the start. So add before it
				DG.NextGameRules = Level.Game.GameRulesModifiers;
				Level.Game.GameRulesModifiers = DG;
			}
			else
			{
				for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
				{
					if (G.NextGameRules != None && G.NextGameRules.IsA('RPGRules'))
					{
						DG.NextGameRules = G.NextGameRules;
						G.NextGameRules = DG;
					}
				}
			}
			DG.UT2004RPGRules = RPGRules(DG.NextGameRules);
		}
		
		// now add DruidRPGGameRules to the end of the chain
		Level.Game.GameRulesModifiers.AddGameRules(spawn(class'DruidRPGGameRules'));
		Disable('Tick');
		return;
	}
}

defaultproperties
{
     DamageRules=Class'DEKRPG999X.RPGDamageGameRules'
     ArtifactKeyConfigs(0)=(Alias="SelectTriple",ArtifactClass=Class'DEKRPG999X.DruidArtifactTripleDamage')
     ArtifactKeyConfigs(1)=(Alias="SelectMWM",ArtifactClass=Class'DEKRPG999X.DruidArtifactMakeMagicWeapon')
     ArtifactKeyConfigs(2)=(Alias="SelectMax",ArtifactClass=Class'DEKRPG999X.DruidMaxModifier')
     ArtifactKeyConfigs(3)=(Alias="SelectPoisonBlast",ArtifactClass=Class'DEKRPG999X.ArtifactPoisonBlast')
     ArtifactKeyConfigs(4)=(Alias="SelectHealingBlast",ArtifactClass=Class'DEKRPG999X.ArtifactHealingBlast')
     ArtifactKeyConfigs(5)=(Alias="SelectMedic",ArtifactClass=Class'DEKRPG999X.ArtifactMakeSuperHealer')
     ArtifactKeyConfigs(6)=(Alias="SelectRod",ArtifactClass=Class'DEKRPG999X.DruidArtifactLightningRod')
     ArtifactKeyConfigs(7)=(Alias="SelectSphereHeal",ArtifactClass=Class'DEKRPG999X.ArtifactSphereHealing')
     ArtifactKeyConfigs(8)=(Alias="SelectSphereDamage",ArtifactClass=Class'DEKRPG999X.ArtifactSphereDamage')
     ArtifactKeyConfigs(9)=(Alias="SelectRemoteDamage",ArtifactClass=Class'DEKRPG999X.ArtifactRemoteDamage')
     ArtifactKeyConfigs(10)=(Alias="SelectRemoteInv",ArtifactClass=Class'DEKRPG999X.ArtifactRemoteInvulnerability')
     ArtifactKeyConfigs(11)=(Alias="SelectRemoteMax",ArtifactClass=Class'DEKRPG999X.ArtifactRemoteMax')
     ArtifactKeyConfigs(12)=(Alias="SelectShieldBlast",ArtifactClass=Class'DEKRPG999X.ArtifactShieldBlast')
     ArtifactKeyConfigs(13)=(Alias="SelectRemoteBooster",ArtifactClass=Class'DEKRPG999X.ArtifactRemoteBooster')
     ArtifactKeyConfigs(14)=(Alias="SelectResurrect",ArtifactClass=Class'DEKRPG999X.ArtifactResurrect')
     ArtifactKeyConfigs(15)=(Alias="SelectRemoteAmplifier",ArtifactClass=Class'DEKRPG999X.ArtifactRemoteAmplifier')
     GroupName="DruidsRPG"
     FriendlyName="DEKRPG999X Druid's RPG Game Rules"
     Description="DEKRPG is an extension of DruidsRPG by Druid, Shantara and Szlat, and Mysterial's UT2004RPG. DEKRPG expands on abilities, artifacts, magic weapons, and adds an interactive mission system."
     bAlwaysRelevant=True
     RemoteRole=ROLE_SimulatedProxy
}
