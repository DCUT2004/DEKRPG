//Adds temporary shield over the default max
//When the shield drops below the default max, this inventory item is destroyed
class ShieldMaxInv extends Inventory;

var Pawn PawnOwner;
var int OriginalMaxShield;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	Super.GiveTo(Other);
	PawnOwner = Other;
	SetTimer(0.1, True);
}

simulated function Timer()
{
	local xPawn xP;
	if (PawnOwner != None && xPawn(PawnOwner) != None)
	{
		xP = xPawn(PawnOwner);
		if (xP.ShieldStrength < xP.GetShieldStrengthMax())
			xP.ShieldStrengthMax = xP.ShieldStrength;
		if (xP.ShieldStrength < OriginalMaxShield)
		{
			xP.ShieldStrengthMax = OriginalMaxShield;
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
