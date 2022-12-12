class FreezeInv extends Inventory;

const WIZARDRY = "Wizardry";
var MissionInvBETA MissionInv;
var Controller InstigatorController;
var Pawn PawnOwner;
var int Modifier;
var Material ModifierOverlay;
var bool stopped;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
	reliable if (Role == ROLE_Authority)
		stopped;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (Instigator != None)
		InstigatorController = Instigator.Controller;

	SetTimer(0.5, true);
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	local Pawn OldInstigator;
	local NecroInv NInv;
	local DEKRPGWeapon DW;
	local MagicalWardProtectionInv MWInv;
	local ComboWardInv WardInv;

	if(Other == None)
	{
		destroy();
		return;
	}

	stopped = false;
	if (InstigatorController == None)
		InstigatorController = Other.Controller;

	//want Instigator to be the one that caused the freeze
	OldInstigator = Instigator;
	PawnOwner = Other;
	
	if (PawnOwner != None)
	{
		WardInv = ComboWardInv(PawnOwner.FindInventoryType(Class'ComboWardInv'));
		if (WardInv != None && Rand(100) <= WardInv.EffectMultiplier)
		{
			if (Other.Controller != None && PlayerController(Other.Controller) != None)
				PlayerController(Other.Controller).ClientPlaySound(Sound'DEKRPG999X.ComboSounds.Ward');
			Destroy();
			return;
		}
		
		if (PawnOwner.Weapon != None && PawnOwner.Weapon.IsA('DEKRPGWeapon'))
		{
            DW = (DEKRPGWeapon(Other.Weapon));
    		if (DW.HasThisAddon(class'MagicalWardAddonPowerType'))
    		{
    			if (Rand(100) <= DW.GetModifier() * class'MagicalWardAddonPowerType'.default.ChanceToWardPerModifier)
    			{
    				MWInv = MagicalWardProtectionInv(Other.FindInventoryType(class'MagicalWardProtectionInv'));
    				if (MWInv == None)
    				{
    					MWInv = Other.Spawn(Class'MagicalWardProtectionInv');
    					MWInv.GiveTo(Other);
    				}
    				else
    				{
    					MWInv.Lifespan = MWInv.default.Lifespan;
    					MWInv.ProtectionMultiplier -= MWInv.ProtectionPerWardMultiplier;
    					if (MWInv.ProtectionMultiplier < MWInv.MaxProtectionMultiplier)
    						MWInv.ProtectionMultiplier = MWInv.MaxProtectionMultiplier;
    				}
    				if (Other.Controller != None && PlayerController(Other.Controller) != None)
    					PlayerController(Other.Controller).ClientPlaySound(Sound'DEKRPG999X.ComboSounds.Ward');
    				Destroy();
    				return;
    			}
            }
		}

		Instigator = OldInstigator;
		

		NInv = NecroInv(PawnOwner.FindInventoryType(class'NecroInv'));
		if(NInv != None)
		{
			Destroy();
			return;
		}
		PawnOwner.setOverlayMaterial(ModifierOverlay, (LifeSpan-2), true);
	
		MissionInv = Class'MissionInvBETA'.static.GetMissionInv(PawnOwner.Controller);
		if (MissionInv != None && MissionInv.IsMissionActive(WIZARDRY))
			MissionInv.TickMission(MissionInv.GetMissionIndex(WIZARDRY), 1);
	}
	Super.GiveTo(Other);
}

simulated function Timer()
{
	Local Actor A;
	if(!stopped)
	{

		if (Level.NetMode != NM_DedicatedServer && PawnOwner != None)
		{
			if (PawnOwner.IsLocallyControlled() && PlayerController(PawnOwner.Controller) != None)
				PlayerController(PawnOwner.Controller).ReceiveLocalizedMessage(class'FreezeConditionMessage', 0);
		}
		if (Role == ROLE_Authority)
		{
			if(Owner != None)
				A = PawnOwner.spawn(class'IceSmoke', PawnOwner,, PawnOwner.Location, PawnOwner.Rotation);

			if(!class'DEKRPGWeapon'.static.NullCanTriggerPhysics(PawnOwner))
			{
				stopEffect();
				return;
			}

			if(LifeSpan <= 0.5)
			{
				stopEffect();
				return;
			}

			if (Owner == None)
			{
				Destroy();
				return;
			}

			if (Instigator == None && InstigatorController != None)
				Instigator = InstigatorController.Pawn;
			else if(PawnOwner != None)
				class'AbilityIncreasedProtection'.static.quickfoot(-10 * Modifier, PawnOwner);
		}
	}
}

function stopEffect()
{
	if(stopped)
		return;
	else
		stopped = true;
	if(PawnOwner != None)
	{
		class'AbilityIncreasedProtection'.static.quickfoot(0, PawnOwner);
	}
}

simulated function destroyed()
{
	stopEffect();
	if (MissionInv != None)
		MissionInv.TickMission(MissionInv.GetMissionIndex(WIZARDRY), -1);
	super.destroyed();
}

defaultproperties
{
     ModifierOverlay=Shader'DEKRPGTexturesMaster209B.fX.PulseGreyShader'
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
