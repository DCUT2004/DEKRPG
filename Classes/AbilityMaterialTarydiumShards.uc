class AbilityMaterialTarydiumShards extends AbilityMaterial
	config(UT2004RPG)
	abstract;
	
var config float LevMultiplier;
	
static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if(!bOwnedByInstigator)
		return;
	if(Damage > 0)
		if (Injured != None && CosmicInv(Injured.FindInventoryType(Class'CosmicInv')) != None)
			Damage *= (1 + (AbilityLevel * default.LevMultiplier));
}

defaultproperties
{
	 LevMultiplier=0.0010000
     AbilityName="Tarydium Shards*"
     Description="Precious tarydium shards that are valuable across the galaxy. Increases your cumulative damage bonus against Cosmic monsters by 0.1% per level.||Rarity: Low*||This material can be found by making kills, completing solo and team missions, using Loot magic modifier, winning the game, or defeating bosses.||You must be level 90 to purchase this.||Cost (per level): 3"
	 MaxLevel=50
}
