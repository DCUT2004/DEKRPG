class MagicalWardAddonPowerType extends AddonPowerType
	config(UT2004RPG);

var config int ChanceToWardPerModifier;

function AdjustPlayerDamage(out int Damage, Pawn InstigatedBy, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	local MagicalWardProtectionInv Inv;

	if (TheWeapon.Instigator != None && TheWeapon.Instigator.Health > 0)
	{
		Inv = MagicalWardProtectionInv(TheWeapon.Instigator.FindInventoryType(class'MagicalWardProtectionInv'));
		if (Inv != None)
		{
			Damage *= Inv.ProtectionMultiplier;
			if (Damage < 1)
				Damage = 1;
		}
	}
}

function bool CanCoexist( class<AddonPowerType> NewType )
{
	if (!Super.CanCoexist(NewType ))
		return false;

    	// could refuse Protection, but let's try it first
	if (NewType == class'MagicalWardAddonPowerType')
		return false;
    
	return true;
}

defaultproperties
{
	ChanceToWardPerModifier=10		
	PosName="Magical Ward"
	ZeroName=""
	NegName=""
	CanHaveZeroModifier=false
	CanHaveNegativeModifier=false
	AIBonus=0.1
	PowerOverlay=FinalBlend'FireEngine.Liquids.river-finalblend'
	ThisPickupClass=Class'MagicalWardAddonPowerPickup'
}

