//Permanently modifies the max adrenaline
//This inventory item is given via Materials
//Some abilities modify the max adrenaline. This inventory item waits a few seconds before modifying adrenaline, as those abilities set the max adren rather than modify them on a current value
//This is never destroyed. Done this way so restarting the pawn after ghosting doesn't re-apply the boost again
class AdrenMaxMaterialInv extends Inventory;

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
	if (Instigator != None && Instigator.Controller != None)
	{
		if (!bBoosted)
		{
			Instigator.Controller.AdrenalineMax *= Boost;	//A float
			Instigator.Controller.AdrenalineMax = int(Instigator.Controller.AdrenalineMax);	//Int
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
