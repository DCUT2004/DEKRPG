class MissionGameRules extends GameRules;

function int NetDamage( int OriginalDamage, int Damage, pawn injured, pawn instigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType )
{
	local MissionInvBETA MissionInv;						//Unfortunately, we're doing a check on the inventory list each time a player deals damage..
	local int x;
	
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
		if (MissionInv.Missions[x].ObjectiveClass != None && MissionInv.Missions[x].ObjectiveClass == DamageType)
		{
			MissionInv.TickMission(x);
			return Super.NetDamage(OriginalDamage, Damage, injured, instigatedBy, HitLocation, Momentum, DamageType);
		}
	}
	
	return Super.NetDamage(OriginalDamage, Damage, injured, instigatedBy, HitLocation, Momentum, DamageType);
}

function ScoreKill(Controller Killer, Controller Killed)
{
	local MissionInvBETA MissionInv;
	local int x;
	
	Super.ScoreKill(Killer, Killed);
	
	if (Killer == None || Killer.Pawn == None || Killed == None || Killed.Pawn == None)
		return;

	if (Killer.PlayerReplicationInfo != None && Killer.PlayerReplicationInfo.bBot)
		return;

	if (Killer.Pawn.IsA('Monster') && FriendlyMonsterInv(Killer.Pawn.FindInventoryType(Class'FriendlyMonsterInv')) == None)
		return;
		
	MissionInv = class'MissionInvBETA'.static.GetMissionInv(Killer);
	if (MissionInv == None)
		return;
	if (Killer.Pawn.Weapon == None)
		return;
	for(x = 0; x < MissionInv.NUM_MISSIONS; x++)
	{
		if (MissionInv.Missions[x].ObjectiveClass != None && MissionInv.Missions[x].ObjectiveClass == Killed.Pawn.Class)
		{
			MissionInv.TickMission(x);
			return;
		}
	}
}

defaultproperties
{
}
