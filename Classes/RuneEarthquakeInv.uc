class RuneEarthquakeInv extends Inventory
	config(UT2004RPG);
	
var config float CheckInterval;
var Class<DamageType> EarthquakeDamageType;
var config float Momentum;
var config float RequiredVelocity;
var bool bEarthquake;
var float MaxSpeed;
var config float DamageMultiplier, RadiusMultiplier;
var xEmitter EarthTrail;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	if (Other == None)
		Destroy();
	bEarthquake = False;
	MaxSpeed = 0.0;
	SetTimer(CheckInterval, True);
	Super.GiveTo(Other);
}

function Timer()
{
	local Actor A;
	local Emitter E;
	local float Speed;
	local RuneIcicle Icicle;
	
	if (Instigator == None || Instigator.Controller == None)
	{
		Destroy();
		return;
	}
	
	if (Instigator.Physics == PHYS_Falling)
	{
		if (VSize(Instigator.Velocity) >= RequiredVelocity)	//Need to reach terminal velocity to deal an earthquake
		{
			bEarthquake = True;
			if (EarthTrail == None)
			{
				EarthTrail = Instigator.Spawn(Class'GreenTrail', Instigator,,Instigator.Location, Instigator.Rotation);
				if (EarthTrail != None)
					EarthTrail.SetBase(Instigator);
			}
		}
		else
		{
			bEarthquake = False;
			if (EarthTrail != None)
				EarthTrail.Destroy();
		}
		Speed = VSize(Instigator.Velocity);
		if (Speed > MaxSpeed)
			MaxSpeed = Speed;
	}
	else
	{
		if (bEarthquake)
		{
			Instigator.HurtRadius(MaxSpeed*DamageMultiplier, MaxSpeed*RadiusMultiplier, EarthquakeDamageType, Momentum*MaxSpeed, Instigator.Location);
			foreach RadiusActors( class 'RuneIcicle', Icicle, MaxSpeed*RadiusMultiplier, Instigator.Location )
			{
				if (Icicle != None && Icicle.Instigator == Instigator)
					Icicle.Shatter();
			}
			A = Instigator.Spawn(class'EarthquakeExplosion', Instigator,, Instigator.Location);
			if ( A != None)
				A.RemoteRole = ROLE_SimulatedProxy;
			E = Instigator.Spawn(Class'GreenShockwaveFX', Instigator,, Instigator.Location);
			if (E != None)
				E.RemoteRole = ROLE_SimulatedProxy;
			Instigator.PlaySound(Sound'ONSVehicleSounds-S.Explosions.Explosion08',, Instigator.TransientSoundVolume*7);
		}
		Destroy();
		return;
	}
}

simulated function Destroyed()
{
	if (EarthTrail != None)
		EarthTrail.Destroy();
	Super.Destroyed();
}

defaultproperties
{
	 DamageMultiplier=0.1000000
	 RadiusMultiplier=0.500000
	 RequiredVelocity=2000.000000
	 EarthquakeDamageType=Class'DEKRPG209F.DamTypeRuneEarthquake'
	 CheckInterval=0.10000
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
	 Momentum=10
}
