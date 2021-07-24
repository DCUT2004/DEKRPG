class AbilityMaterialEmbers extends AbilityMaterial
	config(UT2004RPG)
	abstract;
	
var config float LevMultiplier;
	
static simulated function ModifyWeapon(Weapon Weapon, int AbilityLevel)
{
	local float Modifier;
	local RPGWeapon RW;

	if (!Weapon.Instigator.IsLocallyControlled())
		return;

	Modifier = 1.0 + (default.LevMultiplier * AbilityLevel);
	RW = RPGWeapon(Weapon);
	if (RW != None)
	{
		RW.ModifiedWeapon.BringUpTime /= Modifier;
		RW.ModifiedWeapon.PutDownTime /= Modifier;
		RW.ModifiedWeapon.MinReloadPct /= Modifier;
		RW.ModifiedWeapon.PutDownAnimRate /= Modifier;
		RW.ModifiedWeapon.SelectAnimRate /= Modifier;
	}
	else
	{	Weapon.BringUpTime /= Modifier;
		Weapon.PutDownTime /= Modifier;
		Weapon.MinReloadPct /= Modifier;
		Weapon.PutDownAnimRate *= Modifier;
		Weapon.SelectAnimRate *= Modifier;
	}
}

defaultproperties
{
	 LevMultiplier=0.00100000
     AbilityName="Burning Embers**"
     Description="Remains of a fire, still burning and hot. Increases the cumulative speed of your weapon switch by 0.1% per level.||Rarity: Medium**||This material can be found by making kills, completing solo and team missions, using Loot magic modifier, winning the game, or defeating bosses.||You must be level 90 to purchase this.||Cost (per level): 3"
	 MaxLevel=50
}
