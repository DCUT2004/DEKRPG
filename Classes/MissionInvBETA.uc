//Newer version of the current mission system. Once finished, this should replace MissionInv and MissionSoloInv
//This inventory item should be spawned and placed in the player's controller list of inventory items
//We do not want this object getting destroyed on player death, that way stats like missions completed and rewards are saved

class MissionInvBETA extends Inventory;

const NUM_MISSIONS = 3;

struct Mission											//Struct representation of a mission
{
	var localized string MissionName;
	var int MissionCount;
	var int MissionGoal;
	var float XPReward;
	var Array < Class < Actor > > ObjectiveClasses;		//What objectives this mission requires (e.g. monsters for hunt missions, damage types for weapon missions)
};
var Mission Missions[NUM_MISSIONS];						//Array containing Mission structs, representing the player's currently active missions
var int NumMissionsCompleted;							//Number of missions this player has completed
var Array < string > CompletedMissions;					//Array of missions that have been completed
var RPGRules Rules;
var transient DruidsRPGKeysInteraction InteractionOwner;

#exec  AUDIO IMPORT NAME="MissionComplete1" FILE="Sounds\MissionComplete1.WAV" GROUP="MissionSounds"

replication												//Replicate to clients so HUD can be displayed
{
	reliable if (Role == ROLE_Authority)
		NumMissionsCompleted, Missions;
}

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
		if(G.isA('RPGRules'))
		{
			Rules = RPGRules(G);
			break;
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

final function bool IsAllMissionsActive()
{
	local int x, Count;
	
	Count = 0;
	
	for (x = 0; x < NUM_MISSIONS; x++)
		if (Missions[x].MissionName != "")
			Count++;
	return Count == NUM_MISSIONS;
}

final function bool IsMissionActive(string MissionName)
{
	local int x;
	
	for (x = 0; x < NUM_MISSIONS; x++)
		if (MissionName == Missions[x].MissionName)
			return true;
	return false;
}

final function int GetMissionIndex(string MissionName)
{
	local int x;
	
	for (x = 0; x < NUM_MISSIONS; x++)
		if (MissionName == Missions[x].MissionName)
			return x;
	return -1;
}

final function bool IsMissionCompleted(string MissionName)
{
	local int x;
	
	for (x = 0; x < CompletedMissions.Length; x++)
		if (MissionName == CompletedMissions[x])
			return true;
	return false;
}

function ResetAllMissions()
{
	local int x;
	
	for (x = 0; x < NUM_MISSIONS; x++)
		ResetMission(x);
}

function ResetMission(int MissionNumber)
{
	if (MissionNumber < 0 || MissionNumber >= NUM_MISSIONS)
		return;
	Missions[MissionNumber].MissionName = "";
	Missions[MissionNumber].MissionCount = 0;
	Missions[MissionNumber].MissionGoal = 0;
	Missions[MissionNumber].XPReward = 0.0;
	if (Missions[MissionNumber].ObjectiveClasses.Length > 0)
		Missions[MissionNumber].ObjectiveClasses.Length = 0;		//Clears the array
}

//Called when activating a mission artifact, which will supply the required parameters
function bool SetMission(string MissionName, int MissionGoal, float XPReward, Array < Class < Actor > > ObjectiveClasses)
{
	local int x, y;
	
	for (x = 0; x < NUM_MISSIONS; x++)				//Find next available slot to set mission
	{
		if (Missions[x].MissionName == "")
		{
			Missions[x].MissionName = MissionName;
			Missions[x].MissionGoal = MissionGoal;
			Missions[x].XPReward = XPReward;
			Missions[x].ObjectiveClasses.Length = ObjectiveClasses.Length;	//Inserts elements into the array, initialized with null values
			for (y = 0; y < Missions[x].ObjectiveClasses.Length; y++)
				Missions[x].ObjectiveClasses[y] = ObjectiveClasses[y];		//y is used to index both arrays, but there should never be an out of bounds exception
			return true;
		}
	}
	return false;
}

//Called by any number of events, such as dealing damage or upon kill
//Increments the mission count and checks if goal is met
function TickMission(int MissionNumber, int TickAmount)
{
	if (MissionNumber < 0 || MissionNumber >= NUM_MISSIONS)
		return;
	Missions[MissionNumber].MissionCount += TickAmount;
	if (Missions[MissionNumber].MissionCount < 0)		//In the event TickAmount is negative
		Missions[MissionNumber].MissionCount = 0;
	if (Missions[MissionNumber].MissionCount >= Missions[MissionNumber].MissionGoal)
		CompleteMission(MissionNumber);
}

function SetTick(int MissionNumber, int TickAmount)
{
	if (MissionNumber < 0 || MissionNumber >= NUM_MISSIONS)
		return;
	Missions[MissionNumber].MissionCount = TickAmount;
	if (Missions[MissionNumber].MissionCount >= Missions[MissionNumber].MissionGoal)
		CompleteMission(MissionNumber);
}

function CompleteMission(int MissionNumber)
{
	local Pawn PawnOwner;
	
	if (Owner != None && Controller(Owner) != None)
		PawnOwner = Controller(Owner).Pawn;
	RewardXP(Missions[MissionNumber].XPReward);
	CompletedMissions.Insert(0, 1);
	CompletedMissions[0] = Missions[MissionNumber].MissionName;
	NumMissionsCompleted = CompletedMissions.Length;
	if (PawnOwner != None)
	{
		Level.Game.Broadcast(self, PawnOwner.PlayerReplicationInfo.PlayerName $ " achieved " $ Missions[MissionNumber].MissionName $ "!");
		PawnOwner.PlaySound(Sound'DEKRPG999X.MissionSounds.MissionComplete1', SLOT_None, 400.0);
	}
	ResetMission(MissionNumber);
}

function RewardXP(float XPReward)
{
	local Pawn PawnOwner;
	
	if (Owner != None && Controller(Owner) != None)
		PawnOwner = Controller(Owner).Pawn;
		
	if (Rules != None && PawnOwner != None)
		Rules.ShareExperience(RPGStatsInv(PawnOwner.FindInventoryType(class'RPGStatsInv')), XPReward);
}

static function ExitMission(Pawn PawnOwner, int MissionNumber)
{
	local MissionInvBETA MissionInv;

	if (PawnOwner == None || PawnOwner.Controller == None || MissionNumber < 0 || MissionNumber >= NUM_MISSIONS)
		return;

	MissionInv = class'MissionInvBETA'.static.GetMissionInv(PawnOwner.Controller);
	if (MissionInv != None)
		MissionInv.ResetMission(MissionNumber);
}

simulated function Destroyed()
{
 	if (InteractionOwner != None)
 	{
 		InteractionOwner.MissionInv = None;
 		InteractionOwner = None;
 	}
	Super.Destroyed();
}

defaultproperties
{
}
