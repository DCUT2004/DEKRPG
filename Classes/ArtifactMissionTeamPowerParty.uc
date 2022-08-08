class ArtifactMissionTeamPowerParty extends ArtifactMissionTeam
		config(Missions);
		
var config int TitanWave1;
var config int TitanWave2;
var config int XPRewardTitanWave;
var config int MissionGoalTitanWave;
var config int TimeLimitTitanWave;

#exec  AUDIO IMPORT NAME="MPSelect" FILE="Sounds\MPSelect.WAV" GROUP="MissionSounds"

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
		if (!MMPI.Stopped)
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
		if (MMPI.PowerPartyActive)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}

		if (MMPI != None && MMPI.stopped && !MMPI.PowerPartyActive)
		{
			MMPI.Stopped = False;
			MMPI.PowerPartyActive = True;
			MMPI.MissionName = default.ItemName;
			MMPI.SetTimer(MMPI.CheckInterval, True);
			MMPI.TimeLimit = default.TimeLimit;
			MMPI.MissionXP = XPReward;
			MMPI.MissionGoal = MissionGoal;
			for ( C = Level.ControllerList; C != None; C = C.NextController )
				if ( C != None && C.Pawn != None && C.Pawn.Health > 0 && C.IsA('PlayerController') && C.SameTeamAs(Instigator.Controller) )
					PlayerController(C).ClientPlaySound(Sound'DEKRPG999X.MissionSounds.MPSelect');
			SetTimer(0.5,True);
			TeamMissionBroadcast(ItemName, Description,XPReward);
		}
		else if (MMPI.PowerPartyActive)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}
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
     TitanWave1=5
     TitanWave2=13
     XPRewardTitanWave=20
     MissionGoalTitanWave=10000
     TimeLimitTitanWave=120
     XPReward=50
     MissionGoal=5000
     TimeLimit=60
     Description="Do as much damage as a team."
     PickupClass=Class'DEKRPG999X.ArtifactMissionTeamPowerPartyPickup'
     IconMaterial=Texture'MissionsTex6.TeamMissions.PowerParty'
     ItemName="Team Mission: Power Party"
}
