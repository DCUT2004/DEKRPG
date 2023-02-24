class DEKCeilingBeamSentinel extends BaseCeilingSentinel;

simulated function PostBeginPlay()
{
	DefaultWeaponClassName=string(class'DEKBeamSentinelWeapon');

	super.PostBeginPlay();
}

defaultproperties
{
     TurretSwivelClass=Class'DEKRPG999X.DEKBeamSentinelCeilingSwivel'
     DefaultWeaponClassName="DEKWBeamSentinelWeapon"
     VehicleProjSpawnOffset=(X=150.000000)
     VehicleNameString="Beam Sentinel"
     bNoTeamBeacon=False
     Skins(0)=Combiner'DEKRPGTexturesMaster209B.Skins.BeamCeilingTurret'
     Skins(1)=Combiner'DEKRPGTexturesMaster209B.Skins.BeamCeilingTurret'
     Skins(2)=Combiner'DEKRPGTexturesMaster209B.Skins.BeamCeilingTurret'
}
