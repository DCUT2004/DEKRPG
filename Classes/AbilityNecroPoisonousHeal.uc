class AbilityNecroPoisonousHeal extends CostRPGAbility
	config(UT2004RPG) 
	abstract;
	
var config int RegenPerLevel;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local PlagueRegenInv Inv;
	
	if (Other != None)
	{
		Inv = PlagueRegenInv(Other.FindInventoryType(class'PlagueRegenInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(Class'PlagueRegenInv');
			Inv.AbilityLevel = AbilityLevel;
			Inv.RegenAmount = AbilityLevel * default.RegenPerLevel;
			Inv.GiveTo(Other);
		}
	}
}

defaultproperties
{
	 RegenPerLevel=1
	 RequiredAbilities(0)=Class'DEKRPG209B.AbilityNecroPlague'
     MinHealthBonus=30
     HealthBonusStep=30
     AbilityName="Poisonous Regeneration"
     Description="Regenerates 1 health per second per level while you are carrying the plague. Does not heal past starting health amount.|You must have at least level one of Plague before buying this ability. You must have a Health Bonus stat equal to 30 times the ability level you wish to have before you can purchase it.||Cost (per level): 5,10,15..."
     StartingCost=5
     CostAddPerLevel=5
     MaxLevel=5
}
