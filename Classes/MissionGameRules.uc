class MissionGameRules extends GameRules;

const ROOTED = "Rooted Stance";
const SUPERMAN = "Superman";
const SHARP_SHOT = "Sharp Shot Fly";
var MutMissionMultiplayer TeamMissionsMut;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	TeamMissionsMut = Class'MutMissionMultiplayer'.static.GetMutMissionMultiplayer(Level.Game);
}

function int NetDamage( int OriginalDamage, int Damage, pawn injured, pawn instigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType )
{
	local MissionInvBETA MissionInv;						//Unfortunately, we're doing a check on the inventory list each time a player deals damage..
	local int x, y;
	
	if (instigatedBy == None || instigatedBy.Controller == None)
		return Super.NetDamage(OriginalDamage, Damage, injured, instigatedBy, HitLocation, Momentum, DamageType);	
	
	if (instigatedBy.PlayerReplicationInfo != None && instigatedBy.PlayerReplicationInfo.bBot)
		return Super.NetDamage(OriginalDamage, Damage, injured, instigatedBy, HitLocation, Momentum, DamageType);
		
	if (instigatedBy.IsA('Monster') && FriendlyMonsterInv(instigatedBy.FindInventoryType(Class'FriendlyMonsterInv')) == None )
		return Super.NetDamage(OriginalDamage, Damage, injured, instigatedBy, HitLocation, Momentum, DamageType);
		
	
	MissionInv = class'MissionInvBETA'.static.GetMissionInv(instigatedBy.Controller);
	if (MissionInv == None)
		return  Super.NetDamage(OriginalDamage, Damage, injured, instigatedBy, HitLocation, Momentum, DamageType);
	for (x = 0; x < MissionInv.NUM_MISSIONS; x++)
	{
		if (MissionInv.Missions[x].ObjectiveClasses.Length > 0)
		{
			for (y = 0; y < MissionInv.Missions[x].ObjectiveClasses.Length; y++)
			{
				if (DamageType == MissionInv.Missions[x].ObjectiveClasses[y])
				{
					MissionInv.TickMission(x, 1);
					return Super.NetDamage(OriginalDamage, Damage, injured, instigatedBy, HitLocation, Momentum, DamageType);					
				}
			}
		}
	}
	
	return Super.NetDamage(OriginalDamage, Damage, injured, instigatedBy, HitLocation, Momentum, DamageType);
}

function ScoreKill(Controller Killer, Controller Killed)
{
	local MissionInvBETA MissionInv;
	local int x, y;
	local Inventory FoundInventory;
	local Weapon W;
	
	Super.ScoreKill(Killer, Killed);
	
	if (Killer == None || Killer.Pawn == None || Killed == None || Killed.Pawn == None)
		return;

	if (Killer.Pawn.IsA('Monster') && FriendlyMonsterInv(Killer.Pawn.FindInventoryType(Class'FriendlyMonsterInv')) == None)
		return;
		
	//Check for Musical Weapons team mission
	if (TeamMissionsMut != None && TeamMissionsMut.MusicalWeaponsActive && !TeamMissionsMut.Stopped)
	{
		W = Killer.Pawn.Weapon;
		if (RPGWeapon(W) != None)
			W = RPGWeapon(W).ModifiedWeapon;
		if (W != None && ClassIsChildOf(W.Class, TeamMissionsMut.ActiveWeapon) )
			TeamMissionsMut.UpdateCount(1);
	}
		
	//Exclude bots past this point
	if (Killer.PlayerReplicationInfo != None && Killer.PlayerReplicationInfo.bBot)
		return;
		
	MissionInv = class'MissionInvBETA'.static.GetMissionInv(Killer);
	if (MissionInv == None)
		return;
	if (Killer.Pawn.Weapon == None)
		return;
	for(x = 0; x < MissionInv.NUM_MISSIONS; x++)
	{
		if (MissionInv.Missions[x].MissionName == ROOTED && VSize(Killer.Pawn.Velocity) ~= 0)
			MissionInv.TickMission(x, 1);
			
		if (MissionInv.Missions[x].MissionName == SUPERMAN && (Killer.Pawn.Physics == PHYS_FALLING || Killer.Pawn.Physics == PHYS_FLYING ) )
			MissionInv.TickMission(x, 1);
			
		if (MissionInv.Missions[x].ObjectiveClasses.Length > 0)
		{
			for (y = 0; y < MissionInv.Missions[x].ObjectiveClasses.Length; y++)
			{
				if (Killed.Pawn.Class == MissionInv.Missions[x].ObjectiveClasses[y] || ClassIsChildOf(Killed.Pawn.Class, MissionInv.Missions[x].ObjectiveClasses[y]))
				{
					MissionInv.TickMission(x, 1);
					return;			
				}
				if (ClassIsChildOf(MissionInv.Missions[x].ObjectiveClasses[y] , Class'Inventory'))
				{
					FoundInventory = Killed.Pawn.FindInventoryType(MissionInv.Missions[x].ObjectiveClasses[y]);
					if (FoundInventory != None)
					{
						MissionInv.TickMission(x, 1);
						return;
					}
				}
			}
		}
	}
}

defaultproperties
{
}
