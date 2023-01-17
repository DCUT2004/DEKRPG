class DualityInv extends Inventory;

var Pawn PawnOwner;
var class<weapon> DualWeaponOne, DualWeaponTwo;
var int DualityKills;
var DualityInvHolder Holder;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
	reliable if (Role == ROLE_Authority)
		DualWeaponOne, DualWeaponTwo, DualityKills;
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{	
	if(Other == None)
	{
		destroy();
		return;
	}
	if (Other != None)
		PawnOwner = Other;

	foreach PawnOwner.DynamicActors(class'DualityInvHolder', Holder)
		if (Holder != None && Holder.Owner == PawnOwner.Controller)
		{
			if (Holder.DualityKills > 0)
			{
				DualityKills = Holder.DualityKills;
			}
			Holder.Destroy();
		}
	Super.GiveTo(Other);
}

simulated function AddKill(int Kills)
{
	DualityKills += Kills;
}

static function class<weapon> GetDualWeaponOne()
{
	return default.DualWeaponOne;
}

static function class<weapon> GetDualWeaponTwo()
{
	return default.DualWeaponTwo;
}

simulated function destroyed()
{	
	if(PawnOwner.isA('Vehicle'))
	{
		PawnOwner = Vehicle(PawnOwner).Driver;
	}
	if (DualityKills > 0)
	{
		if (PawnOwner.Controller != None)
		{
			Holder = PawnOwner.spawn(class'DualityInvHolder',PawnOwner.Controller);
			if (Holder != None)
			{
				Holder.DualityKills = DualityKills;
				Holder.SetOwner(PawnOwner.Controller);
			}
		}
	}
	super.destroyed();
}

defaultproperties
{
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
