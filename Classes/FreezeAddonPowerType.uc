class FreezeAddonPowerType extends AddonPowerType
	config(UT2004RPG);

var config float IceOnEarthDamageBonus;
var Sound FreezeSound;

function AdjustDamage(out int Damage, int OriginalDamage, Actor Victim, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
	local Pawn P;
	local EarthInv EInv;

	Super.AdjustDamage(Damage, OriginalDamage, Victim, HitLocation, Momentum, DamageType);

	// now if it is an earth monster do more damage
	if (Damage > 0)
	{
		P = Pawn(Victim);
		if (P != None && P.Health > 0)
		{
			EInv = EarthInv(P.FindInventoryType(class'EarthInv'));
			if (EInv != None)
			{
                // do more damage to Earth monsters
				Damage *= (1.0 + IceOnEarthDamageBonus * TheWeapon.GetModifier());
				Momentum *= 1.0 + IceOnEarthDamageBonus * TheWeapon.GetModifier();
			}
		}
	}

}

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

	Super.DoPowerEffect(Damage, Victim, HitLocation, Momentum, DamageType);

	if (Pawn(Victim) == None)
		return;
	P = Pawn(Victim);

	if (TheWeapon.IsSameTeam(P))
		return;

	if (Damage <= 0 || Victim.isA('Vehicle') || TheWeapon.GetModifier() <= 0)
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

	if (NewType == class'FreezeAddonPowerType')	   	// too similar
		return false;

	return true;
}

defaultproperties
{
	DamagePercent=2.0      // since Freezing hurts
    IceOnEarthDamageBonus=0.100000
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

