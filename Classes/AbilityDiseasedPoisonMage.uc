class AbilityDiseasedPoisonMage extends AbilityNiche
	config(UT2004RPG)
	abstract;
	
var config float DamageReduction;
var config float PlagueBlastDamageMultiplier, PlagueBlastRadiusMultiplier;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local DiseasedInv DInv;
	
	DInv = DiseasedInv(Other.FindInventoryType(class'DiseasedInv'));
	if (DInv == None)
	{
		DInv = Other.Spawn(class'DiseasedInv');
		DInv.GiveTo(Other);
		DInv.PlagueBlastDamageMultiplier = 1 + (AbilityLevel*default.PlagueBlastDamageMultiplier);
		DInv.PlagueBlastRadiusMultiplier = 1 + (AbilityLevel*default.PlagueBlastRadiusMultiplier);
	}
}

defaultproperties
{
     DamageReduction=0.800000
     PlagueBlastDamageMultiplier=0.050000
     PlagueBlastRadiusMultiplier=0.100000
     ExcludingAbilities(0)=Class'DEKRPG208AJ.AbilityFatalPoisonMage'
     RequiredAbilities(0)=Class'DEKRPG208AJ.AbilityNecroPlague'
     AbilityName="Niche: Diseased"
     Description="Provides a chance to produce explosions when enemies infected with your plague die. You cannot gain adrenaline with the Adrenaline Drip ability while carrying the plague.||Each level of this ability increases the damage of the explosion by 5% and the radius of the explosion by 10%.||You must be level 180 and have Plague before buying this niche. You can not be in more than one niche at a time.||Cost(per level): 10"
     StartingCost=10
     MaxLevel=10
}
