class LetterSInv extends LetterInv
	config(UT2004RPG);

simulated function destroyed()
{
 	if( InteractionOwner != None )
 	{
 		InteractionOwner.SInv = None;
 		InteractionOwner = None;
 	}
	super.destroyed();
}

defaultproperties
{
     LetterClass=Class'DEKRPG999X.LetterSInv'
     PickupClass=Class'DEKRPG999X.ArtifactLetterSPickup'
}
