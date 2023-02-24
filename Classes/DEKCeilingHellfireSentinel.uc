class DEKCeilingHellfireSentinel extends BaseCeilingSentinel;

simulated function PostBeginPlay()
{
	DefaultWeaponClassName=string(class'DEKHellfireSentinelWeapon');

	super.PostBeginPlay();
}

defaultproperties
{
     TargetRange=1000.000000
     DefaultWeaponClassName="DEKWBHellfireSentinelWeapon"
     VehicleProjSpawnOffset=(X=150.000000)
     VehicleNameString="Hellfire Sentinel"
     bNoTeamBeacon=False
}
