class OffenseCombo extends Actor
	abstract
	config(UT2004RPG);

var int NumTargets;					//How many targets do we damage per hit? 0 for all enemies
var int NumHits;					//How many hits does a target receive?
var int DamagePerHit;				//How much damage does each hit do?
var Class<DamageType> DamageType;
var int TimeBetweenHits;

var int HitCounter;

function StartDamage()
{
	SetTimer(TimeBetweenHits, True);
}

function Timer()
{
	local Controller C, NextC;
	local int TargetCounter;
	
	if (Instigator == None || Instigator.Controller == None || Instigator.Health <= 0)
		Destroy();
	
	HitCounter++;
	if (HitCounter >= NumHits)
		Destroy();
	
	C = Level.ControllerList;
	
	while (C != None)
	{
		NextC = C.NextController;
		
		if (C != None && C.Pawn != None && C.Pawn.Health > 0 && C.Pawn.GetTeamNum() != Instigator.GetTeamNum())
		{
			DoDamage(C.Pawn);
			//Successfully hit a target. Determine whether we should continue to search for another pawn
			TargetCounter++;
			if (NumTargets != 0 && TargetCounter >= NumTargets)
			{
				Destroy();
				break;
			}
		}
		
		C = NextC;
	}
}

function DoDamage(Pawn Target);		//Should be overridden

defaultproperties
{
	DrawType=DT_None
	AmbientGlow=0
	bHidden=true
	Physics=PHYS_None
	bReplicateMovement=false
}
