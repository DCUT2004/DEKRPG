class VampireAddonPowerType extends AddonPowerType
	config(UT2004RPG);

var config float VampirePercent;

// DoPowerEffect - use the damage here (e.g. energy vampire etc)
function DoPowerEffect(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	local Pawn P;
	local int HealthBonus;
	local MagicShieldInv MInv;
	local Actor A;
	local Mission1Inv M1Inv;
	local Mission2Inv M2Inv;
	local Mission3Inv M3Inv;

	Super.DoPowerEffect(Damage, Victim, HitLocation, Momentum, DamageType);

	if (Pawn(Victim) == None)
		return;
	P = Pawn(Victim);

	if (TheWeapon.IsSameTeam(P))
		return;		// no vampire from hurting teammates

	MInv = MagicShieldInv(Pawn(Victim).FindInventoryType(class'MagicShieldInv'));
	if (MInv == None)
	{
    	if (Damage > P.Health)
    		HealthBonus = P.Health;
    	else
    		HealthBonus = Damage;
    	HealthBonus *= (VampirePercent/100.0) * float(TheWeapon.GetModifier());
    	if (HealthBonus == 0 && Damage>0)
    		HealthBonus = 1;
    
    	if (HealthBonus > 0)
        {
    		TheWeapon.Instigator.GiveHealth(HealthBonus, TheWeapon.Instigator.HealthMax + 50);

			M1Inv = Mission1Inv(P.FindInventoryType(class'Mission1Inv'));
			M2Inv = Mission2Inv(P.FindInventoryType(class'Mission2Inv'));
			M3Inv = Mission3Inv(P.FindInventoryType(class'Mission3Inv'));
			if (M1Inv != None && !M1Inv.Stopped && M1Inv.DraculaActive)
				M1Inv.MissionCount += HealthBonus;
			if (M2Inv != None && !M2Inv.Stopped && M2Inv.DraculaActive)
				M2Inv.MissionCount += HealthBonus;
			if (M3Inv != None && !M3Inv.Stopped && M3Inv.DraculaActive)
				M3Inv.MissionCount += HealthBonus;
            
            A = Spawn(Class'DEKEffectVampire',,,TheWeapon.Owner.Location,rotator(Normal(HitLocation - Location)));
            A.PlaySound(Sound'GeneralImpacts.Wet.Breakbone_04',,1.0 * TheWeapon.Owner.TransientSoundVolume,,TheWeapon.Owner.TransientSoundRadius);
        }
    }
}

function bool CanCoexist( class<AddonPowerType> NewType )
{
	if (!Super.CanCoexist(NewType ))
		return false;

	// Put in a test for rage Power type, and bounce
	if (NewType == class'RageAddonPowerType')
		return false;
	return true;
}

defaultproperties
{
	DamagePercent=3.0      // since having the life sucked out of you hurts
	VampirePercent=5.0
	PosName="Vampire"
	ZeroName="Vampire"
	NegName="Vampire"
	CanHaveZeroModifier=false
	CanHaveNegativeModifier=false
	AIBonus=0.1
	PowerOverlay=Shader'WeaponSkins.ShockLaser.LaserShader'
	ThisPickupClass=Class'VampireAddonPowerPickup'
}

