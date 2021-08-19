class TutorialDrone extends Actor
	config(UT2004RPG);

// stuff from Projectile that we can't use 'cos it makes it get destroyed by movers
var float Speed;


var Pawn protPawn; // owner pawn
var int OrbitDist; // distance at which drone orbits when pawn's not moving

var xEmitter Trail;

var float curOsc; // oscillation counter

var int CircleSpeed; // orbital speed
var int OscHeight; // several times the actual weave height
var float OscInc; // increment of oscillation - rate of weaving

var int orbitHeight; // vertical offset from player's center - randomized when player has more than one

var TutorialDroneProtector P;
var config float DefenseRadius;
var config float TimeBetweenShots;

var int HealthHealingLevel;
var int ShieldHealingLevel;
var int ResupplyLevel;
var int ArmorHealingLevel;

var config float HealthHealingAmount;
var config float ShieldHealingAmount;		// the amount of shield the defense sentinel heals per level (% of max shield)
var config float ResupplyAmount;			// the amount of resupply the defense sentinel heals per level (% of max ammo)
var config float ArmorHealingAmount;		// the amount of armor the defense sentinel heals per level (% of max adrenaline)

var bool CanDefend;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		curOsc,orbitHeight, protPawn;
	reliable if (Role == ROLE_Authority)
		P;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	// randomize everything so drones behave a little bit differently
	if(Role==ROLE_Authority)
	{
		curOsc = FRand()*3.14159;
		orbitHeight = FRand()*95 - 40;
	}
	Trail = Spawn(class'DefenseDroneTrail',self,,Location,Rotation);
	Trail.SetBase(self);
	Trail.LifeSpan = 0;
	Velocity = vector(Rotation)*Speed;
	SetTimer(0.1,true);
	P=Spawn(class'TutorialDroneProtector',self);
	if (P != None)
	{
		P.Drone = Self;
		P.SetBase(self);
		P.TargetRadius = DefenseRadius;
		P.TimeBetweenShots = TimeBetweenShots;
		P.HealthHealingAmount = HealthHealingAmount;
		P.ShieldHealingAmount = ShieldHealingAmount;
		P.ResupplyAmount = ResupplyAmount;
	}
}

simulated function Timer()
{
	local vector toProt;
	local float dist;
	
	if(protPawn == None || protPawn.Health<=0 || protPawn.IsA('Monster'))
		Destroy();
	else
	{
		//Movement
		curOsc += OscInc;
		toProt = (protPawn.Location+vect(0,0,1)*orbitHeight) - Location;
		dist = VSize(toProt);
		Velocity = 0.1 * Velocity + 0.3 * ((Normal(toProt) cross vect(0,0,1)) * CircleSpeed) + 0.2 * cos(curOsc) * vect(0,0,1) * OscHeight + 0.4 * Normal(toProt) * Speed * (dist - OrbitDist)/OrbitDist;
		SetRotation(rotator(Velocity)+rotator(vect(1,0,0))+rotator(vect(0,1,0)));
	}
}

simulated function HitWall(vector HitNormal, actor Wall)
{
	// bounce off. this makes for some weirdness with the homing but it's not too bad
	Velocity = -(Velocity dot HitNormal) * HitNormal;
	SetRotation(rotator(Velocity));
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{

}

simulated function Destroyed()
{
	if(Trail != None)
		Trail.Destroy();
	if (P!=None)
		P.Destroy();
	Super.Destroyed();
}

defaultproperties
{
     Speed=700.000000
     OrbitDist=64
     CircleSpeed=-420
     OscHeight=240
     OscInc=0.500000
     DefenseRadius=1000.000000
     TimeBetweenShots=0.500000
	 HealthHealingAmount=5.0000000
     ShieldHealingAmount=20.000000
     ResupplyAmount=3.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'XGame_rc.BallMesh'
     bAlwaysRelevant=True
     bReplicateInstigator=True
     Physics=PHYS_Projectile
     RemoteRole=ROLE_SimulatedProxy
     DrawScale=1.500000
     bUnlit=True
     bDisturbFluidSurface=True
     SoundVolume=255
     SoundRadius=50.000000
     CollisionRadius=20.000000
     CollisionHeight=20.000000
     bCollideActors=True
     bCollideWorld=True
     bUseCylinderCollision=True
     bBounce=True
     bFixedRotationDir=True
     RotationRate=(Yaw=24000)
     DesiredRotation=(Yaw=30000)
}
