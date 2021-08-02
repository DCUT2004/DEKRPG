//Permanently modifies the max dodge speed
//This inventory item is given via Materials
//Some abilities modify the max dodge speed. This inventory item waits a few seconds before modifying the max dodge speed, as those abilities set the max dodge speed rather than modify them on a current value
//This is never destroyed. Done this way so restarting the pawn after ghosting doesn't re-apply the boost again
//Unlike max adren and max HP, we do not need a bBoosted boolean because the Nimble ability will always set the max dodge speed when spawning and reviving after ghosting, so this inventory will always need to adjust the value in Timer

class DodgeSpeedMaxMaterialInv extends Inventory;

var float Boost;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	Super.GiveTo(Other);
	Instigator = Other;
	SetTimer(5, False);	
}

simulated function Timer()
{
	if (Instigator != None && xPawn(Instigator) != None && xPawn(Instigator).Role == ROLE_Authority)
	{
		xPawn(Instigator).DodgeSpeedFactor *= Boost;
		xPawn(Instigator).DodgeSpeedZ *= Boost;
	}
}

defaultproperties
{
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
