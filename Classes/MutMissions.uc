class MutMissions extends Mutator;

simulated function PostBeginPlay()
{
	local MissionGameRules G;

	G = Spawn(class'MissionGameRules');
	if ( Level.Game.GameRulesModifiers == None )
		Level.Game.GameRulesModifiers = G;
	else    
		Level.Game.GameRulesModifiers.AddGameRules(G);
	Super.PostBeginPlay();
}

function ModifyPlayer(Pawn Other)
{
	local MissionInvBETA MissionInv;
	
	Super.ModifyPlayer(Other);
	
	if (Other == None || Other.Controller == None)
		return;
	

	MissionInv = class'MissionInvBETA'.static.GetMissionInv(Other.Controller);
	if (MissionInv != None)
	{
		if (DEKPawn(Other) != None )
			DEKPawn(Other).MissionInv = MissionInv;
		return;
	}
	MissionInv = Spawn(class'MissionInvBETA', Other);
	MissionInv.Inventory = Other.Controller.Inventory;
	Other.Controller.Inventory = MissionInv;
	MissionInv.SetOwner(Other.Controller);
	if (DEKPawn(Other) != None)
		DEKPawn(Other).MissionInv = MissionInv;
 }

defaultproperties
{
     FriendlyName="Missions"
     Description="Enables missions."
}
