class AbilityEternalSoulSorcerer extends AbilityNiche
	config(UT2004RPG)
	abstract;
	
var config int HealthBonusPerLevel;
var config float HealthMultiplierPerLevel;
var config float WeaponDamage;

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local DecayInv Inv;
	
	Inv = DecayInv(Other.FindInventoryType(class'DecayInv'));
	if (Inv != None)
	{
		Inv.DecayBonus = (Inv.default.DecayBonus + (default.HealthBonusPerLevel*AbilityLevel));
		Inv.HealthMultiplier = (Inv.default.HealthMultiplier + (default.HealthMultiplierPerLevel*AbilityLevel));
	}
	else
		return;
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if(!bOwnedByInstigator)
		return;
	if(Damage > 0)
	{
		if (!DamageType.IsA('DamTypeBloodSpear') && !DamageType.IsA('DamTypeBloodBurst') && (ClassIsChildOf(DamageType, class'WeaponDamageType') || ClassIsChildOf(DamageType, class'VehicleDamageType')))
			Damage *= default.WeaponDamage;
	}
}

defaultproperties
{
     HealthBonusPerLevel=20
     HealthMultiplierPerLevel=0.010000
     WeaponDamage=0.850000
     ExcludingAbilities(0)=Class'DEKRPG208AE.AbilityMasterSoulSorcerer'
     RequiredAbilities(0)=Class'DEKRPG208AE.AbilityNecroDecay'
     AbilityName="Niche: Eternal"
     Description="Increases your max health when healing with Blood Magic by 20 per level, and increases the amount of healing by 1% per level. Decreases your weapon damage by 15%, except for the Blood Magic weapon.||You must be level 180 and have Blood Magic before buying this niche. You can not be in more than one niche at a time.||Cost(per level): 10"
     StartingCost=10
     MaxLevel=10
}
