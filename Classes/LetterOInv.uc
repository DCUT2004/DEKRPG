class LetterOInv extends LetterInv
	config(UT2004RPG);

simulated function destroyed()
{
 	if( InteractionOwner != None )
 	{
 		InteractionOwner.OInv = None;
 		InteractionOwner = None;
 	}
	super.destroyed();
}

defaultproperties
{
     LetterClass=Class'DEKRPG208AJ.LetterOInv'
     PickupClass=Class'DEKRPG208AJ.ArtifactLetterOPickup'
}
