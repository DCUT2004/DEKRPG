class AASentinelController extends DruidSentinelController;

function bool IsTargetRelevant( Pawn Target )
{
	if ( (Target != None) && (Target.Controller != None) 
		&& (Target.Health > 0) && (VSize(Target.Location-Pawn.Location) < Pawn.SightRadius*1.25)
        && (Target.Physics == PHYS_Flying) 
		&& (((TeamGame(Level.Game) != None) && !SameTeamAs(Target.Controller))
		|| ((TeamGame(Level.Game) == None) && (Target.Owner != PlayerSpawner))))
		return true;

	return false;
}

function Tick(float DeltaTime)
{
	// need to check for any monsters to target
	local Controller C, NextC;

	TimeSinceCheck+=DeltaTime;
	
	if (PlayerSpawner == None || PlayerSpawner.Pawn == None)
		return;

	if(TimeSinceCheck>1.0)
	{
		TimeSinceCheck-=1.0;
		C = Level.ControllerList;
		while (C != None)
		{
			// get next controller here because C may be destroyed if it's a nonplayer and C.Pawn is killed
			NextC = C.NextController;

			if (C != None && C.Pawn != None && Pawn != None && C.Pawn != Pawn && C.Pawn != PlayerSpawner.Pawn && C.Pawn.Health > 0
		 	&& VSize(C.Pawn.Location - Pawn.Location) < TargetRange && FastTrace(C.Pawn.Location, Pawn.Location) && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow') && !C.Pawn.IsA('MissionBalloon') 
		 	&& (C.Pawn.Physics == PHYS_Flying) 
			   && ((TeamGame(Level.Game) != None && !C.SameTeamAs(PlayerSpawner)) 	// on a different team
				|| (TeamGame(Level.Game) == None && C.Pawn.Owner != PlayerSpawner)))		// or just not me
			{
				SeePlayer(C.Pawn);
			}
			C = NextC;
		}
	}
}

defaultproperties
{
     AttractRange=1800
     TargetRange=3000
}
