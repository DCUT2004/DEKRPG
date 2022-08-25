class SuperHeatAddonPowerType extends AddonPowerType
	config(UT2004RPG);

var config int HeatLifespan;

static function bool AllowedFor(Weapon W)
{
	// check if superweapon 
	if (W == None)
		return false;

	if(instr(caps(W), "BLIZZARD") > -1)
		return false;
	if(instr(caps(W), "BEAM") > -1)
		return false;

	return true;
}

// DoPowerEffect - use the damage here (e.g. energy vampire etc)
function DoPowerEffect(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	local StatusEffectInventory StatusInv;
	local FireInv FInv;
	local MagicShieldInv MInv;
	local Pawn P;
	local Actor A;
	local IceInv IInv;
	local MissionInvBETA MissionInv;
	local int LocalModifier;

	Super.DoPowerEffect(Damage, Victim, HitLocation, Momentum, DamageType);

	if (Pawn(Victim) == None)
		return;
	P = Pawn(Victim);

	if (TheWeapon.IsSameTeam(P))
		return;

	if (Damage <= 0 || Victim.isA('Vehicle') || TheWeapon.GetModifier() <= 0)
		return;

	FInv = FireInv(P.FindInventoryType(class'FireInv'));
	if (FInv != None)     // if it is already on fire then we can't ignite it
		return;

	if (P != None && TheWeapon.static.NullCanTriggerPhysics(P))
	{
		MInv = MagicShieldInv(P.FindInventoryType(class'MagicShieldInv'));
		if (MInv == None)
		{
			StatusInv = StatusEffectInventory(P.FindInventoryType(Class'StatusEffectInventory'));
			if (StatusInv == None)
				return;
			LocalModifier = TheWeapon.GetModifier();
    		IInv = IceInv(P.FindInventoryType(class'IceInv'));
			if (IInv != None)
			{
    			A = P.spawn(class'HeatHitEffect', P,, P.Location, P.Rotation);
    			if (A != None)
    				A.RemoteRole = ROLE_SimulatedProxy;
				LocalModifier += 1;
			}
			if (StatusInv.AddStatusEffect(Class'StatusEffect_Burn', -LocalModifier, HeatLifespan, True, False, TheWeapon.Instigator)  != None)
			{
				if (TheWeapon.Instigator != None && TheWeapon.Instigator.Controller != None)
				{
					MissionInv = class'MissionInvBETA'.static.GetMissionInv(TheWeapon.Instigator.Controller);
					if (MissionInv == None)
						return;
					if (!MissionInv.IsMissionActive("Pyromancer"))
						return;
					if (TheWeapon.GetModifier() > 2)
						MissionInv.TickMission(MissionInv.GetMissionIndex("Pyromancer"), 1);
				}
			}
        }
	}
}

function bool CanCoexist( class<AddonPowerType> NewType )
{
	if (!Super.CanCoexist(NewType ))
		return false;

	if (NewType == class'FreezeAddonPowerType')	   	// opposite
		return false;

	if (NewType == class'EarthAddonPowerType')	   	// opposite
		return false;

	if (NewType == class'SuperHeatAddonPowerType')	   	// 2 of them doesn't really work
		return false;

	return true;
}

defaultproperties
{
	DamagePercent=2.0      // since burning hurts
    DamageBonusAgainstEarthMonsters=-0.020000
    DamageBonusAgainstIceMonsters=0.100000
    DamageBonusAgainstFireMonsters=0.000000
    HeatLifespan=4
	PosName="Heat"
	ZeroName=""
	NegName=""
	CanHaveZeroModifier=false
	CanHaveNegativeModifier=false
	AIBonus=0.1
	PowerOverlay=FinalBlend'DEKWeaponsMaster206.fX.SuperHeatFB'
	ThisPickupClass=Class'SuperHeatAddonPowerPickup'
}

