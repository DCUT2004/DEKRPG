class ArtifactMissionTeamPortalBall extends ArtifactMission
		config(UT2004RPG);
		
var config int XPPerScore;

#exec  AUDIO IMPORT NAME="MPSelect" FILE="Sounds\MPSelect.WAV" GROUP="MissionSounds"

function Activate()
{
	local NavigationPoint Dest1, Dest2;
	local Controller C;
	local MissionPortal Portal1, Portal2;
	
	if ((Instigator != None) && (Instigator.Controller != None))
	{
		if (MMPI == None)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 1000, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}
		if (!MMPI.Stopped)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}
		if (MMPI.PortalBallActive)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}
		if (MMPI.Countdown != MMPI.default.Countdown)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}
		//Spawn portals
		Dest1 = Instigator.Controller.FindRandomDest();
		Dest2 = Instigator.Controller.FindRandomDest();
		Portal1 = Instigator.Spawn(Class'MissionPortal',,, Dest1.Location);
		Portal2 = Instigator.Spawn(Class'MissionPortal',,, Dest2.Location);
		if (Portal1 != None)
			Portal1.XPPerScore = XPPerScore;
		if (Portal2 != None)
			Portal2.XPPerScore = XPPerScore;

		if (MMPI != None && MMPI.stopped && !MMPI.PortalBallActive)
		{
			MMPI.Stopped = False;
			MMPI.PortalBallActive = True;
			MMPI.MissionName = default.ItemName;
			MMPI.SetTimer(MMPI.CheckInterval, True);
			MMPI.TimeLimit = default.TimeLimit;
			MMPI.MissionXP = XPReward;
			MMPI.MissionGoal = MissionGoal;
			for ( C = Level.ControllerList; C != None; C = C.NextController )
				if ( C != None && C.Pawn != None && C.Pawn.Health > 0 && C.IsA('PlayerController') && C.SameTeamAs(Instigator.Controller) )
					PlayerController(C).ClientPlaySound(Sound'DEKRPG208AF.MissionSounds.MPSelect');
		}
		SetTimer(0.5,True);
		TeamMissionBroadcast(ItemName, Description,XPReward);
	}
	bActive = false;
	GotoState('');
	return;		
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 1000)
		return "Cannot access mission.";
	else if (Switch == 2000)
		return "A team mission or minigame is already currently active.";
	else if (Switch == 3000)
		return "Portal could not spawn. Try again.";
}

defaultproperties
{
     XPPerScore=5
     XPReward=25
     MissionGoal=15
     TimeLimit=120
     Description="(T)Shoot the ball into the portal!"
     TeamMission=True
     PickupClass=Class'DEKRPG208AF.ArtifactMissionTeamPortalBallPickup'
     IconMaterial=Texture'MissionsTex6.TeamMissions.PortalBall'
     ItemName="Portal Ball"
}
