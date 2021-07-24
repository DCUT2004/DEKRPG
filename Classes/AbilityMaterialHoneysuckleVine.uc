class AbilityMaterialHoneysuckleVine extends AbilityMaterial
	config(UT2004RPG)
	abstract;
	
var config float LevMultiplier;
	
static function bool OverridePickupQuery(Pawn Other, Pickup item, out byte bAllowPickup, int AbilityLevel)
{
	if (UDamagePack(item) != None)
	{
			Other.EnableUDamage(30 + AbilityLevel*default.LevMultiplier);
			bAllowPickup = 1;
			return true;
	}

	return false;
}

defaultproperties
{
	 LevMultiplier=0.2000000
     AbilityName="Honeysuckle Vines**"
     Description="Beautiful and fragrant floral vines. Increases the duration of double damage pickups by 0.2 seconds per level.||Rarity: Medium**||This material can be found by making kills, completing solo and team missions, using Loot magic modifier, winning the game, or defeating bosses.||You must be level 90 to purchase this.||Cost (per level): 3"
	 MaxLevel=50
}
