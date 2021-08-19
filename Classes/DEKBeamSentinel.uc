class DEKBeamSentinel extends ASVehicle_Sentinel_Floor;

simulated event PostBeginPlay()
{
	DefaultWeaponClassName=string(class'DEKBeamSentinelWeapon');

	super.PostBeginPlay();
}

simulated function Explode( vector HitLocation, vector HitNormal )
{
	local DEKBeamSentinelController C;
	
	C = DEKBeamSentinelController(self.Controller);
	
	if (C != None && C.PlayerSpawner != None && PlayerController(C.PlayerSpawner) != None)
		PlayerController(C.PlayerSpawner).ClientPlaySound(Sound'AnnouncerAssault.Generic.MS_sentinel_destroyed');
		
	super(ASTurret).Explode( HitLocation, Vect(0,0,1) ); // Overriding Explosion direction
}

defaultproperties
{
     TurretBaseClass=Class'DEKRPG208AH.DEKBeamSentinelBase'
     TurretSwivelClass=Class'DEKRPG208AH.DEKBeamSentinelSwivel'
     DefaultWeaponClassName="DEKWeaponBeamSentinelWeapon"
     VehicleNameString="Beam Sentinel"
     bNoTeamBeacon=False
     Skins(0)=Combiner'DEKRPGTexturesMaster208K.Skins.BeamFloorTurret'
     Skins(1)=Combiner'DEKRPGTexturesMaster208K.Skins.BeamFloorTurret'
     Skins(2)=Combiner'DEKRPGTexturesMaster208K.Skins.BeamFloorTurret'
}
