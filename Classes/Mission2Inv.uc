class Mission2Inv extends MissionSoloInv
	config(UT2004RPG);

simulated function destroyed()
{
 	if( InteractionOwner != None )
 	{
 		InteractionOwner.M2Inv = None;
 		InteractionOwner = None;
 	}
	super.destroyed();
}

defaultproperties
{
}
