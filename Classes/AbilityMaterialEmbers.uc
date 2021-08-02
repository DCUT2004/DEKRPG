class AbilityMaterialEmbers extends AbilityMaterial
	config(UT2004RPG)
	abstract;
	
var config float LevMultiplier;
	
static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if(bOwnedByInstigator)
		return;
	if(Damage > 0)
		if (Instigator != None && (BossInv(Instigator.FindInventoryType(Class'BossInv')) != None || DamageType == Class'DamTypeCombo'))
			Damage *= abs((AbilityLevel * default.LevMultiplier) - 1);
}

defaultproperties
{
	 LevMultiplier=0.00100000
     AbilityName="Burning Embers**"
     Description="Remains of a fire, still burning and hot. Increases your cumulative damage reduction against Bosses, including damage from Boss combos, by 0.1% per level.||Rarity: Medium**||This material can be found by making kills, completing solo and team missions, using Loot magic modifier, winning the game, or defeating bosses.||You must be level 90 to purchase this.||Cost (per level): 3"
	 MaxLevel=50
}
