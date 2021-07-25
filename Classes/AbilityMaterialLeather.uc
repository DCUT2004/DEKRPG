class AbilityMaterialLeather extends AbilityMaterial
	config(UT2004RPG)
	abstract;
	
var config float LevMultiplier;
	
static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if(!bOwnedByInstigator)
		return;
	if(Damage > 0)
		if (Injured != None && BossInv(Injured.FindInventoryType(Class'BossInv')) != None)
			Damage *= (1 + (AbilityLevel * default.LevMultiplier));
}
defaultproperties
{
	 LevMultiplier=0.00100000
     AbilityName="Fine Leather**"
     Description="Fine leather from many monsters. Increases your cumulative damage bonus against Bosses by 0.1% per level.||Rarity: Medium**||This material can be found by making kills, completing solo and team missions, using Loot magic modifier, winning the game, or defeating bosses.||You must be level 90 to purchase this.||Cost (per level): 3"
	 MaxLevel=50
}
