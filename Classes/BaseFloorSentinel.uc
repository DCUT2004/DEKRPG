class BaseFloorSentinel extends ASVehicle_Sentinel_Floor;

var int SentinelLevel;
var int MaxSentinelLevel;
var float PercentDamageIncreasePerLevel;
var float PercentFireRateIncreasePerLevel;
var float PercentRangeIncreasePerLevel;
var float PercentHealthIncreasePerLevel;

var config float TargetRange;

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
    TargetRange += default.TargetRange * PercentRangeIncreasePerLevel;
    HealthMax += default.HealthMax * PercentHealthIncreasePerLevel;
    // Log("+++++ BaseFloorSentinel setting HealthMax for" @ VehicleNameString @ "to" @ HealthMax @ "default is" @ default.HealthMax);    
    
    if (Controller != None && DruidSentinelController(Controller) != None)
    {
        DruidSentinelController(Controller).LevelUp(PercentDamageIncreasePerLevel, PercentFireRateIncreasePerLevel, PercentRangeIncreasePerLevel, PercentHealthIncreasePerLevel);
    }
    
    // now update the weapon fire rate
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
     TargetRange=1500.000000
}
