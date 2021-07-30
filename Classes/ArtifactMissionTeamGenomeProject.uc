class ArtifactMissionTeamGenomeProject extends ArtifactMission
		config(UT2004RPG);

#exec  AUDIO IMPORT NAME="MPSelect" FILE="Sounds\MPSelect.WAV" GROUP="MissionSounds"

function Activate()
{
	local Controller C;
	local NavigationPoint Dest;
	local GenomeProjectNode GPN;
	
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
		if (MMPI.GenomeProjectActive)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}
		if (MMPI != None && MMPI.stopped && !MMPI.GenomeProjectActive)
		{
			Dest = Instigator.Controller.FindRandomDest();
			GPN = Instigator.spawn(class'GenomeProjectNode',,,Dest.Location + vect(0,0,40));
			if (GPN != None)
			{
				GPN.SetTeamNum(Instigator.GetTeamNum());
				if (GPN.Controller != None)
					GPN.Controller.Destroy();
				MMPI.Stopped = False;
				MMPI.GenomeProjectActive = True;
				MMPI.MissionName = default.ItemName;
				MMPI.SetTimer(MMPI.CheckInterval, True);
				MMPI.TimeLimit = default.TimeLimit;
				MMPI.MissionXP = XPReward;
				MMPI.MissionGoal = MissionGoal;
				MMPI.GPN = GPN;
				MMPI.GenomeXPPerVial = XPReward;
				for ( C = Level.ControllerList; C != None; C = C.NextController )
					if ( C != None && C.Pawn != None && C.Pawn.Health > 0 && C.IsA('PlayerController') && C.SameTeamAs(Instigator.Controller) )
						PlayerController(C).ClientPlaySound(Sound'DEKRPG208AC.MissionSounds.MPSelect');
				SetTimer(0.5,True);
				BroadcastMission();
			}
			else
			{
				Instigator.ReceiveLocalizedMessage(MessageClass, 3000, None, None, Class);
				bActive = false;
				GotoState('');
				return;
			}
		}
		else
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

simulated function BroadcastMission()
{
	Level.Game.Broadcast(self, "Team mission started: " $ ItemName $ ". " $ Description $ " Reward: " $ XPReward $ "XP per vial.");
	Level.Game.Broadcast(self, "10 seconds to start...");
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 1000)
		return "Cannot access mission.";
	else if (Switch == 2000)
		return "A team mission or minigame is already currently active.";
	else if (Switch == 3000)
		return "Genome node could not spawn. Try again.";
}

defaultproperties
{
     XPReward=5
     TimeLimit=120
     Description="(T)Find and return vials to the node for study!"
     TeamMission=True
     PickupClass=Class'DEKRPG208AC.ArtifactMissionTeamGenomeProjectPickup'
     IconMaterial=Texture'MissionsTex6.TeamMissions.GenomeProject'
     ItemName="Genome Project"
}
