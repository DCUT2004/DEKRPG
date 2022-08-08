//Newer version of ArtifactMission. Once finished, this should replace ArtifactMission


class ArtifactMissionTeam extends RPGArtifact
	config(Missions);

var MutMissionMultiplayer MMPI;
var config int XPReward;
var config int MissionGoal;
var config int TimeLimit;
var localized string Description;

function BotConsider()
{
	return;
}

simulated function PostBeginPlay()
{
	local Mutator m;

	if (Level.Game != None)
		for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
			if (MutMissionMultiplayer(m) != None)
			{
				MMPI = MutMissionMultiplayer(m);
				break;
			}
	Super.PostBeginPlay();
}

function Timer()
{
	SetTimer(0, false);
	Destroy();
	Instigator.NextItem();
}

simulated function TeamMissionBroadcast(string ItemName, string Description, int XPReward)
{
	Level.Game.Broadcast(self, "Team mission started: " $ ItemName $ ". " $ Description $ " Reward: " $ XPReward $ "XP.");
	Level.Game.Broadcast(self, "10 seconds to start...");
}


defaultproperties
{
	CostPerSec=1
	MinActivationTime=0.000001
}
