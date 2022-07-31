class Mission1Inv extends MissionSoloInv
	config(UT2004RPG);

simulated function destroyed()
{
 	if( InteractionOwner != None )
 	{
 		//InteractionOwner.M1Inv = None;
 		InteractionOwner = None;
 	}
	super.destroyed();
}

defaultproperties
{
}
