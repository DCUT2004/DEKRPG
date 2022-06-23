class NecromancerSoulWeaponHomingSoul extends SeekingRocketProj;

var xEmitter RealSmokeTrail;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	if (SmokeTrail != None)
		SmokeTrail.Destroy();
	
	if (Corona != None)
		Corona.Destroy();

	RealSmokeTrail = Spawn(class'SoulParticleFX',self);
	Dir = vector(Rotation);
	Velocity = speed * Dir;
    SetTimer(0.1, true);
}

simulated function Timer()
{
    local vector ForceDir;
    local float VelMag;
    local float SeekingDistance;

    if ( InitialDir == vect(0,0,0) )
        InitialDir = Normal(Velocity);

	Acceleration = vect(0,0,0);
	// Do normal guidance to target.
	
	if (Seeking == None)
	{
		return;
		Destroy();
	}
	ForceDir = Normal(Seeking.Location - Location);
	
	VelMag = VSize(Velocity);

	ForceDir = Normal(ForceDir * 0.5 * VelMag + Velocity);
	Velocity =  VelMag * ForceDir;
	Acceleration += 5 * ForceDir;

	// Update rocket so it faces in the direction its going.
	SetRotation(rotator(Velocity));

	if (Seeking != None)
	{
		SeekingDistance = VSize(Seeking.Location - Location);
	}
}

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	if (Other == Instigator || Other.IsA('NecromancerSoulWeaponHomingSoul') || ClassIsChildOf(Other.Class, class'DruidBlock'))
		return;
	if (Pawn(Other) != None && Pawn(Other).Health < 1)
		return;
	Super(RocketProj).ProcessTouch(Other, HitLocation);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local Actor A;

	PlaySound(sound'WeaponSounds.BExplosion3',,2.5*TransientSoundVolume);
    if ( EffectIsRelevant(Location,false) )
    {
    	A = Spawn(class'RocketSmokeRing',,,HitLocation + HitNormal*20,rotator(HitNormal));
		if (A != None)
			A.RemoteRole = ROLE_SimulatedProxy;
    }
	BlowUp(HitLocation);
	Destroy();
}

simulated function Destroyed()
{
	if (RealSmokeTrail != None)
	{
		RealSmokeTrail.mRegen=False;
		RealSmokeTrail.LifeSpan=0.650000; //Just in case the trail isn't destroyed
	}
	
	if (SmokeTrail != None)
		SmokeTrail.Destroy();
	
	if (Corona != None)
		Corona.Destroy();
		
	Super.Destroyed();
}

defaultproperties
{
     Speed=800.000000
     MaxSpeed=800.000000
     Damage=60.000000
     MyDamageType=Class'DEKRPG209C.DamTypeNecromancerSoulWeapon'
     LightSaturation=255
     LightBrightness=10.000000
     DrawType=DT_Mesh
     StaticMesh=StaticMesh'Editor.TexPropSphere'
     AmbientSound=Sound'GeneralAmbience.texture39'
     LifeSpan=13.000000
     Texture=Texture'EpicParticles.Flares.Sharpstreaks2'
     DrawScale=0.035000
     CollisionRadius=5.000000
     CollisionHeight=5.000000
}
