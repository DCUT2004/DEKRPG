class RuneBarrageProj extends Projectile
	config(UT2004RPG);

var actor Glow;
var	xemitter trail;

simulated function PostBeginPlay()
{
    local Rotator R;
    local PlayerController PC;
	
    if (!PhysicsVolume.bWaterVolume && Level.NetMode != NM_DedicatedServer) {
        PC = Level.GetLocalPlayerController();
        if (PC.ViewTarget != None && VSize(PC.ViewTarget.Location - Location) < 6000)
            Trail = Spawn(class'RuneBarrageProjTrail', self,, Location, R);
        Glow = Spawn(class'FlakGlow', self);
    }
	
	Velocity = Vector(Rotation) * Speed;
	Velocity.z += TossZ; 
    Super.PostBeginPlay();
    R = Rotation;
    SetRotation(R);
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	if ( Other != Instigator )
	{
		SpawnEffects(HitLocation, -1 * Normal(Velocity) );
		Explode(HitLocation,Normal(HitLocation-Other.Location));
	}
}

simulated function Landed( vector HitNormal )
{
	SpawnEffects( Location, HitNormal );
	Explode(Location,HitNormal);
}

simulated function HitWall (vector HitNormal, actor Wall)
{
	Landed(HitNormal);
}

simulated function SpawnEffects(vector HitLocation, vector HitNormal)
{
    local PlayerController PC;

    PlaySound(ImpactSound, SLOT_None, 0.3);
    if (EffectIsRelevant(Location, false))
	{
        PC = Level.GetLocalPlayerController();
        if (PC.ViewTarget != None && VSize(PC.ViewTarget.Location - Location) < 3000)
		spawn(class'FlashExplosion',,,HitLocation + HitNormal*16 );
        if (ExplosionDecal != None && Level.NetMode != NM_DedicatedServer)
            Spawn(ExplosionDecal, self,, HitLocation, rotator(-HitNormal));
		//Spawn(class'EarthquakeExplosion', Self,, HitLocation, rotator(-HitNormal));
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
     Speed=1140.000000
     Damage=60.000000
     DamageRadius=200.000000
     MomentumTransfer=75000.000000
     MyDamageType=Class'DEKRPG209C.DamTypeRuneBarrage'
     ExplosionDecal=Class'XEffects.RocketMark'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.FlakChunk'
     CullDistance=4000.000000
     AmbientSound=Sound'WeaponSounds.BaseProjectileSounds.BFlakCannonProjectile'
	 ImpactSound=Sound'WeaponSounds.BExplosion3'
     DrawScale=14.000000
     AmbientGlow=100
     bProjTarget=True
     ForceType=FT_Constant
     ForceRadius=60.000000
     ForceScale=5.000000
}
