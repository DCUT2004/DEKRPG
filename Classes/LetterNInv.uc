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
     LetterClass=Class'DEKRPG209E.LetterNInv'
     PickupClass=Class'DEKRPG209E.ArtifactLetterNPickup'
}
