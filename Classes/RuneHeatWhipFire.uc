class RuneHeatWhipFire extends RuneInstantFire
	config(DEKWeapons);
	
#exec  AUDIO IMPORT NAME="HeatWhipThrow" FILE="Sounds\HeatWhipThrow.WAV" GROUP="RuneSounds"
#exec  AUDIO IMPORT NAME="HeatWhipCrack" FILE="Sounds\HeatWhipCrack.WAV" GROUP="RuneSounds"

var RuneHeatWhipFX FX;
var Vector WhipEnd;
var Pawn Victim;
var bool bCracked;
var config float SearchHitRadius;

simulated function ModeTick(float dt)
{
	Super.ModeTick(dt);
	
	if (FX != None)
	{
		FX.SetBase(Instigator);
		if (Victim != None)
		{
			FX.mSpawnVecA = Victim.Location;
			FX.SetRotation(rotator(Victim.Location - Instigator.Location));
		}
		else
		{
			FX.mSpawnVecA = WhipEnd;
			FX.SetRotation(rotator(WhipEnd - Instigator.Location));
		}
	}
}

function DoTrace(Vector Start, Rotator Dir)
{
    local Vector X, End, HitLocation, HitNormal;
    local Actor Other;
	
	if (Instigator == None || Instigator.Controller == None)
		return;
	GoToState('');
	if (FX != None)
	{
		FX.Destroy();
		FX = None;
	}
	Instigator.PlaySound(Sound'DEKRPG209C.RuneSounds.HeatWhipThrow',SLOT_None,Instigator.TransientSoundVolume*5.0);
	MaxRange();
	X = Vector(Dir);
	End = Start + TraceRange * X;

	Other = Weapon.Trace(HitLocation, HitNormal, End, Start, true);
	if (Other != None)
	{
		if (Pawn(Other) != None)
		{
			if (Pawn(Other).Health > 0 && Pawn(Other).GetTeamNum() != Instigator.GetTeamNum())
			{
				SpawnHeatWhip(HitLocation);
				Victim = Pawn(Other);
			}
		}
		else	//Hit some Actor, but not a Pawn. Check if there's a nearby Pawn
		{
			SpawnHeatWhip(HitLocation);
			Victim = searchPawn(HitLocation);
		}
	}
	else	//Hit nothing at all. See if we can find a nearby Pawn
	{
		SpawnHeatWhip(End);
		Victim = searchPawn(End);
	}
	
	
	if (Victim != None)
		GoToState('Crack');
	else
		GoToState('WhipMiss');
}

function Pawn searchPawn(vector SearchLocation)
{
	local Controller C, NextC;
	
	C = Level.ControllerList;
	
	while (C != None)
	{
		NextC = C.NextController;
		if (C != None && C.Pawn != None && C.Pawn.Health > 0 && Instigator != None && !C.SameTeamAs(Instigator.Controller) && VSize(C.Pawn.Location - SearchLocation) <= SearchHitRadius){
			if (!C.Pawn.IsA('SMPTitan') &&  BossInv(C.Pawn.FindInventoryType(class'BossInv')) == None){
				return C.Pawn;
			}
		}
		C = NextC;
	}
	return None;
}

function SpawnHeatWhip(Vector EndLocation)
{
	WhipEnd = EndLocation;
	if (FX == None)
		FX = Weapon.Spawn(Class'RuneHeatWhipFX', Instigator, , Instigator.Location, rotator(EndLocation - Instigator.Location));
	if (FX != None)
	{
		FX.SetBase(Instigator);
		FX.mSpawnVecA = EndLocation;
		FX.SetRotation(rotator(EndLocation - Instigator.Location));
	}
}

state WhipMiss
{
    function BeginState()
    {
		Victim = None;
        SetTimer(1.0, False);
    }

	function Timer()
    {
		if (FX != None)
		{
			FX.Destroy();
			FX = None;
		}
		SetTimer(0, False);
		return;
    }
}

state Crack
{
    function BeginState()
    {
		bCracked = False;
        SetTimer(1.0, True);
    }

	function Timer()
    {
		local int Damage;
		local Vector Direction;
		local float Magnitude;
		
		if (bCracked){
			if (FX != None)
			{
				FX.Destroy();
				FX = None;
			}
			Victim = None;
			SetTimer(0, False);
			return;
		}
		
		Instigator.PlaySound(Sound'DEKRPG209C.RuneSounds.HeatWhipCrack',SLOT_None,Instigator.TransientSoundVolume*7.0);
		if (Victim != None)
		{
			//Control the Pawn(Other)'s movements
			//Get the vector between the Pawn(Other) and us
			Magnitude = -(VSize(Victim.Location - Instigator.Location));
			//Get the rotation
			Direction = Vector(Rotator(Victim.Location - Instigator.Location));	//A unit vector with a rotation
			//Pull Victim to our location
			Victim.SetPhysics(PHYS_Falling);
			Victim.Velocity.Z += 5*Victim.Mass;
			Victim.Velocity += 7*Direction*Magnitude;
			
			Damage = DamageMin;
			if ( (DamageMin != DamageMax) && (FRand() > 0.5) )
				Damage += Rand(1 + DamageMax - DamageMin);
			Damage = Damage * DamageAtten;
			Victim.TakeDamage(Damage, Instigator, Victim.Location, Vect(0,0,0), DamageType);
		}
		else	//Victim must have died in the 1 second between throwing and cracking
		{
			if (FX != None)
			{
				FX.Destroy();
				FX = None;
			}
			SetTimer(0, False);
			return;
		}
		
		if (FX != None)	//Tighten the whip as we crack and pull the victim
		{
			 FX.mWaveFrequency=0.000000;
			 FX.mWaveAmplitude=1.000000;
			 FX.mWaveShift=0.000000;
		}
		bCracked = True;
    }
}


defaultproperties
{
	 SearchHitRadius=80.0000
	 bModeExclusive=False
     DamageType=Class'DEKRPG209C.DamTypeRuneHeatWhip'
	 AdrenCost=10
	 DamageMin=150
	 DamageMax=160
	 FireRate=3.500000
     //FireSound=Sound'DEKRPG209C.RuneSounds.HeatWhipThrow'
     bReflective=False
     TraceRange=30000.000000
}
