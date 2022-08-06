//TimedMissionInv is an inventory item that manages timed missions for the player, such as Halt, Hexed, Featherweight, and others that depend on a certain amount of time passing

class TimedMissionInv extends Inventory;

var MissionInvBETA MissionInv;
var string MissionName;
var int Goal;
var int TimerCount;
var int MissionIndex;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	Super.GiveTo(Other);
	if (Other != None && Other.Controller != None)
		MissionInv = class'MissionInvBETA'.static.GetMissionInv(Other.Controller);
	if (MissionInv != None)
		MissionIndex = MissionInv.GetMissionIndex(MissionName);
	TimerCount = 0;
	SetTimer(1, True);
}

function Timer()
{
	if (!CheckMissionCondition())
	{
		TimerCount = 0;
		MissionInv.SetTick(MissionIndex, 0);
	}
	else
	{
		TimerCount++;
		MissionInv.TickMission(MissionIndex, 1);
	}
	if (TimerCount >= Goal)
		Destroy();
}

//This function should be derived in children classes
//Return true if the conditions to maintain the timer for this mission is met
function bool CheckMissionCondition();

defaultproperties
{
}
