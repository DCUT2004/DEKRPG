class BaseWeaponSentinel extends Weapon_Sentinel;

function IncorporatePlayerWeaponSpeed(int WeaponSpeed)
{
	local WeaponFire CurrentFireMode[2];
    local float Modifier;
    
	Modifier = 1.f + 0.01 * WeaponSpeed;
    
	CurrentFireMode[0] = GetFireMode(0);

    if (CurrentFireMode[0] != None)
    {
        CurrentFireMode[0].FireRate = CurrentFireMode[0].FireRate / Modifier;
        CurrentFireMode[0].FireAnimRate = CurrentFireMode[0].FireAnimRate * Modifier;
        CurrentFireMode[0].ReloadAnimRate = CurrentFireMode[0].ReloadAnimRate * Modifier;
        
        // Log("+++++ BaseWeaponSentinel increasing fire rate according to WeaponSpeed for" @ ItemName @ "weaponSpeed:" @ WeaponSpeed @ "FireRate:" @ CurrentFireMode[0].FireRate @ "default:" @ CurrentFireMode[0].default.FireRate);
    }
}

function UpdateFireRate(float PercentFireRateIncreasePerLevel, int SentinelLevel)
{
	local WeaponFire CurrentFireMode[2];
	CurrentFireMode[0] = GetFireMode(0);

    if (CurrentFireMode[0] != None)
    {
        CurrentFireMode[0].FireRate = CurrentFireMode[0].FireRate * (1 - PercentFireRateIncreasePerLevel);
        CurrentFireMode[0].FireAnimRate = CurrentFireMode[0].FireAnimRate/(1 - PercentFireRateIncreasePerLevel);
        CurrentFireMode[0].ReloadAnimRate = CurrentFireMode[0].ReloadAnimRate/(1 - PercentFireRateIncreasePerLevel);
        
        // Log("+++++ BaseWeaponSentinel increasing fire rate for Level for" @ ItemName @ "new level:" @ SentinelLevel @ "FireRate:" @ CurrentFireMode[0].FireRate @ "default:" @ CurrentFireMode[0].default.FireRate);
    }
}

defaultproperties
{
}
