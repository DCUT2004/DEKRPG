class MagicalWardProtectionInv extends Inventory;

var float ProtectionMultiplier;
var config float ProtectionPerWardMultiplier;
var config float MaxProtectionMultiplier;
var Emitter ProtectionEmitter;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	ProtectionMultiplier = 1 - ProtectionPerWardMultiplier;
	if (Other != None)
	{
		if (ProtectionEmitter == None)
		{
			ProtectionEmitter = Other.Spawn(class'ProtectionEffect', Other, , Other.Location);
			if (ProtectionEmitter != None)
			{
				ProtectionEmitter.bHardAttach = True;
				ProtectionEmitter.SetBase(Other);
			}
		}
	}
	Super.GiveTo(Other);
}

simulated function Destroyed()
{
	if (ProtectionEmitter != None)
		ProtectionEmitter.Destroy();
	Super.Destroyed();
}

defaultproperties
{
	 ProtectionPerWardMultiplier=0.03000000
	 MaxProtectionMultiplier=0.500000
	 Lifespan=10.000000
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
