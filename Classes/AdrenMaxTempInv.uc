//Adds temporary adrenaline over the default max
//This called by the Adren Heal combo, which heals adren beyond the max, which is stored as temporary max adren
//When the adrenaline drops below the default max, this inventory item is destroyed
class AdrenMaxTempInv extends Inventory;

var Pawn PawnOwner;
var int OriginalMaxAdren;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	Super.GiveTo(Other);
	PawnOwner = Other;
	SetTimer(0.1, True);
}

simulated function Timer()
{
	if (PawnOwner != None && PawnOwner.Controller != None)
	{
		if (PawnOwner.Controller.Adrenaline < PawnOwner.Controller.AdrenalineMax)
			PawnOwner.Controller.AdrenalineMax = PawnOwner.Controller.Adrenaline;
		if (PawnOwner.Controller.Adrenaline < OriginalMaxAdren)
		{
			PawnOwner.Controller.AdrenalineMax = OriginalMaxAdren;
			Destroy();
			return;
		}
	}
}

defaultproperties
{
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
