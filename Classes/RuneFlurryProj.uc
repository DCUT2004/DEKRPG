class RuneFlurryProj extends FlakChunk
	config(UT2004RPG);

var int NumBounces;

simulated function PostBeginPlay()
{
	if (Trail != None)
		Trail.Destroy();

    Velocity = Vector(Rotation) * (Speed);
	//R = Rotation;
    //R.Roll = Rand(65536);
    //SetRotation(R);

    Super(Projectile).PostBeginPlay();
}

simulated function PostNetBeginPlay()
{
	if (Trail != None)
		Trail.Destroy();
	Super.PostNetBeginPlay();
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	local Actor A;
    if ( (RuneFlurryProj(Other) == None) && (Other != Instigator))
    {
		if ( Role == ROLE_Authority )
		{
			if ( Instigator == None || Instigator.Controller == None )
				Other.SetDelayedDamageInstigatorController( InstigatorController );
			if (NumBounces > 0)
				Other.TakeDamage(Damage*NumBounces, Instigator, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType);
		}
		A = Spawn(Class'RunePlasmaHitPurple', , , HitLocation);
		if (A != None)
			A.RemoteRole = ROLE_SimulatedProxy;
        Destroy();
    }
}

simulated function Landed( Vector HitNormal )
{
}

simulated function HitWall( vector HitNormal, actor Wall )
{
    if ( !Wall.bStatic && !Wall.bWorldGeometry 
		&& ((Mover(Wall) == None) || Mover(Wall).bDamageTriggered) )
    {
        if ( Level.NetMode != NM_Client )
		{
			if ( Instigator == None || Instigator.Controller == None )
				Wall.SetDelayedDamageInstigatorController( InstigatorController );
            Wall.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
		}
        Destroy();
        return;
    }

	if (NumBounces > 0)
    {
		if ( !Level.bDropDetail && (FRand() < 0.4) )
			Playsound(ImpactSounds[Rand(6)]);

        Velocity = Velocity - 2.0*HitNormal*(Velocity dot HitNormal);
		SetRotation(Rotator(Velocity));
        NumBounces--;
        return;
    }
	bBounce = false;
    if (Trail != None) 
    {
        Trail.mRegen=False;
        Trail.SetPhysics(PHYS_None);
    }
	Destroy();
}

defaultproperties
{
     NumBounces=4
     ImpactSounds(0)=Sound'WeaponSounds.BioRifle.BioRifleGoo2'
     ImpactSounds(1)=Sound'WeaponSounds.BioRifle.BioRifleGoo1'
     ImpactSounds(2)=Sound'WeaponSounds.BioRifle.BioRifleGoo2'
     ImpactSounds(3)=Sound'WeaponSounds.BioRifle.BioRifleGoo1'
     ImpactSounds(4)=Sound'WeaponSounds.BioRifle.BioRifleGoo2'
     ImpactSounds(5)=Sound'WeaponSounds.BioRifle.BioRifleGoo1'
     Speed=3000.000000
     MaxSpeed=3000.000000
     Damage=20.000000
	 bDynamicLight=True
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=200
     LightSaturation=50
     LightBrightness=255.000000
     LightRadius=3.000000
     MyDamageType=Class'DEKRPG999X.DamTypeRuneFlurry'
     StaticMesh=StaticMesh'WeaponStaticMesh.LinkProjectile'
	 Skins(0)=FinalBlend'AW-2004Particles.Fire.TurretFlashFinal'
     CullDistance=3000.000000
     LifeSpan=4.700000
	 DrawScale3D=(X=2.295000,Y=1.530000,Z=1.530000)
     DrawScale=1.0000
}
