class AbilityMaterialLeather extends AbilityMaterial
	config(UT2004RPG)
	abstract;
	
var config float SpeedMultiplier;
	
static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local xPawn X;
	
	X = xPawn(Other);
	if (X.Role == ROLE_Authority)
	{
		X.DodgeSpeedFactor *= 1.0 + default.SpeedMultiplier * float(AbilityLevel);
		X.DodgeSpeedZ *= 1.0 + default.SpeedMultiplier * float(AbilityLevel);
	}
}

defaultproperties
{
	 SpeedMultiplier=0.00100000
     AbilityName="Fine Leather**"
     Description="Fine leather from many monsters. Increases your dodge speed by 0.1% per level.||Rarity: Medium**||This material can be found by making kills, completing solo and team missions, using Loot magic modifier, winning the game, or defeating bosses.||You must be level 90 to purchase this.||Cost (per level): 3"
	 MaxLevel=50
}
