class AbilityMaterialSteel extends AbilityMaterial
	config(UT2004RPG)
	abstract;
	
var config float LevMultiplier;
	
static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if(!bOwnedByInstigator)
		return;
	if(Damage > 0)
		if (Injured != None && TechInv(Injured.FindInventoryType(Class'TechInv')) != None)
			Damage *= (1 + (AbilityLevel * default.LevMultiplier));
}

defaultproperties
{
	 LevMultiplier=0.0010000000
     AbilityName="Steel*"
     Description="A strong and sturdy material commonly found in many structures. Increases your cumulative damage bonus against Tech monsters by 0.1% per level.||Rarity: Low*||This material can be found by making kills, completing solo and team missions, using Loot magic modifier, winning the game, or defeating bosses.||You must be level 90 to purchase this.||Cost (per level): 3"
	 MaxLevel=50
}
