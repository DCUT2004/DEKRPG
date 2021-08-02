//Permanently adjusts the max health on a player
//This inventory is granted to a player via an ability
//This inventory is called only once when a player spawns. This item must remain on the Pawn, as reviving after ghosting will check for this to ensure the Pawn does not receive an additional adjustment to the max adren

class HealthMaxModifierInv extends Inventory;

var float Multiplier;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	if (Multiplier <= 0.00000)
	{
		Destroy();
		return;
	}
	if (Other != None)
		Other.HealthMax *= Multiplier;
	Super.GiveTo(Other);
}

defaultproperties
{
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
