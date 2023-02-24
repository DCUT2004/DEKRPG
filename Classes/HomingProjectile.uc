//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HomingProjectile extends Projectile;


var Actor HomingTarget;
var vector InitialDir;

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        InitialDir, HomingTarget;
}

simulated function PostBeginPlay()
{
	InitialDir = vector(Rotation);
	Velocity = InitialDir * Speed;

	if (PhysicsVolume.bWaterVolume)
		Velocity = 0.6 * Velocity;

	SetTimer(0.1, true);

	Super.PostBeginPlay();
}

simulated function Timer()
{
	local float VelMag;
	local vector ForceDir;

	if (HomingTarget == None)
		return;

	ForceDir = Normal(HomingTarget.Location - Location);
	if (ForceDir dot InitialDir > 0)
	{
        // Do normal guidance to target.
        VelMag = VSize(Velocity);
        
        ForceDir = Normal(ForceDir * 0.75 * VelMag + Velocity);
        Velocity =  VelMag * ForceDir;
        Acceleration = 5 * ForceDir;
        
        // Update rocket so it faces in the direction its going.
        SetRotation(rotator(Velocity));
	}
}

simulated function Landed( vector HitNormal )
{
	Explode(Location,HitNormal);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	BlowUp(HitLocation);
	Destroy();
}

defaultproperties
{
    MomentumTransfer=10000
    LifeSpan=7.0
    bFixedRotationDir=True
    RotationRate=(Roll=50000)
    DesiredRotation=(Roll=900000)
    ForceType=FT_Constant
    ForceScale=5.0
    ForceRadius=100.0
    FluidSurfaceShootStrengthMod=10.0
}
