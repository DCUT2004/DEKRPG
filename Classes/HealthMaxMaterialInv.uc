//Permanently modifies the max health
//This inventory item is given via Materials
//Some abilities modify the max health. This inventory item waits a few seconds before modifying health, as those abilities set the max health rather than modify them on a current value
//This is never destroyed. Done this way so restarting the pawn after ghosting doesn't re-apply the boost again
class HealthMaxMaterialInv extends Inventory;

var float Boost;
var bool bBoosted;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	Super.GiveTo(Other);
	Instigator = Other;
	bBoosted = False;
	SetTimer(5, False);	
}

function Timer()
{
	if (Instigator != None)
	{
		if (!bBoosted)
		{
			Instigator.HealthMax *= Boost;
			bBoosted = True;
		}
	}
}

defaultproperties
{
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
