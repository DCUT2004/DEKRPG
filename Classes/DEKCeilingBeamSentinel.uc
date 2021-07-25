class DEKCeilingBeamSentinel extends ASVehicle_Sentinel_Ceiling;

simulated function PostBeginPlay()
{
	DefaultWeaponClassName=string(class'DEKBeamSentinelWeapon');

	super.PostBeginPlay();
}

defaultproperties
{
     TurretSwivelClass=Class'DEKRPG208AB.DEKBeamSentinelCeilingSwivel'
     DefaultWeaponClassName="DEKWBeamSentinelWeapon"
     VehicleProjSpawnOffset=(X=150.000000)
     VehicleNameString="Beam Sentinel"
     bNoTeamBeacon=False
     Skins(0)=Combiner'DEKRPGTexturesMaster208K.Skins.BeamCeilingTurret'
     Skins(1)=Combiner'DEKRPGTexturesMaster208K.Skins.BeamCeilingTurret'
     Skins(2)=Combiner'DEKRPGTexturesMaster208K.Skins.BeamCeilingTurret'
}
