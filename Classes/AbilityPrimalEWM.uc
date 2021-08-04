class AbilityPrimalEWM extends AbilityEnhancedWeaponSpeed
	config(UT2004RPG) 
	abstract;
	
var config int AdrenMultiplier;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local AdrenMaxModifierInv Inv;
	
	if (Other != None)
	{
		Inv = AdrenMaxModifierInv(Other.FindInventoryType(Class'AdrenMaxModifierInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(Class'AdrenMaxModifierInv');
			Inv.Multiplier = abs((AbilityLevel*default.AdrenMultiplier)-1);
			Inv.GiveTo(Other);
		}
	}
}

defaultproperties
{
     AdrenMultiplier=0.050000000
     SpeedMultiplier=0.050000
     PlayerLevelReqd(1)=180
     ExcludingAbilities(0)=Class'DEKRPG208AF.AbilityBloodLustEWM'
     ExcludingAbilities(1)=Class'DEKRPG208AF.AbilityRageEWM'
     AbilityName="Niche: Primal"
     Description="Increases your cumulative weapon speed by 5% per level, but also decreases your max adrenaline by 5% per level.|You must be level 180 to buy a niche. You can not be in more than one niche at a time. Cost (per level): 10."
     StartingCost=10
}
