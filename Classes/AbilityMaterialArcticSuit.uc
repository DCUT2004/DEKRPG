class AbilityMaterialArcticSuit extends AbilityMaterial
	config(UT2004RPG)
	abstract;
	
var config float LevMultiplier;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	Other.Mass *= 1 + AbilityLevel*default.LevMultiplier;
}

defaultproperties
{
	 LevMultiplier=0.0010000
     AbilityName="Arctic Suit**"
     Description="A suit to protect the wearer against the frozen tundra. Increases your sturdiness by 0.1% per level.||Rarity: Medium**||This material can be found by making kills, completing solo and team missions, using Loot magic modifier, winning the game, or defeating bosses.||You must be level 90 to purchase this.||Cost (per level): 3"
	 MaxLevel=50
}
