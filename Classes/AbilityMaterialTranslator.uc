class AbilityMaterialTranslator extends AbilityMaterial
	config(UT2004RPG)
	abstract;
	
var config float LevMultiplier;

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if(bOwnedByInstigator)
		return; //if the instigator is doing the damage, ignore this.
	if(Damage > 0 )
		Damage *= (abs((AbilityLevel * default.LevMultiplier)-1));
}

defaultproperties
{
     LevMultiplier=0.0010000
     AbilityName="Universal Translator****"
     Description="An advanced gadget that can translate extraterrestrial languages and hieroglyphs. Increases your cumulative total damage reduction by 0.1% per level. Does not apply to self damage.||Rarity: Very High****||This material can only be unlocked by defeating bosses.||You must be level 90 to purchase this.||Cost (per level): 5""
	 StartingCost=5
	 MaxLevel=50
}
