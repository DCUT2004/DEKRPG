class TutorialInv extends Inventory
	config(UT2004RPG);

var config int TutorialLevel;
var RPGStatsInv StatsInv;
var TutorialDrone D;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	SetTimer(1.5, False);
	Super.GiveTo(Other);
}

function Timer()
{
	if (Instigator == None || Instigator.Controller == None)
	{
		Destroy();
		return;
	}
	if (StatsInv == None)
		StatsInv = RPGStatsInv(Instigator.FindInventoryType(class'RPGStatsInv'));
		
	if (StatsInv != None && StatsInv.DataObject.Level > TutorialLevel)	//This player is above the tutorial level. Turn off god mode and destroy this inventory
	{
		Destroy();
		return;
	}
	SpawnDrone(Instigator);
}

simulated function SpawnDrone(Pawn P)
{
	D = P.Spawn(class'TutorialDrone',P,,P.Location+vect(0,-32,64),P.Rotation);
	if (D != None)
	{
		D.protPawn = P;
		if (D.P != None)
			D.P.CanDefend = True;
	}
}

defaultproperties
{
	 TutorialLevel=30
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
