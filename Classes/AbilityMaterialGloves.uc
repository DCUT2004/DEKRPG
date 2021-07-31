class AbilityMaterialGloves extends AbilityMaterial
	config(UT2004RPG)
	abstract;
	
var config float LevMultiplier;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ShieldMaxPermInv Inv;
	
	if (Other != None && Other.Controller != None)
	{
		Inv = ShieldMaxPermInv(Other.FindInventoryType(Class'ShieldMaxPermInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(Class'ShieldMaxPermInv');
			Inv.Boost = 1 + AbilityLevel*default.LevMultiplier;
			Inv.GiveTo(Other);
		}
	}
}



defaultproperties
{
	 LevMultiplier=0.00100000
     AbilityName="Gloves*"
     Description="Gloves to protect the hand. Increases your max shield by 0.1% per level.||Rarity: Low*||This material can be found by making kills, completing solo and team missions, using Loot magic modifier, winning the game, or defeating bosses.||You must be level 90 to purchase this.||Cost (per level): 3"
	 MaxLevel=50
}
