class Altar extends Actor;

var Emitter AltarFX;
var Class<Emitter> AltarFXClass;
var config float PlayerRadius;
var Class<LocalMessage> AltarMessageClass;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	AltarFX = Spawn(AltarFXClass, , ,Self.Location);
	if (AltarFX != None)
		AltarFX.SetBase(Self);
	SetTimer(1, True);
}

simulated function Timer()
{
	local Pawn P;
	
	foreach VisibleCollidingActors ( Class'Pawn', P, PlayerRadius, Location, True )
	{
		if (P != None && P.Controller != None && Level.NetMode != NM_DedicatedServer)
		{
			if (P.IsLocallyControlled() && PlayerController(P.Controller) != None)
				PlayerController(P.Controller).ReceiveLocalizedMessage(AltarMessageClass);			
		}
	}
}

defaultproperties
{
	PlayerRadius=1000.000
	Lifespan=0.0
	DrawType=DT_StaticMesh
	StaticMesh=StaticMesh'AW-2004Particles.Weapons.PlasmaSphere'
	Drawscale=0.0100000
	bAcceptsProjectors=False
    bMovable=False
    CollisionRadius=10.000000
    CollisionHeight=20.000000
	bUseCylinderCollision=True
	Physics=PHYS_Falling
	bWorldGeometry=False
	bIgnoreEncroachers=True
	bIgnoreVehicles=True
	bCollideActors=False
	bCollideWorld=True
	bBlockActors=False
	bBlockProjectiles=False
	bBlocksTeleport=False
}
