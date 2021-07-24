class AbilityDEKFastWeaponSwitch extends AbilityFastWeaponSwitch
	abstract;

//Below equations were re-written so they can be cumulative with other abilities that also affect these values
static simulated function ModifyWeapon(Weapon Weapon, int AbilityLevel)
{
	local float Modifier;
	local RPGWeapon RW;

	if (!Weapon.Instigator.IsLocallyControlled())
		return;

	Modifier = 1.0 + (0.5 * AbilityLevel);
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
}
