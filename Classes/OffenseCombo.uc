class OffenseCombo extends Actor
	config(UT2004RPG);

enum EffectRange
{
	RANGE_Single,		//Targets a single enemy
	RANGE_Near,			//Targets all enemies near player
	RANGE_All			//Targets all enemies in level
};
var Altar Altar;
var EffectRange DamageRange;
var int NumHits;					//How many hits does a target receive?
var int DamageAmount;				//How much damage does each hit do?
var Class<DamageType> DamageType;
var float TimeBetweenHits;

var int HitCounter;

function StartDamage()
{
	HitCounter = 0;
	SetTimer(TimeBetweenHits, True);
}

function Timer()
{
	local Controller C, NextC;
	local Pawn Target;
	local int HighestHealth;

	if (Instigator == None || Instigator.Controller == None || Instigator.Health <= 0)
	{
		Destroy();
		return;
	}

	if (Altar == None)
	{
		Destroy();
		return;
	}

	if (HitCounter >= NumHits)
	{
		Destroy();
		return;
	}

	Log("Ready to do damage in OffenseCombo");

	if (DamageRange == RANGE_Single)		//Search for enemy with highest health
	{
		Log("DamageRange is RANGE_Single");
		C = Level.ControllerList;
		HighestHealth = 0;
		while (C != None)
		{
			NextC = C.NextController;
			if (C != None && C.Pawn != None && C.Pawn.Health > 0 && Instigator != None && C.Pawn.GetTeamNum() != Instigator.GetTeamNum() && C.Pawn.Health > HighestHealth)
			{
				HighestHealth = C.Pawn.Health;
				Target = C.Pawn;
			}
			C = NextC;
		}
		if (Target != None)
		{
			Log("Found Target");
			Target.TakeDamage(DamageAmount, Instigator, Target.Location, Vect(0, 0, 0), Class'DamTypeCombo');
		}
	}
	else if (DamageRange == RANGE_Near)
	{
		ForEach Altar.TouchingActors(Class'Pawn', Target)
		{
			if (Target != None && Target.Health > 0 && Instigator != None && Target.GetTeamNum() != Instigator.GetTeamNum())
				Target.TakeDamage(DamageAmount, Instigator, Target.Location, Vect(0, 0, 0), Class'DamTypeCombo');
		}	
	}
	else if (DamageRange == RANGE_All)
	{
		C = Level.ControllerList;
		while (C != None)
		{
			NextC = C.NextController;
			if (C != None && C.Pawn != None && C.Pawn.Health > 0 && Instigator != None && C.Pawn.GetTeamNum() != Instigator.GetTeamNum())
				C.Pawn.TakeDamage(DamageAmount, Instigator, C.Pawn.Location, Vect(0, 0, 0), Class'DamTypeCombo');
			C = NextC;
		}
	}
	HitCounter++;
}

defaultproperties
{
	DrawType=DT_None
	AmbientGlow=0
	bHidden=true
	Physics=PHYS_None
	bReplicateMovement=false
}
