class TutorialInv extends Inventory;

var config int TutorialLevel;
var RPGStatsInv StatsInv;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	if (Other != None && Other.Controller != None)
		Other.Controller.bGodMode = True;
	SetTimer(0.5, True);
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
		Instigator.Controller.bGodMode = False;
		Destroy();
		return;
	}
		
	if (!Instigator.Controller.bGodMode)
		Instigator.Controller.bGodMode = True;
}

defaultproperties
{
	 TutorialLevel=23
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
