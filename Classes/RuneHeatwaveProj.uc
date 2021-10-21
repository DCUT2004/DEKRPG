class RuneHeatwaveProj extends Projectile
	config(UT2004RPG);

var config int HeatBlastDamage;
var config float HeatBlastRadius;


simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	Velocity = Speed * vector(Rotation);
}

simulated function ClientSideTouch(Actor Other, Vector HitLocation);
simulated function BlowUp(vector HitLocation);
simulated function HitWall(vector HitNormal, Actor Wall);

simulated singular function Touch(Actor Other)
{
	local vector HitLocation, HitNormal;

	if (Other == None) // Other just got destroyed in its touch?
		return;

	if (Other.bProjTarget || Other.bBlockActors)
	{
		LastTouched = Other;
		if (Velocity == vect(0,0,0) || Other.IsA('Mover'))
		{
			ProcessTouch(Other, Location);
			LastTouched = None;
			return;
		}

		if (Other.TraceThisActor(HitLocation, HitNormal, Other.Location, Location, vect(1,1,1)))
			HitLocation = Location;

		ProcessTouch(Other, HitLocation);
		LastTouched = None;
		if (Role < ROLE_Authority && Other.Role == ROLE_Authority && Pawn(Other) != None)
			ClientSideTouch(Other, HitLocation);
	}
}


simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	if ( Instigator != None && (Other == Instigator) )
		return;

    if (Other == Owner) return;

	if ( !Other.IsA('Projectile') || Other.bProjTarget )
	{
		if ( Role == ROLE_Authority )
		{
			if ( Instigator == None || Instigator.Controller == None )
				Other.SetDelayedDamageInstigatorController( InstigatorController );
			if (Lifespan > 0)
			Other.TakeDamage(Damage/Lifespan, Instigator, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType);
		}
	}
	
	if (RuneFireballProj(Other) != None)
	{
		if (Role == ROLE_Authority)
		{
			Explode(HitLocation, -Normal(Velocity));	
			RuneFireballProj(Other).Destroy();
		}
	}
}

function Explode(vector HitLocation, vector HitNormal)
{
	local Actor A;
	if (Role == ROLE_Authority)
		HurtRadius( HeatBlastDamage, HeatBlastRadius, MyDamageType, MomentumTransfer, HitLocation );
	A = Spawn(Class'MeteorExplosion',,,HitLocation);
	if (A != None)
		A.RemoteRole = ROLE_SimulatedProxy;
	PlaySound(sound'ONSVehicleSounds-S.Explosions.Explosion08',,3.5*TransientSoundVolume);
	Destroy();
}

function bool EncroachingOn(Actor Other)
{
	return False;
}


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
     HeatBlastDamage=200
	 HeatBlastRadius=800.000000
     Speed=600.000000
     MaxSpeed=600.000000
     Damage=80.000000
     MomentumTransfer=30000.000000
     MyDamageType=Class'DEKRPG209B.DamTypeRuneHeatwave'
     LightType=LT_Steady
     LightEffect=LE_Spotlight
     LightHue=20
     LightSaturation=50
     LightBrightness=300.000000
     LightRadius=30.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DEKStaticsMaster209C.fX.SolarWave'
     bDynamicLight=True
     bIgnoreEncroachers=True
     LifeSpan=4.500000
     CollisionRadius=140.000000
     CollisionHeight=80.000000
     PrePivot=(X=210.000000)
     Skins(0)=FinalBlend'DEKRPGTexturesMaster209B.fX.ShieldHitOrangeEdgesFinal'
     Skins(1)=Texture'AW-2k4XP.Weapons.ElectricShockTex2'
     AmbientGlow=254
     bCollideWorld=False
     bIgnoreOutOfWorld=True
}
