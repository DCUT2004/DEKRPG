//Adds temporary adrenaline over the default max
//This called by the Adren Heal combo, which heals adren beyond the max, which is stored as temporary max adren
//When the adrenaline drops below the default max, this inventory item is destroyed
class AdrenMaxTempInv extends Inventory
	config(UT2004RPG);

var Pawn PawnOwner;
var int OriginalMaxAdren;
var config int MaxMultiplier;

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
		if (PawnOwner.Controller.Adrenaline > OriginalMaxAdren*MaxMultiplier)	//In case combos increase the max adren cap to a high amount, this will limit the max according to MaxMultiplier
			PawnOwner.Controller.Adrenaline = OriginalMaxAdren*MaxMultiplier;
		if (PawnOwner.Controller.Adrenaline < PawnOwner.Controller.AdrenalineMax)	//Continously reset the max adrenaline when the player consumes/loses adrenaline
			PawnOwner.Controller.AdrenalineMax = PawnOwner.Controller.Adrenaline;
		if (PawnOwner.Controller.Adrenaline < OriginalMaxAdren)	//When the current adrenaline falls below the original starting max adren amount, destroy this inventory item
		{
			PawnOwner.Controller.AdrenalineMax = OriginalMaxAdren;
			Destroy();
			return;
		}
	}
}

defaultproperties
{
	 MaxMultiplier=2.00000
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
