class SuperHeatInv extends Inventory
	config(UT2004RPG);
	
var RPGRules RPGRules;

var config float BasePercentage;
var config float Curve;
var config float AdrenLost;
var bool stopped;
var SuperHeatFX FX;
var Pawn PawnOwner;
var Controller InstigatorController;
var int Modifier;
var config int MaxHeatDamage;
var Pawn Doer;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
	reliable if (Role == ROLE_Authority)
		stopped;
}
	
function GiveTo(Pawn Other, optional Pickup Pickup)
{
	local MissionInv MiInv;
	local Mission1Inv M1Inv;
	local Mission2Inv M2Inv;
	local MIssion3Inv M3Inv;
	local xPawn X;
	local RW_MagicalWard W;
	local MagicalWardProtectionInv MWInv;
	local ComboWardInv WardInv;
	
	if (InstigatorController == None)
		InstigatorController = Other.DelayedDamageInstigatorController;
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
	
		if (PawnOwner.Weapon != None && PawnOwner.Weapon.IsA('RW_MagicalWard'))
		{
			W = RW_MagicalWard(PawnOwner.Weapon);
			if (Rand(100) <= W.Modifier*W.ChanceToWardPerModifier)
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
		
		MiInv = MissionInv(PawnOwner.FindInventoryType(class'MissionInv'));
		M1Inv = Mission1Inv(PawnOwner.FindInventoryType(class'Mission1Inv'));
		M2Inv = Mission2Inv(PawnOwner.FindInventoryType(class'Mission2Inv'));
		M3Inv = Mission3Inv(PawnOwner.FindInventoryType(class'Mission3Inv'));
		
		if (MiInv != None && !MiInv.WizardryComplete)
		{
			if (M1Inv != None && !M1Inv.Stopped && M1Inv.WizardryActive)
			{
				M1Inv.MissionCount++;
			}
			if (M2Inv != None && !M2Inv.Stopped && M2Inv.WizardryActive)
			{
				M2Inv.MissionCount++;
			}
			if (M3Inv != None && !M3Inv.Stopped && M3Inv.WizardryActive)
			{
				M3Inv.MissionCount++;
			}
		}
	
		X = xPawn(PawnOwner);
		FX = Spawn(class'SuperHeatFX', PawnOwner,, PawnOwner.Location);
		if (FX != None)
		{
			//FX.Emitters[0].SkeletalMeshActor = X;
			FX.SetLocation(PawnOwner.Location);
			FX.SetRotation(PawnOwner.Rotation + rot(0, -16384, 0));
			FX.SetBase(PawnOwner);
			FX.bOwnerNoSee = true;
			FX.RemoteRole = ROLE_SimulatedProxy;
		}
		SetTimer(1, True);
	}
	Super.GiveTo(Other);
}

static function AddHealableDamage(int Damage, Pawn Injured)
{
	Local HealableDamageInv Inv;

	if(Injured == None || Injured.Controller == None || Injured.Health <= 0 || Damage < 1)
		return; // Not EXP Healable

	if(Injured.isA('Monster') && !Injured.Controller.isA('DEKFriendlyMonsterController'))
		return; 	// No tracking for not friendly monsters.

	Inv = HealableDamageInv(Injured.FindInventoryType(class'HealableDamageInv'));
	if(Inv == None)
	{
		Inv = Injured.spawn(class'HealableDamageInv');
		Inv.giveTo(Injured);
	}

	if(Inv == None)
	    return;

	Inv.Damage += Damage;

	if(Inv.Damage > Injured.HealthMax + Class'HealableDamageGameRules'.default.MaxHealthBonus)
		Inv.Damage = Injured.HealthMax + Class'HealableDamageGameRules'.default.MaxHealthBonus;
}

simulated function Timer()
{
	local int HeatDamage;

	if (Owner == None)
	{
		Destroy();
		return;
	}

	if (PawnOwner == None)
	{
		Destroy();
		return;     // cant do anything
	}

	if (Instigator == None && InstigatorController != None)
		Instigator = InstigatorController.Pawn;

	HeatDamage = int(float(PawnOwner.Health) * (Curve **(float(Modifier-1))*BasePercentage));
	if (HeatDamage > MaxHeatDamage)
		HeatDamage = MaxHeatDamage;

	if(HeatDamage > 0)
	{
		if(PawnOwner.Controller != None && PawnOwner.Controller.bGodMode == False
			&& InvulnerabilityInv(PawnOwner.FindInventoryType(class'InvulnerabilityInv')) == None)
		{
			if (PawnOwner.Controller.Adrenaline > 0)
				PawnOwner.Controller.Adrenaline -= (Modifier*AdrenLost);
			if (PawnOwner.Controller.Adrenaline < 0)
				PawnOwner.Controller.Adrenaline = 0;
				
			if (PawnOwner.Health <= HeatDamage)
				HeatDamage = PawnOwner.Health -1;
			PawnOwner.Health -= HeatDamage;
			
			if(Instigator != None && Instigator.Controller != None && Instigator != PawnOwner) //exp only for harming others.
			{
				if (RPGRules != None)
					RPGRules.AwardEXPForDamage(Instigator.Controller, RPGStatsInv(Instigator.FindInventoryType(class'RPGStatsInv')), PawnOwner, HeatDamage);
				// and add the damage as healable
				class'SuperHeatInv'.static.AddHealableDamage(HeatDamage, PawnOwner);
			}
			else if (InstigatorController != None && InstigatorController.Pawn != None && InstigatorController.Pawn != PawnOwner)
			{
				if (RPGRules != None)
					RPGRules.AwardEXPForDamage(InstigatorController, RPGStatsInv(InstigatorController.Pawn.FindInventoryType(class'RPGStatsInv')), PawnOwner, HeatDamage);
				// and add the damage as healable
				class'SuperHeatInv'.static.AddHealableDamage(HeatDamage, PawnOwner);
			}
		}
	}
	PawnOwner.ReceiveLocalizedMessage(class'SuperHeatConditionMessage', 0);
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
	stopEffect();
	if (FX != None)
	{
		FX.Kill();
		FX.Destroy();
	}
	super.destroyed();
}

defaultproperties
{
     BasePercentage=0.050000
     curve=1.300000
     AdrenLost=-0.150000
     MaxHeatDamage=50
     bOnlyRelevantToOwner=False
}
