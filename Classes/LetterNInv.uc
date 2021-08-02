class LetterNInv extends LetterInv
	config(UT2004RPG);

simulated function destroyed()
{
 	if( InteractionOwner != None )
 	{
 		InteractionOwner.NInv = None;
 		InteractionOwner = None;
 	}
	super.destroyed();
}

defaultproperties
{
     LetterClass=Class'DEKRPG208AE.LetterNInv'
     PickupClass=Class'DEKRPG208AE.ArtifactLetterNPickup'
}
