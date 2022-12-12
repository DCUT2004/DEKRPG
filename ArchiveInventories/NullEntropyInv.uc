//-----------------------------------------------------------
//
//-----------------------------------------------------------
class NullEntropyInv extends Inventory;

const WIZARDRY = "Wizardry";
var MissionInvBETA MissionInv;
var Pawn PawnOwner;
var Material ModifierOverlay;
var int Modifier;
var Sound NullEntropySound;
var bool stopped;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
	reliable if (Role == ROLE_Authority)
		stopped;
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	local NecroInv NInv;
	local DEKRPGWeapon DW;
	local MagicalWardProtectionInv MWInv;
	local ComboWardInv WardInv;

	if(Other == None)
	{
		destroy();
		return;
	}
	
	PawnOwner = Other;
	
	stopped = false;
	
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
	}

	enable('Tick');
	
	if(Modifier < 7)
	{
		LifeSpan = (Modifier / 3) + ((7 - Modifier) * 0.1);
		SetTimer(0.1, true);
	}
	else
		LifeSpan = (Modifier / 3);
	
	if (PawnOwner != None)
	{
		PawnOwner.SetPhysics(PHYS_None);
		NInv = NecroInv(PawnOwner.FindInventoryType(class'NecroInv'));
		if(NInv != None)
		{
			Destroy();
			return;
		}
		MissionInv = Class'MissionInvBETA'.static.GetMissionInv(PawnOwner.Controller);
		if (MissionInv != None && MissionInv.IsMissionActive(WIZARDRY))
			MissionInv.TickMission(MissionInv.GetMissionIndex(WIZARDRY), 1);
		PawnOwner.PlaySound(NullEntropySound,,1.5 * PawnOwner.TransientSoundVolume,,PawnOwner.TransientSoundRadius);
		PawnOwner.setOverlayMaterial(ModifierOverlay, LifeSpan, true);
		if(PawnOwner.Controller != None && PlayerController(PawnOwner.Controller) != None)
			PlayerController(PawnOwner.Controller).ReceiveLocalizedMessage(class'NullEntropyConditionMessage', 0);
	}

	Super.GiveTo(Other);
}

function Tick(float deltaTime)
{
	if (PawnOwner != None)
	{
		if(!class'DEKRPGWeapon'.static.NullCanTriggerPhysics(PawnOwner))
			return;

		if(PawnOwner.Physics != PHYS_NONE)
			PawnOwner.setPhysics(PHYS_NONE);
	}
}

simulated function destroyed()
{
	stopEffect();
	disable('Tick');
	if(PawnOwner != None && PawnOwner.Physics == PHYS_NONE)
		PawnOwner.SetPhysics(PHYS_Falling);
	if (MissionInv != None)
		MissionInv.TickMission(MissionInv.GetMissionIndex(WIZARDRY), -1);
	super.destroyed();
}

function stopEffect()
{
	if(stopped)
		return;
	else
		stopped = true;
}

function Timer()
{
	if(LifeSpan <= (7 - Modifier) * 0.1)
	{
		SetTimer(0, true);
		disable('Tick');		
		PawnOwner.SetPhysics(PHYS_Falling);
	}
}

defaultproperties
{
     ModifierOverlay=Shader'MutantSkins.Shaders.MutantGlowShader'
     NullEntropySound=SoundGroup'WeaponSounds.Translocator.TranslocatorModuleRegeneration'
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
