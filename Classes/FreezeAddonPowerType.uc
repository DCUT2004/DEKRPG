class FreezeAddonPowerType extends AddonPowerType
	config(UT2004RPG);

var Sound FreezeSound;

static function bool AllowedFor(Weapon W)
{
	// check if superweapon 
	if (W == None)
		return false;

	if(instr(caps(W), "FIREBALL") > -1)
		return false;
	if(instr(caps(W), "HEATWHIP") > -1)
		return false;
	if(instr(caps(W), "BLIZZARD") > -1)
		return false;
	if(instr(caps(W), "MAGNET") > -1)
		return false;

	return true;
}

// DoPowerEffect - use the damage here (e.g. energy vampire etc)
function DoPowerEffect(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	local StatusEffectInventory StatusInv;
	local MagicShieldInv MInv;
	local Pawn P;
	local EarthInv EInv;
	local MissionInvBETA MissionInv;
	local IceInv IInv;
	local int LocalModifier;

	Super.DoPowerEffect(Damage, Victim, HitLocation, Momentum, DamageType);

	if (Pawn(Victim) == None)
		return;
	P = Pawn(Victim);

	if (TheWeapon.IsSameTeam(P))
		return;

	if (Damage <= 0 || Victim.isA('Vehicle') || TheWeapon.GetModifier() <= 0)
		return;

	IInv = IceInv(P.FindInventoryType(class'IceInv'));
	if (IInv != None)     // cant freeze something already frozen
		return;

	if (P != None && TheWeapon.static.NullCanTriggerPhysics(P))
	{
		MInv = MagicShieldInv(P.FindInventoryType(class'MagicShieldInv'));
		if (MInv == None)
		{
			StatusInv = StatusEffectInventory(Class'StatusEffectManager'.static.GetStatusEffectManager(P));
			if (StatusInv == None)
				return;
			LocalModifier = TheWeapon.GetModifier();
			EInv = EarthInv(P.FindInventoryType(Class'EarthInv'));
			if (EInv != None)
				LocalModifier += 1;
            LocalModifier *= PerformanceIncrease;
			if (StatusInv.AddStatusEffect(Class'StatusEffect_Speed', -LocalModifier, True, LocalModifier, true, false))
			{
				if (TheWeapon.Instigator != None && TheWeapon.Instigator.Controller != None)
				{
					MissionInv = class'MissionInvBETA'.static.GetMissionInv(TheWeapon.Instigator.Controller);
					if (MissionInv == None)
						return;
					if (!MissionInv.IsMissionActive("Frostmancer"))
						return;
					if (TheWeapon.GetModifier() > 2)
						MissionInv.TickMission(MissionInv.GetMissionIndex("Frostmancer"), 1);
				}
			}
	
        }
	}
}

function bool CanCoexist( class<AddonPowerType> NewType )
{
	if (!Super.CanCoexist(NewType ))
		return false;

	if (NewType == class'FreezeAddonPowerType')	   	// 2 of them doesn't really work
		return false;

	if (NewType == class'EarthAddonPowerType')	   	// opposite
		return false;

	if (NewType == class'SuperHeatAddonPowerType')	   	// opposite
		return false;

	if (NewType == class'ForceAddonPowerType')	   	// not really compatible
		return false;
	if (NewType == class'KnockbackAddonPowerType')	   	// not really compatible
		return false;

	return true;
}

defaultproperties
{
	DamagePercent=2.0      // since Freezing hurts
    DamageBonusAgainstEarthMonsters=0.100000
    DamageBonusAgainstIceMonsters=0.000000
    DamageBonusAgainstFireMonsters=-0.020000
	FreezeSound=Sound'Slaughtersounds.Machinery.Heavy_End'
	PosName="Freezing"
	ZeroName=""
	NegName=""
	CanHaveZeroModifier=false
	CanHaveNegativeModifier=false
	AIBonus=0.1
	PowerOverlay=TexPanner'DEKWeaponsMaster206.fX.GreyPanner'
	ThisPickupClass=Class'FreezeAddonPowerPickup'
}

