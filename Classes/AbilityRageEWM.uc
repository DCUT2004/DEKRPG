class AbilityRageEWM extends AbilityNiche
	config(UT2004RPG) 
	abstract;
	
var config float MaxDamageIncrease;
var config int HealthMultiplier;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local HealthMaxModifierInv Inv;
	
	if (Other != None)
	{
		Inv = HealthMaxModifierInv(Other.FindInventoryType(Class'HealthMaxModifierInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(Class'HealthMaxModifierInv');
			Inv.Multiplier = abs((AbilityLevel*default.HealthMultiplier)-1);
			Inv.GiveTo(Other);
		}
	}
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	local float DamageToMultiply;

	if (!bOwnedByInstigator)
		return;
	if (Damage > 0)
	{
		DamageToMultiply = ((AbilityLevel / Instigator.Health) * 15) +1;
		if (DamageToMultiply > default.MaxDamageIncrease)
			DamageToMultiply = default.MaxDamageIncrease;
		Damage *= DamageToMultiply;
	}
}

defaultproperties
{
     MaxDamageIncrease=1.750000
     HealthMultiplier=0.030000000
     ExcludingAbilities(0)=Class'DEKRPG999X.AbilityPrimalEWM'
     ExcludingAbilities(1)=Class'DEKRPG999X.AbilityBloodLustEWM'
     AbilityName="Niche: Vengeance"
     Description="Each level of this ability increases your cumulative damage bonus as your health decreases. Your maximum health bonus decreases by 3% per level.|You must be level 180 to buy a niche. You can not be in more than one niche at a time. Cost (per level): 10."
     StartingCost=10
     MaxLevel=20
}
