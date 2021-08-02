//Permanently adjusts the max adrenaline on a player
//This inventory is granted to a player via an ability
//This inventory is called only once when a player spawns. This item must remain on the Pawn, as reviving after ghosting will check for this to ensure the Pawn does not receive an additional adjustment to the max adren
class AdrenMaxModifierInv extends Inventory;

var float Multiplier;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	if (Multiplier <= 0.00000)
	{
		Destroy();
		return;
	}
	if (Other != None)
	{
		if (Other.Controller != None)
		{
			Other.Controller.AdrenalineMax *= Multiplier;
			Other.Controller.AdrenalineMax = int(Other.Controller.AdrenalineMax);
		}
	}
	Super.GiveTo(Other);
}

defaultproperties
{
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
