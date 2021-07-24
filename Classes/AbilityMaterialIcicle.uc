class AbilityMaterialIcicle extends AbilityMaterial
	config(UT2004RPG)
	abstract;
	
var config float LevMultiplier;
	
static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if (Damage > 0 && Instigator != None && Injured != None && !bOwnedByInstigator)
		if (IceInv(Instigator.FindInventoryType(Class'IceInv')) != None)
			Damage *= (abs((AbilityLevel * default.LevMultiplier)-1));
}

defaultproperties
{
	 LevMultiplier=0.001000000
     AbilityName="Icicles***"
     Description="Icicles that never melt. Dropped only by the coldest of monsters. Increases your cumulative damage reduction against Ice monsters by 0.1% per level.||Rarity: High***||This material can be found by making kills, completing solo and team missions, using Loot magic modifier, winning the game, or defeating bosses.||You must be level 90 to purchase this.||Cost (per level): 3"
	 MaxLevel=50
}
