class DruidGhostInvulInv extends Inventory;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	Super.GiveTo(Other);
	if (Other != None && Other.Controller != None)
	{
		if (!Other.Controller.bGodMode)
			Other.Controller.bGodMode = True;
	}
}

simulated function Destroyed()
{
	if (Pawn(Owner) != None && Pawn(Owner).Controller != None && Pawn(Owner).Controller.bGodMode)
		Pawn(Owner).Controller.bGodMode = False;
	Super.Destroyed();
}

defaultproperties
{
	 Lifespan=3.000000000
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
