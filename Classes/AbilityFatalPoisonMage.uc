class AbilityFatalPoisonMage extends AbilityNiche
	config(UT2004RPG)
	abstract;
	
var config int PlagueDamagePerLevel;
var config float PlagueLifespan;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local FatalInv Inv;
	
	Inv = FatalInv(Other.FindInventoryType(class'FatalInv'));
	if (Inv == None)
	{
		Inv = Other.Spawn(class'FatalInv');
		Inv.GiveTo(Other);
		Inv.PlagueDamage = (AbilityLevel * default.PlagueDamagePerLevel);
		Inv.PlagueLifespan = default.PlagueLifespan;
		Inv.PlagueMaxLifespan = default.PlagueLifespan;
	}
}

defaultproperties
{
     PlagueDamagePerLevel=3
     PlagueLifespan=5.000000
     ExcludingAbilities(0)=Class'DEKRPG208AE.AbilityDiseasedPoisonMage'
     RequiredAbilities(0)=Class'DEKRPG208AE.AbilityNecroPlague'
     AbilityName="Niche: Lethal"
     Description="Increases your plague damage by 3 per level. Reduces the maximum amount of time you can carry the plague and the maximum time you have with Phantom.||You must be level 180 and have Plague before buying this niche. You can not be in more than one niche at a time.||Cost(per level): 10"
     StartingCost=10
     MaxLevel=10
}
