class ArtifactMission extends RPGArtifact
		config(UT2004RPG);

var config int XPReward;
var config int MissionGoal;
var config int TimeLimit;
var MissionInv Inv;
var Mission1Inv M1Inv;
var Mission2Inv M2Inv;
var Mission3Inv M3Inv;
var MutMissionMultiplayer MMPI;
var localized string Description;
var config int LowLevelThreshold, MediumLevelThreshold;
var config float LowLevelMultiplier, MediumLevelMultiplier;
var config bool TeamMission;

#exec OBJ LOAD FILE=..\Sounds\AssaultSounds.uax
#exec OBJ LOAD FILE=..\Textures\MissionsTex6.utx

function BotConsider()
{
	return;
}

static function bool ArtifactIsAllowed(GameInfo Game)
{
	if (Invasion(Game) != None)
		return true;
	else
		return false;
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

//Only solo derived missions will call this
function Activate()
{
	local int PlayerLevel;

	PlayerLevel = GetRPGLevel(Instigator);
	
	if (PlayerLevel <= default.LowLevelThreshold)
	{
		if (XPReward > default.XPReward * default.LowLevelMultiplier)
			XPReward *= default.LowLevelMultiplier;
		if (MissionGoal > default.MissionGoal * default.LowLevelMultiplier)
			MissionGoal *= default.LowLevelMultiplier;
		if (MissionGoal < 1)
			MissionGoal = 1;
	}
	else if (PlayerLevel <= default.MediumLevelThreshold)
	{
		if (XPReward > default.XPReward * default.MediumLevelMultiplier)
			XPReward *= default.MediumLevelMultiplier;
		if (MissionGoal > default.MissionGoal * default.MediumLevelMultiplier)
			MissionGoal *= default.MediumLevelMultiplier;
		if (MissionGoal < 1)
			MissionGoal = 1;
	}
	if (Instigator != None)
	{
		Inv = MissionInv(Instigator.FindInventoryType(class'MissionInv'));
		M1Inv = Mission1Inv(Instigator.FindInventoryType(class'Mission1Inv'));
		M2Inv = Mission2Inv(Instigator.FindInventoryType(class'Mission2Inv'));
		M3Inv = Mission3Inv(Instigator.FindInventoryType(class'Mission3Inv'));
	}
}

function int GetRPGLevel(Pawn NewTarget)
{
	local RPGPlayerDataObject DataObj;
	local RPGStatsInv StatsInv;

	if (NewTarget == None || NewTarget.Controller == None)
		return 1;

	StatsInv = class'DruidLinkTurret'.static.GetStatsInvFor(NewTarget.Controller);
	if (StatsInv != None)
		DataObj = StatsInv.DataObject;
	if (DataObj != None)
		return DataObj.Level;

	return 1;
}

function Timer()
{
	setTimer(0, false);

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
     LowLevelThreshold=40
     MediumLevelThreshold=70
     LowLevelMultiplier=0.500000
     MediumLevelMultiplier=0.750000
     CostPerSec=1
     MinActivationTime=0.000001
     ItemName="Mission"
}
