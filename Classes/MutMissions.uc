class MutMissions extends Mutator;

function ModifyPlayer(Pawn Other)
{
	local MissionInvBETA MissionInv;
	
	Super.ModifyPlayer(Other);
	
	if (Other == None || Other.Controller == None)
		return;
	

	MissionInv = class'MissionInvBETA'.static.GetMissionInv(Other.Controller);
	if (MissionInv != None)
		return;
	MissionInv = Spawn(class'MissionInvBETA', Other);
	MissionInv.Inventory = Other.Controller.Inventory;
	Other.Controller.Inventory = MissionInv;
	MissionInv.SetOwner(Other.Controller);
}

defaultproperties
{
     FriendlyName="Missions"
     Description="Enables missions."
}
