class AbilityMaterialDust extends AbilityMaterialHighRarity
	config(UT2004RPG)
	abstract;
	
var config float LevMultiplier;
	
static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if (Damage > 0 && Instigator != None && Injured != None && !bOwnedByInstigator)
		if (CosmicInv(Instigator.FindInventoryType(Class'CosmicInv')) != None)
			Damage *= (abs((AbilityLevel * default.LevMultiplier)-1));
}

defaultproperties
{
	 LevMultiplier=0.00100000
     AbilityName="Cosmic Dust***"
     Description="A powdery, purple substance left by cosmic monsters. Increases your cumulative damage reduction against Cosmic monsters by 0.1% per level.||Rarity: High***||This material can be found by making kills, completing solo and team missions, using Loot magic modifier, winning the game, or defeating bosses.||You must be level 80 to purchase this.||Cost (per level): 3"
	 MaxLevel=50
}
