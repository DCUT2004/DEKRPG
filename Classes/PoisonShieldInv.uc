class PoisonShieldInv extends Inventory
	config(UT2004RPG);

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	Super.GiveTo(Other);
	SetTimer(0.5, True);
}

simulated function Timer()
{
	local DruidPoisonInv DPInv;
	local PoisonInv PInv;
	if (Instigator == None)
	{
		Destroy();
		return;
	}

	if (Instigator == None || Instigator.Health < 0)
	{
		Destroy();
		return;     // cant do anything
	}
	else
	{
		DPInv = DruidPoisonInv(Instigator.FindInventoryType(class'DruidPoisonInv'));
		PInv = PoisonInv(Instigator.FindInventoryType(class'PoisonInv'));
		
		if (DPInv != None)
			DPInv.Destroy();
		if (PInv != None)
			PInv.Destroy();
	}
}

defaultproperties
{
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
