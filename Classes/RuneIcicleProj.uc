class RuneIcicleProj extends Projectile
	config(UT2004RPG);

var Emitter Glow;
var	xemitter trail;

simulated function PostBeginPlay()
{
    local Rotator R;
    local PlayerController PC;
	
    if (!PhysicsVolume.bWaterVolume && Level.NetMode != NM_DedicatedServer) {
        PC = Level.GetLocalPlayerController();
        if (PC.ViewTarget != None && VSize(PC.ViewTarget.Location - Location) < 6000)
            Trail = Spawn(class'BlueTrail', self,, Location, R);
		if (Trail != None)
			Trail.SetBase(Self);
        Glow = Spawn(class'IceballEffect', self);
		if (Glow != None){
			Glow.SetBase(Self);
		}
    }
	
	Velocity = Vector(Rotation) * Speed;
	Velocity.z += TossZ; 
    Super.PostBeginPlay();
    R = Rotation;
    SetRotation(R);
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{	
	if ( Instigator != None && Other != Instigator )
	{
		SpawnEffects(HitLocation, -1 * Normal(Velocity) );
		Explode(HitLocation,Normal(HitLocation-Other.Location));
	}
}

simulated function Landed( vector HitNormal )
{
	local RuneIcicle Icicle;
	
	if (FastTrace(Self.Location, Self.Location + Vect(0,0,70))){
		//If we don't hit anything above our spawn point, assume we're on the ground and spawn the Icicle
		Icicle = Spawn(Class'RuneIcicle', Instigator, , Self.Location + Vect(0, 0, -50));	//Spawn a bit down below so the icicles appear to be touching ground
	}
	SpawnEffects( Location, HitNormal );
	Explode(Location,HitNormal);
}

simulated function HitWall (vector HitNormal, actor Wall)
{
	Landed(HitNormal);
}

simulated function SpawnEffects(vector HitLocation, vector HitNormal)
{
    PlaySound(ImpactSound, SLOT_None, 0.3);
    if (EffectIsRelevant(Location, false))
	{
        if (ExplosionDecal != None && Level.NetMode != NM_DedicatedServer)
            Spawn(ExplosionDecal, self,, HitLocation, rotator(-HitNormal));
		Spawn(class'RuneBlizzardEffect', Self,, HitLocation, rotator(-HitNormal));
    }
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	if (Role == ROLE_Authority)
		HurtRadius(Damage, DamageRadius,  MyDamageType, MomentumTransfer, HitLocation);
    Destroy();
}

simulated function destroyed()
{
	if ( Trail != None ) 
		Trail.mRegen=False;
	if ( glow != None )
		Glow.Destroy();
	Super.Destroyed();
}

defaultproperties
{
     TossZ=225.000000
     Physics=PHYS_Falling
     Speed=1200.000000
     Damage=90.000000
     DamageRadius=220.000000
     MomentumTransfer=75000.000000
     MyDamageType=Class'DEKRPG209C.DamTypeRuneIceball'
     ExplosionDecal=Class'XEffects.RocketMark'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.FlakChunk'
     CullDistance=4000.000000
     AmbientSound=Sound'WeaponSounds.BaseProjectileSounds.BFlakCannonProjectile'
     DrawScale=0.100000
     AmbientGlow=100
     bProjTarget=True
     ForceType=FT_Constant
     ForceRadius=60.000000
     ForceScale=5.000000
}
