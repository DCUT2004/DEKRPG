class WaterfallAddonPowerType extends AddonPowerType
	config(UT2004RPG);

var config float WaterfallCheckTime;
var float NextEffectTime;

simulated event WeaponTick(float dt)
{
	NextEffectTime -= dt;
	if (NextEffectTime <= 0)
	{
        if (TheWeapon.GetModifier() > 0)
            Pawn(TheWeapon.Owner).GiveHealth(TheWeapon.GetModifier(), Pawn(TheWeapon.Owner).HealthMax);
		NextEffectTime = WaterfallCheckTime;
	}
}


function bool CanCoexist( class<AddonPowerType> NewType )
{
	if (!Super.CanCoexist(NewType ))
		return false;

	if (NewType == class'WaterfallAddonPowerType')	// double gets complicated
		return false;
    
	return true;
}

defaultproperties
{
	WaterfallCheckTime=1.0
	NextEffectTime=1.0
	PosName="Waterfall"
	ZeroName="Waterfall"
	NegName="Waterfall"
	CanHaveZeroModifier=false
	CanHaveNegativeModifier=false	// do not allow misfortune by default
	AIBonus=0.1
	PowerOverlay=FinalBlend'AWGlobal.Shaders.ColdFinal'
	ThisPickupClass=Class'WaterfallAddonPowerPickup'
}

