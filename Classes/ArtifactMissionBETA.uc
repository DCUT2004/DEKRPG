//Newer version of ArtifactMission. Once finished, this should replace ArtifactMission


class ArtifactMissionBETA extends RPGArtifact
	config(Missions);

var config int LowLevelThreshold, MediumLevelThreshold;
var config float LowLevelMultiplier, MediumLevelMultiplier;
var localized string Description;
var config float XPReward;
var config int MissionGoal;
var config Array < Class < Actor > > ObjectiveClasses;

function BotConsider()
{
	return;
}

function Activate()
{
	local MissionInvBETA MissionInv;
	
	if (Instigator == None || Instigator.Controller == None)
		return;
		
	MissionInv = class'MissionInvBETA'.static.GetMissionInv(Instigator.Controller);
	
	if (MissionInv == None)
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 1, None, None, Class);
		bActive = false;
		GotoState('');
		return;	
	}
	
	//Check if all missions slots are alaready active
	if (MissionInv.IsAllMissionsActive())
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 2, None, None, Class);
		bActive = false;
		GotoState('');
		return;				
	}
	
	//Check if this mission is already active
	if (MissionInv.IsMissionActive(ItemName))
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 4, None, None, Class);
		bActive = false;
		GotoState('');
		return;			
	}
	
	//Check if this mission was already completed
	if (MissionInv.IsMissionCompleted(ItemName))
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 6, None, None, Class);
		bActive = false;
		GotoState('');
		return;		
	}
	
	AdjustRewardAndGoalValues(GetRPGLevel(Instigator));
	
	if (!MissionInv.SetMission(ItemName, MissionGoal, XPReward, ObjectiveClasses))
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 1, None, None, Class);
		bActive = false;
		GotoState('');
		return;
	}
	
	Instigator.ReceiveLocalizedMessage(MessageClass, 7, None, None, Class);
	if (PlayerController(Instigator.Controller) != None)
		PlayerController(Instigator.Controller).ClientPlaySound(Sound'AssaultSounds.HumanShip.HnShipFireReadyl01');
	SetTimer(0.2,True);
}

function AdjustRewardAndGoalValues(int PlayerLevel)
{
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

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	Switch(Switch)
	{
		Case 1: return "Could not start mission. Try again.";
		Case 2: return "You currently have too many active missions.";
		Case 3: return "Mission activated!";
		Case 4: return "Mission is already active.";
		Case 5: return "Mission forfeited.";
		Case 6: return "Mission already completed.";
		Case 7: return default.Description;
		Default: return "";
	}
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
