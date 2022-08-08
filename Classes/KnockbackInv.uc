class KnockbackInv extends Inventory;

const WIZARDRY = "Wizardry";
var MissionInvBETA MissionInv;
var Pawn PawnOwner;
var int Modifier;
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
		NInv = NecroInv(PawnOwner.FindInventoryType(class'NecroInv'));
		if(NInv != None)
		{
			if (Other.Controller != None && PlayerController(Other.Controller) != None)
				PlayerController(Other.Controller).ClientPlaySound(Sound'DEKRPG999X.ComboSounds.Ward');
			Destroy();
			return;
		}
		WardInv = ComboWardInv(PawnOwner.FindInventoryType(Class'ComboWardInv'));
		if (WardInv != None && Rand(100) <= WardInv.EffectMultiplier)
		{
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
		
		MissionInv = Class'MissionInvBETA'.static.GetMissionInv(PawnOwner.Controller);
		if (MissionInv != None && MissionInv.IsMissionActive(WIZARDRY))
			MissionInv.TickMission(MissionInv.GetMissionIndex(WIZARDRY), 1);

		SetTimer(1/Modifier, true);
	}
	Super.GiveTo(Other);
}

function stopEffect()
{
	if(stopped)
		return;
	else
		stopped = true;
}

simulated function Destroyed()
{
	if(PawnOwner == None)
		return;

	if(PawnOwner.Physics != PHYS_Walking && PawnOwner.Physics != PHYS_Falling) //still going?
		PawnOwner.setPhysics(PHYS_Falling);
	stopEffect();
	if (MissionInv != None)
		MissionInv.TickMission(MissionInv.GetMissionIndex(WIZARDRY), -1);
	super.destroyed();
}

function Timer()
{
	local DruidGhostInv dgInv;
	local GhostInv gInv;

	//if ghost is running destroying this is a really bad thing. let the timer tick till they're done.
	dgInv = DruidGhostInv(PawnOwner.FindInventoryType(class'DruidGhostInv'));
	if(dgInv != None && !dgInv.bDisabled)
		return;

	gInv = GhostInv(PawnOwner.FindInventoryType(class'GhostInv'));
	if(gInv != None && !gInv.bDisabled)
		return;

	if(PawnOwner.Physics != PHYS_Hovering && PawnOwner.Physics != PHYS_Falling)
		Destroy();
}

defaultproperties
{
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
