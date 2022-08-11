class AbilityMaterialStarChart extends AbilityMaterialVeryHighRarity
	config(UT2004RPG)
	abstract;
	
var config float LevMultiplier;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local AdrenMaxMaterialInv Inv;
	
	if (Other != None)
	{
		Inv = AdrenMaxMaterialInv(Other.FindInventoryType(Class'AdrenMaxMaterialInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(Class'AdrenMaxMaterialInv');
			Inv.Boost = 1 + AbilityLevel*default.LevMultiplier;
			Inv.GiveTo(Other);
		}
		else
			Inv.SetTimer(5, False);
	}
}

defaultproperties
{
	 LevMultiplier=0.0010000000
     AbilityName="Star Chart****"
     Description="A map of the heavens. Increases your cumulative adrenaline bonus by 0.1% per level.||Rarity: Very High****||This material can only be unlocked by defeating bosses.||You must be level 90 to purchase this.||Cost (per level): 5""
	 StartingCost=5
	 MaxLevel=50
}
