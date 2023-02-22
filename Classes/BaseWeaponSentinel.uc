class BaseWeaponSentinel extends Weapon_Sentinel;

function UpdateFireRate(float PercentFireRateIncreasePerLevel, int SentinelLevel)
{
	local WeaponFire CurrentFireMode[2];
	CurrentFireMode[0] = GetFireMode(0);

    if (CurrentFireMode[0] != None)
    {
        CurrentFireMode[0].FireRate = CurrentFireMode[0].FireRate * (1 - PercentFireRateIncreasePerLevel);
        CurrentFireMode[0].FireAnimRate = CurrentFireMode[0].FireAnimRate/(1 - PercentFireRateIncreasePerLevel);
        CurrentFireMode[0].ReloadAnimRate = CurrentFireMode[0].ReloadAnimRate/(1 - PercentFireRateIncreasePerLevel);
        
        // Log("+++++ BaseWeaponSentinel increasing fire rate for" @ ItemName @ "new level:" @ SentinelLevel @ "FireRate:" @ CurrentFireMode[0].FireRate @ "default:" @ CurrentFireMode[0].default.FireRate);
    }
}

defaultproperties
{
}
