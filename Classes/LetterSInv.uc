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
     LetterClass=Class'DEKRPG208AJ.LetterSInv'
     PickupClass=Class'DEKRPG208AJ.ArtifactLetterSPickup'
}
