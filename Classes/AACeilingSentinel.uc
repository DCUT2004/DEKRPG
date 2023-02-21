class AACeilingSentinel extends BaseCeilingSentinel;

simulated function PostBeginPlay()
{
	DefaultWeaponClassName=string(class'AAWeaponSentinel');

	super.PostBeginPlay();
}

defaultproperties
{
     TargetRange=1800.000000
     TurretSwivelClass=Class'DEKRPG999X.DEKCeilingMachineGunSentinelSwivel'
     DefaultWeaponClassName="AAWeaponSentinel"
     VehicleProjSpawnOffset=(X=65.000000)
     VehicleNameString="Anti-Air Sentinel"
     bNoTeamBeacon=False
     DrawScale=0.150000
}
