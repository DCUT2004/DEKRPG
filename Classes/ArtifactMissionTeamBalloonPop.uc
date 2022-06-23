class ArtifactMissionTeamBalloonPop extends ArtifactMission
		config(UT2004RPG);

#exec  AUDIO IMPORT NAME="MPSelect" FILE="Sounds\MPSelect.WAV" GROUP="MissionSounds"

function PostBeginPlay()
{
	TeamMission = True;
	Super.PostBeginPlay();
}

function Activate()
{
	local Controller C;
	
	if ((Instigator != None) && (Instigator.Controller != None))
	{
		if (MMPI == None)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 1000, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}
		if (!MMPI.Stopped || MMPI.Countdown != MMPI.default.Countdown || MMPI.BalloonPopActive)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}
		if (Invasion(Level.Game) == None)
		{
			Destroy();
			bActive = false;
			GotoState('');
			return;		
		}
		
		if (MMPI != None && MMPI.stopped && !MMPI.BalloonPopActive)
		{
			MMPI.Stopped = False;
			MMPI.BalloonPopActive = True;
			MMPI.MissionName = default.ItemName;
			MMPI.SetTimer(MMPI.CheckInterval, True);
			MMPI.TimeLimit = default.TimeLimit;
			MMPI.MissionXP = XPReward;
			MMPI.MissionGoal = MissionGoal;
			for ( C = Level.ControllerList; C != None; C = C.NextController )
				if ( C != None && C.Pawn != None && C.Pawn.Health > 0 && C.IsA('PlayerController') && C.SameTeamAs(Instigator.Controller) )
					PlayerController(C).ClientPlaySound(Sound'DEKRPG209C.MissionSounds.MPSelect');
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
}

defaultproperties
{
     XPReward=25
     MissionGoal=40
     TimeLimit=80
     Description="(T)Pop the balloons!"
     TeamMission=True
     PickupClass=Class'DEKRPG209C.ArtifactMissionTeamBalloonPopPickup'
     IconMaterial=Texture'MissionsTex6.TeamMissions.BalloonPop'
     ItemName="Balloon Pop"
}
