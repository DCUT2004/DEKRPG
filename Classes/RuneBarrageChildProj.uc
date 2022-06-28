class RuneBarrageChildProj extends Projectile;

var class<Emitter> ExplosionEffectClass;
var	xemitter trail;
var actor Glow;
var float SpreadFactor;

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

    Super(Projectile).PostBeginPlay();
	Velocity = Vector(Rotation) * Speed;  
	Velocity.Z += TossZ;
    R = Rotation;
    R.Roll = 32768;
    SetRotation(R);
}

simulated function destroyed()
{
	if ( Trail != None ) 
		Trail.mRegen=False;
	if ( glow != None )
		Glow.Destroy();
	Super.Destroyed();
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	if ( Other != Instigator )
	{
		SpawnEffects(HitLocation, -1 * Normal(Velocity) );
		Explode(HitLocation,Normal(HitLocation-Other.Location));
	}
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
		if (Rand(99) <= 30)
			Spawn(class'EarthquakeExplosion', Self,, HitLocation, rotator(-HitNormal));
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

simulated function Explode(vector HitLocation, vector HitNormal)
{
	if ( Role == ROLE_Authority )
	{
		HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);	
	}
    Destroy();
}

defaultproperties
{
     Speed=1200.000000
     TossZ=625.000000
     Damage=60.000000
     DamageRadius=400.000000
     MomentumTransfer=1000.000000
     MyDamageType=Class'DEKRPG209E.DamTypeRuneBarrage'
     ImpactSound=Sound'WeaponSounds.BaseImpactAndExplosions.BExplosion3'
     ExplosionDecal=Class'XEffects.RocketMark'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'WeaponStaticMesh.FlakChunk'
     CullDistance=4000.000000
     Physics=PHYS_Falling
     AmbientSound=Sound'WeaponSounds.BaseProjectileSounds.BFlakCannonProjectile'
     DrawScale=14.000000
     AmbientGlow=100
     bProjTarget=True
     ForceType=FT_Constant
     ForceRadius=60.000000
     ForceScale=5.000000
}
