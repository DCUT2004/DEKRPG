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
     LetterClass=Class'DEKRPG209F.LetterOInv'
     PickupClass=Class'DEKRPG209F.ArtifactLetterOPickup'
}
