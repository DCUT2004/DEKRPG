//Permanently increases/decreases the max shield
//This is never destroyed. Done this way so restarting the pawn after ghosting doesn't re-apply the boost again
class ShieldMaxPermInv extends Inventory;

var float Boost;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	Super.GiveTo(Other);
	if (Other != None && Other.Controller != None)
		if (xPawn(Other) != None)
			xPawn(Other).ShieldStrengthMax *= Boost;
		
}

defaultproperties
{
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
