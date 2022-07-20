class MutDruidRPG extends Mutator
	config(UT2004RPG);

var RPGRules rules;
var config class<RPGDamageGameRules> DamageRules;

struct ArtifactKeyConfig
{
	Var String Alias;
	var Class<RPGArtifact> ArtifactClass;
};
var config Array<ArtifactKeyConfig> ArtifactKeyConfigs;

function PostBeginPlay()
{
	Enable('Tick');
}

function ModifyPlayer(Pawn Other)
{	// for the keys and subclasses
	Local GiveItemsInv GIInv;
	local MissionMultiplayerHUDInv MMPIHUD;
	local MissionInv MInv;
	local Mission1Inv M1Inv;
	local Mission2Inv M2Inv;
	local Mission3Inv M3Inv;

	super.ModifyPlayer(Other);

	if (Other == None || Other.Controller == None || !Other.Controller.IsA('PlayerController'))
		return;
		
	MMPIHUD = MissionMultiplayerHUDInv(Other.FindInventoryType(class'MissionMultiplayerHUDInv'));
	
	if (MMPIHUD == None)
	{
		MMPIHUD = Other.Spawn(class'MissionMultiplayerHUDInv');
		MMPIHUD.GiveTo(Other);
	}
	MInv = MissionInv(Other.FindInventoryType(class'MissionInv'));
	M1Inv = Mission1Inv(Other.FindInventoryType(class'Mission1Inv'));
	M2Inv = Mission2Inv(Other.FindInventoryType(class'Mission2Inv'));
	M3Inv = Mission3Inv(Other.FindInventoryType(class'Mission3Inv'));
	if (MInv == None)
	{
		MInv = Other.Spawn(class'MissionInv');
		MInv.GiveTo(Other);
	}
	if (M1Inv == None)
	{
		M1Inv = Other.Spawn(class'Mission1Inv');
		M1Inv.GiveTo(Other);
	}
	if (M2Inv == None)
	{
		M2Inv = Other.Spawn(class'Mission2Inv');
		M2Inv.GiveTo(Other);
	}
	if (M3Inv == None)
	{
		M3Inv = Other.Spawn(class'Mission3Inv');
		M3Inv.GiveTo(Other);
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
     ArtifactKeyConfigs(1)=(Alias="SelectGlobe",ArtifactClass=Class'DEKRPG999X.DruidArtifactInvulnerability')
     ArtifactKeyConfigs(2)=(Alias="SelectMWM",ArtifactClass=Class'DEKRPG999X.DruidArtifactMakeMagicWeapon')
     ArtifactKeyConfigs(3)=(Alias="SelectDouble",ArtifactClass=Class'DEKRPG999X.DruidDoubleModifier')
     ArtifactKeyConfigs(4)=(Alias="SelectMax",ArtifactClass=Class'DEKRPG999X.DruidMaxModifier')
     ArtifactKeyConfigs(5)=(Alias="SelectPlusOne",ArtifactClass=Class'DEKRPG999X.DruidPlusOneModifier')
     ArtifactKeyConfigs(6)=(Alias="SelectBolt",ArtifactClass=Class'DEKRPG999X.ArtifactLightningBolt')
     ArtifactKeyConfigs(7)=(Alias="SelectRepulsion",ArtifactClass=Class'DEKRPG999X.ArtifactRepulsion')
     ArtifactKeyConfigs(8)=(Alias="SelectFreezeBomb",ArtifactClass=Class'DEKRPG999X.ArtifactFreezeBomb')
     ArtifactKeyConfigs(9)=(Alias="SelectPoisonBlast",ArtifactClass=Class'DEKRPG999X.ArtifactPoisonBlast')
     ArtifactKeyConfigs(10)=(Alias="SelectMegaBlast",ArtifactClass=Class'DEKRPG999X.ArtifactMegaBlast')
     ArtifactKeyConfigs(11)=(Alias="SelectHealingBlast",ArtifactClass=Class'DEKRPG999X.ArtifactHealingBlast')
     ArtifactKeyConfigs(12)=(Alias="SelectMedic",ArtifactClass=Class'DEKRPG999X.ArtifactMakeSuperHealer')
     ArtifactKeyConfigs(13)=(Alias="SelectFlight",ArtifactClass=Class'DEKRPG999X.DruidArtifactFlight')
     ArtifactKeyConfigs(14)=(Alias="SelectElectroMagnet",ArtifactClass=Class'DEKRPG999X.DruidArtifactSpider')
     ArtifactKeyConfigs(15)=(Alias="SelectTeleport",ArtifactClass=Class'UT2004RPG.ArtifactTeleport')
     ArtifactKeyConfigs(16)=(Alias="SelectBeam",ArtifactClass=Class'DEKRPG999X.ArtifactLightningBeam')
     ArtifactKeyConfigs(17)=(Alias="SelectRod",ArtifactClass=Class'DEKRPG999X.DruidArtifactLightningRod')
     ArtifactKeyConfigs(18)=(Alias="SelectSphereInv",ArtifactClass=Class'DEKRPG999X.ArtifactSphereInvulnerability')
     ArtifactKeyConfigs(19)=(Alias="SelectSphereHeal",ArtifactClass=Class'DEKRPG999X.ArtifactSphereHealing')
     ArtifactKeyConfigs(20)=(Alias="SelectSphereDamage",ArtifactClass=Class'DEKRPG999X.ArtifactSphereDamage')
     ArtifactKeyConfigs(21)=(Alias="SelectRemoteDamage",ArtifactClass=Class'DEKRPG999X.ArtifactRemoteDamage')
     ArtifactKeyConfigs(22)=(Alias="SelectRemoteInv",ArtifactClass=Class'DEKRPG999X.ArtifactRemoteInvulnerability')
     ArtifactKeyConfigs(23)=(Alias="SelectRemoteMax",ArtifactClass=Class'DEKRPG999X.ArtifactRemoteMax')
     ArtifactKeyConfigs(24)=(Alias="SelectShieldBlast",ArtifactClass=Class'DEKRPG999X.ArtifactShieldBlast')
     ArtifactKeyConfigs(25)=(Alias="SelectChain",ArtifactClass=Class'DEKRPG999X.ArtifactChainLightning')
     ArtifactKeyConfigs(26)=(Alias="SelectFireBall",ArtifactClass=Class'DEKRPG999X.ArtifactFireBall')
     ArtifactKeyConfigs(27)=(Alias="SelectRemoteBooster",ArtifactClass=Class'DEKRPG999X.ArtifactRemoteBooster')
     ArtifactKeyConfigs(28)=(Alias="SelectResurrect",ArtifactClass=Class'DEKRPG999X.ArtifactResurrect')
     ArtifactKeyConfigs(29)=(Alias="SelectInfinity",ArtifactClass=Class'DEKRPG999X.ArtifactMakeInfinity')
     ArtifactKeyConfigs(30)=(Alias="SelectLucky",ArtifactClass=Class'DEKRPG999X.ArtifactMakeLucky')
     ArtifactKeyConfigs(31)=(Alias="SelectMagnet",ArtifactClass=Class'DEKRPG999X.ArtifactPriestMagnet')
     ArtifactKeyConfigs(32)=(Alias="SelectMatrix",ArtifactClass=Class'DEKRPG999X.ArtifactMakeMatrix')
     ArtifactKeyConfigs(33)=(Alias="SelectDecoy",ArtifactClass=Class'DEKRPG999X.ArtifactDecoy')
     ArtifactKeyConfigs(34)=(Alias="SelectImmobilize",ArtifactClass=Class'DEKRPG999X.ArtifactImmobilize')
     ArtifactKeyConfigs(35)=(Alias="SelectGlowStreak",ArtifactClass=Class'DEKRPG999X.ArtifactGlowStreak')
     ArtifactKeyConfigs(36)=(Alias="SelectMeteor",ArtifactClass=Class'DEKRPG999X.ArtifactMeteorShower')
     ArtifactKeyConfigs(37)=(Alias="SelectRemoteAmplifier",ArtifactClass=Class'DEKRPG999X.ArtifactRemoteAmplifier')
     GroupName="DruidsRPG"
     FriendlyName="DEKRPG999X Druid's RPG Game Rules"
     Description="DEKRPG is an extension of DruidsRPG by Druid, Shantara and Szlat, and Mysterial's UT2004RPG. DEKRPG expands on abilities, artifacts, magic weapons, and adds an interactive mission system."
     bAlwaysRelevant=True
     RemoteRole=ROLE_SimulatedProxy
}
