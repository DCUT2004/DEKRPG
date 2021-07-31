class AbilityRageEWM extends AbilityNiche
	config(UT2004RPG) 
	abstract;
	
var config float MaxDamageIncrease;
var config int HealthReductionPerLevel;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local HealthReducerInv Inv;
	
	if (Other != None)
		Inv = HealthReducerInv(Other.FindInventoryType(class'HealthReducerInv'));
		
	if (Inv == None)
	{
		Inv = Other.spawn(class'HealthReducerInv');		
		Inv.AbilityLevel = AbilityLevel;
		Inv.HealthReductionPerLevel = default.HealthReductionPerLevel;
		Inv.giveTo(Other);
	}
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	local float DamageToMultiply;

	if (!bOwnedByInstigator)
		return;
	if (Damage > 0 && bOwnedByInstigator)
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
     HealthReductionPerLevel=10
     ExcludingAbilities(0)=Class'DEKRPG208AD.AbilityPrimalEWM'
     ExcludingAbilities(1)=Class'DEKRPG208AD.AbilityBloodLustEWM'
     AbilityName="Niche: Vengeance"
     Description="Each level of this ability increases your cumulative damage bonus as your health decreases. Your maximum health bonus decreases by 10 per level.|You must be level 180 to buy a niche. You can not be in more than one niche at a time. Cost (per level): 10."
     StartingCost=10
     MaxLevel=20
}
