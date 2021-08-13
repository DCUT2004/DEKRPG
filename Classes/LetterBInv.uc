class LetterBInv extends LetterInv
	config(UT2004RPG);
	
simulated function destroyed()
{
 	if( InteractionOwner != None )
 	{
 		InteractionOwner.BInv = None;
 		InteractionOwner = None;
 	}
	super.destroyed();
}

defaultproperties
{
     LetterClass=Class'DEKRPG208AG.LetterBInv'
     PickupClass=Class'DEKRPG208AG.ArtifactLetterBPickup'
}
