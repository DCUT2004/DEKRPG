class AbilityEnchanterCraftsman extends AbilityNiche
	config(UT2004RPG);
	
var config float AdrenMultiplier;
var config float MaxModifierMultiplier;

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

static function ModifyWeapon(Weapon Weapon, int AbilityLevel)
{
	local RPGWeapon W;
	
	if (Weapon != None && Weapon.IsA('RPGWeapon'))
		W = RPGWeapon(Weapon);
		
	if (W != None)
	{
		if (W.MaxModifier < W.default.MaxModifier*default.MaxModifierMultiplier)
		{
			W.MaxModifier *= default.MaxModifierMultiplier;
		}
	}
}

defaultproperties
{
     AdrenMultiplier=0.250000000
     MaxModifierMultiplier=2.000000
     ExcludingAbilities(0)=Class'DEKRPG208AJ.AbilityPriestCraftsman'
     ExcludingAbilities(1)=Class'DEKRPG208AJ.AbilityPaladinCraftsman'
     AbilityName="Niche: Enchanter"
     Description="Increases the max modifier on all magic weapons, but reduces your max adrenaline by 25%.|You must be level 180 to buy a niche. You can not be in more than one niche at a time.|Cost(per level): 50"
     StartingCost=50
     MaxLevel=1
}
