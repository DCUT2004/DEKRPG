//Newer version of the current mission system. Once finished, this should replace MissionInv and MissionSoloInv
//This inventory item should be spawned and placed in the player's controller list of inventory items
//We do not want this object getting destroyed on player death, that way stats like missions completed and rewards are saved

class MissionInvBETA extends Inventory;

const NUM_MISSIONS = 3;
struct Mission							//Struct representation of a mission
{
	var localized string MissionName;
	var int MissionCount;
	var int MissionGoal;
	var float XPReward;
};
var Mission Missions[NUM_MISSIONS];		//Array containing Mission structs, representing the player's currently active missions
var int MissionsCompleted;				//Number of missions this player has completed
var RPGRules Rules;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	CheckRPGRules();
}

function CheckRPGRules()
{
	Local GameRules G;

	if (Level.Game == None)
		return;		//try again later

	for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
	{
		if(G.isA('RPGRules'))
		{
			Rules = RPGRules(G);
			break;
		}
	}

	if(Rules == None)
		Log("WARNING: Unable to find RPGRules in GameRules. EXP will not be properly awarded");
}

static final function MissionInvBETA GetMissionInv(Controller C)
{
	local Inventory Inv;
	local MissionInvBeta FoundMissionInv;

	if (C == None)
		return None;
		
	for (Inv = C.Inventory; Inv != None; Inv = Inv.Inventory)
	{
		FoundMissionInv = MissionInvBeta(Inv);
		if (FoundMissionInv != None)
			return FoundMissionInv;
		
			if (Inv.Inventory == Inv)
			{
				Inv.Inventory = None;
				return None;
			}
	}

	return None;
}

function ResetAllMissions()
{
	local int x;
	
	for (x = 0; x < NUM_MISSIONS; x++)
	{
		ResetMission(x);
	}
}

function ResetMission(int MissionNumber)
{
	if (MissionNumber < 0 || MissionNumber >= NUM_MISSIONS)
		return;
	Missions[MissionNumber].MissionName = "";
	Missions[MissionNumber].MissionCount = 0;
	Missions[MissionNumber].MissionGoal = 0;
	Missions[MissionNumber].XPReward = 0.0;
}

function bool SetMission(string MissionName, int MissionGoal, float XPReward)
{
	local int x;
	
	for (x = 0; x < NUM_MISSIONS; x++)				//Find next available slot to set mission
	{
		if (Missions[x].MissionGoal == 0)
		{
			Missions[x].MissionName = MissionName;
			Missions[x].MissionGoal = MissionGoal;
			Missions[x].XPReward = XPReward;
			return true;
		}
	}
	return false;
}

function TickMission(int MissionNumber, int Amount)
{
	if (MissionNumber < 0 || MissionNumber >= NUM_MISSIONS)
		return;
	Missions[MissionNumber].MissionCount += Amount;
	if (Missions[MissionNumber].MissionCount >= Missions[MissionNumber].MissionGoal)
	{
		RewardXP(Missions[MissionNumber].XPReward);
		ResetMission(MissionNumber);
	}
}

function RewardXP(float XPReward)
{
	if (Rules != None && Instigator != None)
		Rules.ShareExperience(RPGStatsInv(Instigator.FindInventoryType(class'RPGStatsInv')), XPReward);
}

defaultproperties
{
}
