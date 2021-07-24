class AbilityMaterialUranium extends AbilityMaterial
	config(UT2004RPG)
	abstract;
	
var config float LevMultiplier;

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if(!bOwnedByInstigator)
		return;
	if(Damage > 0)
		Damage *= (1 + (AbilityLevel * default.LevMultiplier));
}

defaultproperties
{
     LevMultiplier=0.0010000
     AbilityName="Uranium Pellet****"
     Description="A metal brimming with energy. Increases your cumulative total damage bonus by 0.1% per level.||Rarity: Very High****||This material can only be unlocked by defeating bosses.||You must be level 90 to purchase this.||Cost (per level): 5""
	 StartingCost=5
	 MaxLevel=50
}
