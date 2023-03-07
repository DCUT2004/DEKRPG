class FireBallTurret extends BaseBallTurret;

simulated event PostBeginPlay()
{
	DefaultWeaponClassName=string(class'FireBallWeapon');

	super.PostBeginPlay();
}

defaultproperties
{
     LockOverlay=FinalBlend'D-E-K-HoloGramFX.FullFB.HoloMaterial_2'
     RotPitchConstraint=(Min=7000.000000,Max=2048.000000)
     CamAbsLocation=(Z=50.000000)
     CamRelLocation=(X=100.000000,Z=50.000000)
     CamDistance=(X=-400.000000,Z=50.000000)
     DefaultWeaponClassName="FireBallWeapon"
     bRelativeExitPos=True
     ExitPositions(0)=(Y=100.000000,Z=100.000000)
     ExitPositions(1)=(Y=-100.000000,Z=100.000000)
     EntryRadius=120.000000
     FPCamPos=(X=-25.000000,Y=13.000000,Z=93.000000)
     VehicleNameString="FireBall Turret"
	 VehicleProjSpawnOffset=(X=138,Y=-75,Z=+16)
}
