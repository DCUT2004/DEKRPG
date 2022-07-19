class DamageAddonPowerType extends AddonPowerType
	config(UT2004RPG);

defaultproperties
{
	DamagePercent=10.0		// a further 10%
	PosName="Damage"
	ZeroName=""
	NegName="Damage"
	CanHaveZeroModifier=false
	CanHaveNegativeModifier=true
	AIBonus=0.1
	PowerOverlay=FinalBlend'AWGlobal.Shaders.RedCrystalFinal'
	ThisPickupClass=Class'DamageAddonPowerPickup'
}

