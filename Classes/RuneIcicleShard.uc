class RuneIcicleShard extends Projectile;

var byte Bounces;

replication
{
    reliable if (bNetInitial && Role == ROLE_Authority)
        Bounces;
}

simulated function PostBeginPlay()
{
    local float r;

    Velocity = Vector(Rotation) * (Speed);
    if (PhysicsVolume.bWaterVolume)
        Velocity *= 0.65;

    r = FRand();

    SetRotation(RotRand());
	
	SetPhysics(PHYS_Falling);
	
	Velocity.Z += TossZ;

    Super.PostBeginPlay();
}

simulated function ProcessTouch( Actor Other, Vector HitLocation )
{

	if ( Instigator != None && (Other == Instigator) )
		return;

    if (Other == Owner)
		return;
		
	if (Other.IsA('RuneIcicleShard') || Other.IsA('RuneIcicle'))
		return;

	if (Other != None)
		Other.TakeDamage(Damage, Instigator, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType);

	Destroy();
}

simulated function HitWall (vector HitNormal, actor Wall)
{
	local vector RealHitNormal;
	local int HitDamage;


	if ( !Wall.bStatic && !Wall.bWorldGeometry
		&& ((Mover(Wall) == None) || Mover(Wall).bDamageTriggered) )
	{
		if ( Level.NetMode != NM_Client )
		{
			Hitdamage = Damage * 0.00002 * (DrawScale**3) * speed;
			if ( Instigator == None || Instigator.Controller == None )
				Wall.SetDelayedDamageInstigatorController( InstigatorController );
			Wall.TakeDamage( Hitdamage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
		}
	}

	speed = VSize(velocity);
	if (Bounces > 0 && speed>100)
	{
		//PlaySound(ImpactSound, SLOT_Interact, DrawScale/10);
		SetPhysics(PHYS_Falling);
		RealHitNormal = HitNormal;
		if ( FRand() < 0.5 )
			RotationRate.Pitch = Max(RotationRate.Pitch, 100000);
		else
			RotationRate.Roll = Max(RotationRate.Roll, 100000);
		HitNormal = Normal(HitNormal + 0.5 * VRand());
		if ( (RealHitNormal Dot HitNormal) < 0 )
			HitNormal.Z *= -0.7;
		Velocity = 0.7 * (Velocity - 2 * HitNormal * (Velocity Dot HitNormal));
		DesiredRotation = rotator(HitNormal);

		Bounces = Bounces - 1;
		return;
	}
	if (Speed < 100)
		Destroy();
	bFixedRotationDir=false;
	bBounce = false;
}

defaultproperties
{
	 TossZ=600.00000
     Bounces=4
     Speed=6000.000000
     Damage=25.000000
     MomentumTransfer=4000.000000
     MyDamageType=Class'DEKRPG209C.DamTypeStingerTurret'
     //ImpactSound=ProceduralSound'WeaponSounds.PGrenFloor1.P1GrenFloor1'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=152
     LightSaturation=32
     LightBrightness=5.000000
     LightRadius=1.000000
     LightPeriod=10
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DEKStaticsMaster209C.Meshes.CrystalA'
     bDynamicLight=True
     LifeSpan=4.000000
     LODBias=7.000000
     DrawScale=5.000000
	 CollisionHeight=20.000000
	 CollisionRadius=5.00000
     DrawScale3D=(X=0.437500,Y=0.437500,Z=0.437500)
     AmbientGlow=15
     bBounce=True
}
