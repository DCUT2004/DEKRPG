class FreezeAddonPowerType extends AddonPowerType
	config(UT2004RPG);

var Sound FreezeSound;

// DoPowerEffect - use the damage here (e.g. energy vampire etc)
function DoPowerEffect(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	local FreezeInv FrInv;
	local MagicShieldInv MInv;
	local Pawn P;
	local Actor A;
	local EarthInv EInv;
	local MissionInv MiInv;
	local Mission1Inv M1Inv;
	local Mission2Inv M2Inv;
	local MIssion3Inv M3Inv;
	local IceInv IInv;

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
    		//dont add to the time a pawn is already frozen. It just wouldn't be fair.
    		FrInv = FreezeInv(P.FindInventoryType(class'FreezeInv'));
    		if (FrInv == None)
    		{
    			FrInv = spawn(class'FreezeInv', P,,, rot(0,0,0));
    			FrInv.Modifier = TheWeapon.GetModifier();
    			FrInv.LifeSpan = TheWeapon.GetModifier();
    			EInv = EarthInv(P.FindInventoryType(class'EarthInv'));
    			if (EInv != None)
    			{
    				// slightly longer freeze effect
        				FrInv.Modifier += 1;
        				FrInv.LifeSpan += 1;
    			}
    			FrInv.GiveTo(P);
    			A = P.spawn(class'IceSmoke', P,, P.Location, P.Rotation);
    			if (A != None)
    			{
    				A.RemoteRole = ROLE_SimulatedProxy;
    				A.PlaySound(FreezeSound,,2.5*Victim.TransientSoundVolume,,Victim.TransientSoundRadius);
    			}

    			MiInv = MissionInv(TheWeapon.Instigator.FindInventoryType(class'MissionInv'));
    			M1Inv = Mission1Inv(TheWeapon.Instigator.FindInventoryType(class'Mission1Inv'));
    			M2Inv = Mission2Inv(TheWeapon.Instigator.FindInventoryType(class'Mission2Inv'));
    			M3Inv = Mission3Inv(TheWeapon.Instigator.FindInventoryType(class'Mission3Inv'));
				if (M1Inv != None && !M1Inv.Stopped && M1Inv.FrostmancerActive)
				{
					M1Inv.MissionCount++;
					if (TheWeapon.GetModifier() > 2)
						M1Inv.MissionCount++;
				}
				if (M2Inv != None && !M2Inv.Stopped && M2Inv.FrostmancerActive)
				{
					M2Inv.MissionCount++;
					if (TheWeapon.GetModifier() > 2)
						M2Inv.MissionCount++;
				}
				if (M3Inv != None && !M3Inv.Stopped && M3Inv.FrostmancerActive)
				{
					M3Inv.MissionCount++;
					if (TheWeapon.GetModifier() > 2)
						M3Inv.MissionCount++;
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

