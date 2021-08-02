class AbilityEnhancedHealthMax extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

var config float HealthMultiplier;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local HealthMaxModifierInv Inv;
	
	if (Other != None)
	{
		Inv = HealthMaxModifierInv(Other.FindInventoryType(Class'HealthMaxModifierInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(Class'HealthMaxModifierInv');
			Inv.Multiplier = 1 + (AbilityLevel*default.HealthMultiplier);
			Inv.GiveTo(Other);
		}
	}
}

defaultproperties
{
	 HealthMultiplier=0.0100000000
     MinHealthBonus=200
     AbilityName="Advanced Health Bonus"
     Description="Increases your cumulative health bonus by 1% per level.||You you need to have at least 200 Health Bonus to purchase this ability.||Cost(per level): 5."
     StartingCost=5
     MaxLevel=20
}
