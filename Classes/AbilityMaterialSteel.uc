class AbilityMaterialSteel extends AbilityMaterial
	config(UT2004RPG)
	abstract;
	
var config float LevMultiplier;
	
static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	Other.JumpZ *= (1.0 + default.LevMultiplier * float(AbilityLevel));
}

defaultproperties
{
	 LevMultiplier=0.0010000000
     AbilityName="Steel*"
     Description="A strong and sturdy material commonly found in many structures. Increases your jumping height by 0.1% per level.||Rarity: Low*||This material can be found by making kills, completing solo and team missions, using Loot magic modifier, winning the game, or defeating bosses.||You must be level 90 to purchase this.||Cost (per level): 3"
	 MaxLevel=50
}
