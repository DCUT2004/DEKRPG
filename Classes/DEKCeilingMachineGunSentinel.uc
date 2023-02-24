class DEKCeilingMachineGunSentinel extends BaseCeilingSentinel;

simulated function PostBeginPlay()
{
	DefaultWeaponClassName=string(class'DEKMachineGunWeaponSentinel');

	super.PostBeginPlay();
}

defaultproperties
{
     TurretSwivelClass=Class'DEKRPG999X.DEKCeilingMachineGunSentinelSwivel'
     DefaultWeaponClassName="DEKMachineGunWeaponSentinel"
     VehicleProjSpawnOffset=(X=65.000000)
     VehicleNameString="Machine Gun Sentinel"
     bNoTeamBeacon=False
     DrawScale=0.150000
}
