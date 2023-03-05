class PROJ_FireBallTurretSmall extends PROJ_FireBallTurretLarge;

var Emitter Flames;
var class<Emitter> FlamesClass;

simulated function PostBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer)
	{
		if ( !Level.bDropDetail )
			spawn(class'RocketSmokeRing',,,Location, Rotation );
		Flames = Spawn(FlamesClass,self);
    	if ( Flames != None )
    		Flames.SetBase( Self );
	}
	Dir = vector(Rotation);
	Velocity = speed * Dir;
    if ( Level.bDropDetail )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}
	Super(Projectile).PostBeginPlay();
}

simulated function Destroyed() 
{
	if ( Flames != None )
		Flames.Destroy();
	Super.Destroyed();
}

defaultproperties
{
	 FlamesClass=class'FX_FireBallSmall'
     MaxSpeed=8000.000000
     Speed=8000.0000
     Damage=45.0000
     MyDamageType=Class'DEKRPG999X.DamTypeFireBallTurret'
     DrawScale=1.0
     LifeSpan=10.0
}
