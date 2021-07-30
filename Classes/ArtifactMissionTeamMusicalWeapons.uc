class ArtifactMissionTeamMusicalWeapons extends ArtifactMission
		config(UT2004RPG);

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
		if (MMPI.MusicalWeaponsActive)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}

		if (MMPI != None && MMPI.stopped && !MMPI.MusicalWeaponsActive)
		{
			MMPI.Stopped = False;
			MMPI.MusicalWeaponsActive = True;
			MMPI.MissionName = default.ItemName;
			MMPI.SetTimer(MMPI.CheckInterval, True);
			MMPI.TimeLimit = default.TimeLimit;
			MMPI.MissionXP = XPReward;
			MMPI.MissionGoal = MissionGoal;
			MMPI.ActiveWeapon = MMPI.MusicalWeaponsList[Rand(MMPI.MusicalWeaponsList.Length)];
			for ( C = Level.ControllerList; C != None; C = C.NextController )
				if ( C != None && C.Pawn != None && C.Pawn.Health > 0 && C.IsA('PlayerController') && C.SameTeamAs(Instigator.Controller) )
					PlayerController(C).ClientPlaySound(Sound'DEKRPG208AC.MissionSounds.MPSelect');
			SetTimer(0.5,True);
			TeamMissionBroadcast(ItemName, Description,XPReward);
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
     XPReward=50
     MissionGoal=20
     TimeLimit=120
     Description="(T)Make kills with the correct weapon."
     TeamMission=True
     PickupClass=Class'DEKRPG208AC.ArtifactMissionTeamMusicalWeaponsPickup'
     IconMaterial=Texture'MissionsTex6.TeamMissions.MusicalWeapons'
     ItemName="Musical Weapons"
}
