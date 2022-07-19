class RuneIcicle extends Actor
	config(UT2004RPG);

var config int SpikeDamage;
var Class<DamageType> MyDamageType;
var float Counter;
var int StopCounter;
var float MaxDrawScale;
var config float DrawInterval;
var int TouchCounter;
var config int TouchThreshold;
var config int MaxShards;

#exec  AUDIO IMPORT NAME="IcicleGrowth" FILE="Sounds\IcicleGrowth.WAV" GROUP="RuneSounds"
#exec  AUDIO IMPORT NAME="IcicleShatter" FILE="Sounds\IcicleShatter.WAV" GROUP="RuneSounds"

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetPhysics(PHYS_None);
	Counter = 0.0f;
	TouchCounter = 0;
	SetTimer(DrawInterval, True);
}

simulated function Timer()
{
	local float Growth;

	if (Drawscale > MaxDrawScale || Counter >= StopCounter)
	{
		SetDrawscale(MaxDrawScale);
		SetTimer(0, False);
		return;
	}
	Growth = MaxDrawScale/(StopCounter/DrawInterval);
	SetDrawscale(Drawscale + Growth);
	if (Counter == 0.f)
		DoSound();
	Counter = Counter + DrawInterval;
}

function DoSound()
{
	PlaySound(Sound'DEKRPG999X.RuneSounds.IcicleGrowth', SLOT_None, 3 * TransientSoundVolume);
}

simulated function Touch(Actor Other)
{
    if (Other != None && Instigator != None)
	{
		if (Pawn(Other) != None && Pawn(Other).Health > 0 && Pawn(Other).Velocity != Vect(0,0,0) && Pawn(Other).GetTeamNum() != Instigator.GetTeamNum())
		{
			TouchCounter++;
			if (TouchCounter >= TouchThreshold)
			{
				Pawn(Other).TakeDamage(SpikeDamage, Instigator, Pawn(Other).Location, Vect(0,0,0), MyDamageType);
				TouchCounter = 0;
			}
		}
	}
}

event Landed( vector HitNormal )
{
	Velocity = Vect(0, 0, 0);
	Super.Landed(HitNormal);
}

function Shatter()
{
	local RuneIcicleShard Shards;
	local int x;
	
	for (x = 0; x < MaxShards; x++)
	{
		Shards = Spawn(Class'RuneIcicleShard', Instigator, , Self.Location + Vect(0,0,60), RotRand());
	}
	PlaySound(Sound'DEKRPG999X.RuneSounds.IcicleShatter', SLOT_None, 3 * TransientSoundVolume);
	Destroy();
}

defaultproperties
{
	MaxDrawscale=1.0000000000
	DrawInterval=0.1000000	//The interval rate to grow the icicle to simulate the appearance of icicles forming from the ground
	StopCounter=1	//Divide this number by DrawInterval to get the number of iterations done to grow the icicle
	TouchThreshold=2
	SpikeDamage=2
	MaxShards=6
	Lifespan=10.00000
	DrawType=DT_StaticMesh
	StaticMesh=StaticMesh'AW-2004Crystals.Crops.CrystalOutcrop3'
	Drawscale=0.000000000
	bIgnoreVehicles=True
	bOrientOnSlope=True
	bIgnoreEncroachers=True
	bUseCollisionStaticMesh=True
	bCollideActors=True
	bCollideWorld=False
	Mass=50000.000000
}
