class RuneIceballProj extends ONSShockTankProjectile;

var IceBallEffect IceBallEffect;

simulated function PostBeginPlay()
{
	Super(Projectile).PostBeginPlay();
	
	if (ONSShockBallEffect != None)
	{
		if ( bNoFX )
			ONSShockBallEffect.Destroy();
		else
			ONSShockBallEffect.Kill();
	}

    if ( Level.NetMode != NM_DedicatedServer )
	{
        IceBallEffect = Spawn(class'IceBallEffect', self);
        IceBallEffect.SetBase(self);
	}

	Velocity = Speed * Vector(Rotation); // starts off slower so combo can be done closer

    tempStartLoc = Location;
}

simulated function PostNetBeginPlay()
{
	Super.PostNetBeginPlay();
	if (ONSShockBallEffect != None)
	{
		if ( bNoFX )
			ONSShockBallEffect.Destroy();
		else
			ONSShockBallEffect.Kill();
	}	
}


function SuperExplosion()
{
	local actor HitActor;
	local vector HitLocation, HitNormal;

	HurtRadius(ComboDamage, ComboRadius, MyDamageType, ComboMomentumTransfer, Location );

	Spawn(class'IceballExplosion');
	if ( (Level.NetMode != NM_DedicatedServer) && EffectIsRelevant(Location,false) )
	{
		HitActor = Trace(HitLocation, HitNormal,Location - Vect(0,0,120), Location,false);
		if ( HitActor != None )
			Spawn(class'ComboDecal',self,,HitLocation, rotator(vect(0,0,-1)));
	}
	PlaySound(Sound'VehicleExplosion02', SLOT_None,1.0,,800);
    DestroyTrails();
    Destroy();
}

simulated function DestroyTrails()
{
    if (ONSShockBallEffect != None)
        ONSShockBallEffect.Destroy();
	if (IceBallEffect != None)
		IceBallEffect.Destroy();
}

simulated function Destroyed()
{
    if (ONSShockBallEffect != None)
    {
		if ( bNoFX )
			ONSShockBallEffect.Destroy();
		else
			ONSShockBallEffect.Kill();
	}
    if (IceBallEffect != None)
    {
		if ( bNoFX )
			IceBallEffect.Destroy();
		else
			IceBallEffect.Kill();
	}

	Super.Destroyed();
}

defaultproperties
{
	 ComboDamage=70.00000
     ComboRadius=200.000000
     ComboMomentumTransfer=235000.000000
     Speed=1200.000000
     MaxSpeed=1200.000000
     MyDamageType=Class'DEKRPG209E.DamTypeRuneIceball'
}
