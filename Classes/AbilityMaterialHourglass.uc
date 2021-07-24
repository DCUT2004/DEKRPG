class AbilityMaterialHourglass extends AbilityMaterial
	config(UT2004RPG)
	abstract;
	
var config float SpeedMultiplier;
	
static simulated function ModifyWeapon(Weapon Weapon, int AbilityLevel)
{
	local float Modifier;
	local WeaponFire FireMode[2];
	local RPGStatsInv StatsInv;
	local int WeaponSpeed;

	if (Weapon == None)
		return;
	
	WeaponSpeed = 0;
	if (Pawn(Weapon.Owner) != None)
	{
		StatsInv = RPGStatsInv(Pawn(Weapon.Owner).FindInventoryType(class'RPGStatsInv'));
		if (StatsInv != None)
			WeaponSpeed =  StatsInv.Data.WeaponSpeed;
	}

	Modifier = 1.f + 0.01 * WeaponSpeed;	// first add on his weaponspeed stats
	Modifier *= 1.f + (default.SpeedMultiplier * AbilityLevel);	// now take off the speed due to this ability
	if (Modifier < 0.1)
		Modifier = 0.1;

	FireMode[0] = Weapon.GetFireMode(0);
	FireMode[1] = Weapon.GetFireMode(1);
	if (MinigunFire(FireMode[0]) != None) //minigun needs a hack because it fires differently than normal weapons
	{
		MinigunFire(FireMode[0]).BarrelRotationsPerSec = MinigunFire(FireMode[0]).default.BarrelRotationsPerSec * Modifier;
		MinigunFire(FireMode[0]).FireRate = 1.f / (MinigunFire(FireMode[0]).RoundsPerRotation * MinigunFire(FireMode[0]).BarrelRotationsPerSec);
		MinigunFire(FireMode[0]).MaxRollSpeed = 65536.f*MinigunFire(FireMode[0]).BarrelRotationsPerSec;
		MinigunFire(FireMode[1]).BarrelRotationsPerSec = MinigunFire(FireMode[1]).default.BarrelRotationsPerSec * Modifier;
		MinigunFire(FireMode[1]).FireRate = 1.f / (MinigunFire(FireMode[1]).RoundsPerRotation * MinigunFire(FireMode[1]).BarrelRotationsPerSec);
		MinigunFire(FireMode[1]).MaxRollSpeed = 65536.f*MinigunFire(FireMode[1]).BarrelRotationsPerSec;
	}
	else if (!FireMode[0].IsA('TransFire') && !FireMode[0].IsA('BallShoot') && !FireMode[0].IsA('MeleeSwordFire'))
	{
		if (FireMode[0] != None)
		{
			if (ShieldFire(FireMode[0]) != None) //shieldgun primary needs a hack to do charging speedup
				ShieldFire(FireMode[0]).FullyChargedTime = ShieldFire(FireMode[0]).default.FullyChargedTime / Modifier;
			FireMode[0].FireRate = FireMode[0].default.FireRate / Modifier;
			FireMode[0].FireAnimRate = FireMode[0].default.FireAnimRate * Modifier;
			FireMode[0].MaxHoldTime = FireMode[0].default.MaxHoldTime / Modifier;
		}
		if (FireMode[1] != None)
		{
			FireMode[1].FireRate = FireMode[1].default.FireRate / Modifier;
			FireMode[1].FireAnimRate = FireMode[1].default.FireAnimRate * Modifier;
			FireMode[1].MaxHoldTime = FireMode[1].default.MaxHoldTime / Modifier;
		}
	}
}

defaultproperties
{
     SpeedMultiplier=0.0010000
     AbilityName="Arcane Hourglass****"
     Description="A never ending hourglass.. when does it stop? Increases your cumulative weapon speed by 0.1% per level.||Rarity: Very High****||This material can only be unlocked by defeating bosses.||You must be level 90 to purchase this.||Cost (per level): 5"
	 StartingCost=5
	 MaxLevel=50
}
