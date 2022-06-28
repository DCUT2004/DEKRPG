class LetterUInv extends LetterInv
	config(UT2004RPG);

simulated function destroyed()
{
 	if( InteractionOwner != None )
 	{
 		InteractionOwner.UInv = None;
 		InteractionOwner = None;
 	}
	super.destroyed();
}

defaultproperties
{
     LetterClass=Class'DEKRPG209E.LetterUInv'
     PickupClass=Class'DEKRPG209E.ArtifactLetterUPickup'
}
