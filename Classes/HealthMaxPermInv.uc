//Permanently increases/decreases the max health
//This is never destroyed. Done this way so restarting the pawn after ghosting doesn't re-apply the boost again
class HealthMaxPermInv extends Inventory;

var float Boost;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	Super.GiveTo(Other);
	if (Other != None && Other.Controller != None)
		Other.HealthMax *= Boost;
		
}

defaultproperties
{
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
