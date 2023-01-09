class Altar extends Actor;

var Emitter AltarFX;
var Class<Emitter> AltarFXClass;
var config float PlayerRadius;		//How close this player must be to deposit Geode
var Class<LocalMessage> AltarMessageClass;
var byte NumGeodes;
var int MaxGeodes;
var config int DepositThreshold;	//How many seconds player must be near this Altar to deposit a Geode

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	AltarFX = Spawn(AltarFXClass, , ,Self.Location);
	if (AltarFX != None)
		AltarFX.SetBase(Self);
	NumGeodes = 0;
}

defaultproperties
{
	DepositThreshold=7
	MaxGeodes=3
	CollisionHeight=250.000
	CollisionRadius=500.000
	Lifespan=0.0
	DrawType=DT_StaticMesh
	StaticMesh=StaticMesh'AW-2004Particles.Weapons.PlasmaSphere'
	Drawscale=0.0100000
	bAcceptsProjectors=False
    bMovable=False
	bUseCylinderCollision=True
	Physics=PHYS_None
	bWorldGeometry=False
	bIgnoreEncroachers=False
	bIgnoreVehicles=True
	bCollideActors=True
	bCollideWorld=False
	bBlockActors=False
	bBlockPlayers=False
	bBlockProjectiles=False
	bBlocksTeleport=False
}
