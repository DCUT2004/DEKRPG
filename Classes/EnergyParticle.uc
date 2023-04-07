class EnergyParticle extends SeekingRocketProj;
var Class<xEmitter> RealSmokeTrailClass;
var XEmitter RealSmokeTrail;

#exec OBJ LOAD FILE=..\Textures\EpicParticles.uax

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	if (SmokeTrail != None)
		SmokeTrail.Destroy();
	
	if (Corona != None)
		Corona.Destroy();

	RealSmokeTrail = Spawn(RealSmokeTrailClass, self);
	Dir = vector(Rotation);
	Velocity = speed * Dir;
	SetCollision(False,False,False);
    SetTimer(0.1, true);
}

simulated function Timer()
{
    local float SeekingDistance, VelMag;
    local vector ForceDir;

	if (Seeking == None || Pawn(Seeking) != None && Pawn(Seeking).Health <= 0)
	{
		Destroy();
		return;
	}

	SeekingDistance = VSize(Seeking.Location - Location);
	if(SeekingDistance < 60)
	{
		Destroy(); // Destroy the particle if it is within range of the seeking target
		return;
	}

    if ( InitialDir == vect(0,0,0) )
        InitialDir = Normal(Velocity);
         
	Acceleration = vect(0,0,0);

	// Do normal guidance to target.
	ForceDir = Normal(Seeking.Location - Location);
	if( abs(ForceDir Dot InitialDir) > 0 )
	{
		//Log("ForceDir Dot InitialDir > 0");
		VelMag = VSize(Velocity);
	
		// track vehicles better
		if ( Seeking.Physics == PHYS_Karma )
			ForceDir = Normal(ForceDir * 0.8 * VelMag + Velocity);
		else
			ForceDir = Normal(ForceDir * 0.5 * VelMag + Velocity);
		Velocity =  VelMag * ForceDir;  
		Acceleration += 5 * ForceDir;
	}
	// Update rocket so it faces in the direction its going.
	SetRotation(rotator(Velocity));
}

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	if (Other == Instigator)
		Explode(HitLocation,Normal(HitLocation-Other.Location));
	else
		return;
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	Destroy();
}

simulated function Destroyed()
{
	if (RealSmokeTrail != None)
	{
		//RealSmokeTrail.mRegen=False;
		//RealSmokeTrail.LifeSpan=0.100000; //Just in case the trail isn't destroyed
		RealSmokeTrail.Destroy();
	}

	Super.Destroyed();
}

event Touch (Actor Other)
{
	if(Other == Instigator)
		Destroy();
}

defaultproperties
{
     Speed=800.000000
     MaxSpeed=800.000000
     LightSaturation=255
     LightBrightness=10.000000
     DrawType=DT_Sprite
     AmbientSound=Sound'GeneralAmbience.texture39'
     Texture=Texture'EpicParticles.Flares.Sharpstreaks2'
     DrawScale=0.150000
     CollisionRadius=5.000000
     CollisionHeight=5.000000
     bCollideWorld=False
}
