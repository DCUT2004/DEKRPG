class GenomeVialCosmic extends Inventory;

var MutMissionMultiplayer MMPI;

simulated function PostBeginPlay()
{
	local Mutator m;
	
    Super.PostBeginPlay();
	
	if (Level.Game != None)
		for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
			if (MutMissionMultiplayer(m) != None)
			{
				MMPI = MutMissionMultiplayer(m);
				break;
			}
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	if(Other == None)
	{
		destroy();
		return;
	}
	SetTimer(1, True);

	Super.GiveTo(Other);
}

simulated function Timer()
{
	local Translauncher Trans;
	
	Trans = Translauncher(Instigator.Weapon);
	
	Instigator.ReceiveLocalizedMessage(class'MissionGenomeProjectReturnMessage', 0);
	if (MMPI != None && (MMPI.Stopped || !MMPI.GenomeProjectActive))
		Destroy();
	if (Trans != None)
		Dropped();
}

simulated function Dropped()
{
	Instigator.ReceiveLocalizedMessage(class'MissionGenomeProjectDroppedMessage', 0);
	Destroy();
}

defaultproperties
{
     PickupClass=Class'DEKRPG209F.GenomeVialCosmicPickup'
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
