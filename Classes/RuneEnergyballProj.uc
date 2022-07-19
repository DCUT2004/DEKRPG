class RuneEnergyballProj extends ONSShockTankProjectile
	config(UT2004RPG);

var EnergyBallEffect EnergyBallEffect;
var config float EnergyStealInterval;
var config float EnergyStealRadius;
var config int AdrenAddPerStrike;
var config int StrikeDamage;
var class<xEmitter> StrikeEmitterClass;

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
        EnergyBallEffect = Spawn(class'EnergyBallEffect', self);
        EnergyBallEffect.SetBase(self);
	}

	Velocity = Speed * Vector(Rotation); // starts off slower so combo can be done closer

    tempStartLoc = Location;
	SetTimer(EnergyStealInterval, True);
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

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	local RuneEnergyFusion Fusion;
	
	if (Other != None)
	{
		if (Instigator != None && RuneEnergyballProj(Other) != None)
		{
			//Only want one Fusion to spawn, so need to destroy the other Energyball first
			if (RuneEnergyballProj(Other).Lifespan < Self.Lifespan)
				RuneEnergyballProj(Other).SuperExplosion();
			Fusion = Instigator.Spawn(Class'RuneEnergyFusion', Instigator, , Self.Location);
			SuperExplosion();
		}
	}
}

function Timer()
{
	local Pawn Victim;
	local xEmitter HitEmitter;
	local AdrenParticle FX;
	
	if (Instigator == None || Instigator.Controller == None)
		return;
	
	foreach VisibleCollidingActors(class'Pawn', Victim, EnergyStealRadius, Self.Location)
	{
		if (Victim != None && Victim.Health > 0 && Victim.GetTeamNum() != Instigator.GetTeamNum())
		{
			Victim.TakeDamage(StrikeDamage, Instigator, Victim.Location, Vect(0,0,0), MyDamageType);
			Instigator.Controller.Adrenaline += AdrenAddPerStrike;
			Instigator.PlaySound(Sound'PickupSounds.AdrenelinPickup',, 1.5 * Instigator.TransientSoundVolume,, 1.5 * Instigator.TransientSoundRadius);
			HitEmitter = spawn(StrikeEmitterClass,,, Self.Location, rotator(Victim.Location - Self.Location));
			if (HitEmitter != None)
				HitEmitter.mSpawnVecA = Victim.Location;
			FX = Spawn(Class'AdrenParticle', Self, , Victim.Location);
			if (FX != None)
				FX.Seeking = Self;
			break;
		}
	}
}

function SuperExplosion()
{
	local actor HitActor;
	local vector HitLocation, HitNormal;

	HurtRadius(ComboDamage, ComboRadius, MyDamageType, ComboMomentumTransfer, Location );

	Spawn(class'EnergyballExplosion');
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
	if (EnergyBallEffect != None)
		EnergyBallEffect.Destroy();
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
    if (EnergyBallEffect != None)
    {
		if ( bNoFX )
			EnergyBallEffect.Destroy();
		else
			EnergyBallEffect.Kill();
	}

	Super.Destroyed();
}

defaultproperties
{
	 AdrenAddPerStrike=4
	 StrikeDamage=10
	 EnergyStealInterval=0.700000
	 EnergyStealRadius=600.00000
	 ComboDamage=70.00000
     ComboRadius=200.000000
     ComboMomentumTransfer=0.000000
     Speed=500.000000
     MaxSpeed=500.000000
     StrikeEmitterClass=Class'DEKRPG999X.BronzeBoltEmitter'
     MyDamageType=Class'DEKRPG999X.DamTypeRuneEnergySteal'
	 DrawType=DT_Sprite
     DrawScale=0.010000
     Skins(0)=FinalBlend'D-E-K-HoloGramFX.NonWireframe.FunkyStuff_0'
	 CollisionHeight=20.00000
	 CollisionRadius=20.00000
     LightHue=20
}
