class BaseTurretSentinel extends ASTurret;

var int SentinelLevel;
var int MaxSentinelLevel;
var float PercentDamageIncreasePerLevel;
var float PercentFireRateIncreasePerLevel;
var float PercentRangeIncreasePerLevel;
var float PercentHealthIncreasePerLevel;

replication
{
	reliable if (Role == ROLE_Authority)
		SentinelLevel;
}

function LevelUp()
{
    if (SentinelLevel == MaxSentinelLevel)
        return;
        
    SentinelLevel += 1;
    HealthMax += default.HealthMax * PercentHealthIncreasePerLevel;
    // Log("+++++ BaseTurretSentinel setting HealthMax for" @ VehicleNameString @ "to" @ HealthMax @ "default is" @ default.HealthMax);    
    
    if (Controller != None && DruidSentinelController(Controller) != None)
    {
        DruidSentinelController(Controller).LevelUp(PercentDamageIncreasePerLevel, PercentFireRateIncreasePerLevel, PercentRangeIncreasePerLevel, PercentHealthIncreasePerLevel);
    }
    else
    if (Controller != None && DruidDefenseSentinelController(Controller) != None)
    {
        DruidDefenseSentinelController(Controller).LevelUp(PercentDamageIncreasePerLevel, PercentFireRateIncreasePerLevel, PercentRangeIncreasePerLevel, PercentHealthIncreasePerLevel);
    }
    else
    if (Controller != None && DruidLightningSentinelController(Controller) != None)
    {
        DruidLightningSentinelController(Controller).LevelUp(PercentDamageIncreasePerLevel, PercentFireRateIncreasePerLevel, PercentRangeIncreasePerLevel, PercentHealthIncreasePerLevel);
    }
    else
    if (Controller != None && AutoGunController(Controller) != None)
    {
        AutoGunController(Controller).LevelUp(PercentDamageIncreasePerLevel, PercentFireRateIncreasePerLevel, PercentRangeIncreasePerLevel, PercentHealthIncreasePerLevel);
    }
    else
    if (Controller != None && DruidEnergyWallController(Controller) != None)
    {
        DruidEnergyWallController(Controller).LevelUp(PercentDamageIncreasePerLevel, PercentFireRateIncreasePerLevel, PercentRangeIncreasePerLevel, PercentHealthIncreasePerLevel);
    }
    
    // now update the weapon fire rate - if there is one
    if (Weapon != None && BaseWeaponSentinel(Weapon) != None)
    {
        BaseWeaponSentinel(Weapon).UpdateFireRate(PercentFireRateIncreasePerLevel, SentinelLevel);
    }
}

defaultproperties
{
     SentinelLevel=0
     MaxSentinelLevel=5
     PercentDamageIncreasePerLevel=0.08
     PercentFireRateIncreasePerLevel=0.08
     PercentRangeIncreasePerLevel=0.1
     PercentHealthIncreasePerLevel=0.1
}
