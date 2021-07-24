class Mission3Inv extends MissionSoloInv
	config(UT2004RPG);

simulated function destroyed()
{
 	if( InteractionOwner != None )
 	{
 		InteractionOwner.M3Inv = None;
 		InteractionOwner = None;
 	}
	super.destroyed();
}

defaultproperties
{
}
