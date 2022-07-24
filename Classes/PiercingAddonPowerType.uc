class PiercingAddonPowerType extends AddonPowerType
	config(UT2004RPG);

function bool CanCoexist( class<AddonPowerType> NewType )
{
	if (!Super.CanCoexist(NewType ))
		return false;

	// need a test for piercing Power type, and bounce, because two piercings dont help much
	if (NewType == class'PiercingAddonPowerType')
		return false;
	return true;
}

function AdjustDamage(out int Damage, int OriginalDamage, Actor Victim, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
    local Actor A;
    
	Super.AdjustDamage(Damage, OriginalDamage, Victim, HitLocation, Momentum, DamageType);

	Damage = Max(Damage, OriginalDamage);
    
	//ugly, but it works
	DamageType.default.bArmorStops = false;

	 A = Spawn(Class'DEKEffectPiercing',,,Victim.Location,rotator(Normal(HitLocation - Location)));
	if ( A != None )
    {
        A.RemoteRole = ROLE_SimulatedProxy;
        A.PlaySound(Sound'WeaponSounds.BaseFiringSounds.BAssaultRifleFire',,1.0 * TheWeapon.Owner.TransientSoundVolume,,TheWeapon.Owner.TransientSoundRadius);
    }
}

defaultproperties
{
	PosName="Piercing"
	ZeroName="Piercing"
	NegName="Piercing"
	CanHaveZeroModifier=true
	CanHaveNegativeModifier=true
	AIBonus=0.1
	PowerOverlay=FinalBlend'DEKWeaponsMaster206.fX.PiercingFB'
	ThisPickupClass=Class'PiercingAddonPowerPickup'
}

