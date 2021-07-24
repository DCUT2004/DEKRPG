class AbilityMaterialMoonlitStone extends AbilityMaterial
	config(UT2004RPG)
	abstract;

var config float LevMultiplier;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	if (Other != None)
		Other.HealthMax *= 1 + default.LevMultiplier*AbilityLevel;
}

defaultproperties
{
	 LevMultiplier=0.0010000000
     AbilityName="Moonlit Stone****"
     Description="A mysterious stone that glows bright under the moon. Increases your cumulative health bonus by 0.1% per level.||Rarity: Very High****||This material can only be unlocked by defeating bosses.||You must be level 90 to purchase this.||Cost (per level): 5""
	 StartingCost=5
	 MaxLevel=50
}
