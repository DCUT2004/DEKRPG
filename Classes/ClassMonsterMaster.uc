class ClassMonsterMaster extends RPGClass
	config(UT2004RPG)
	abstract;

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	class'ClassWeaponsMaster'.static.AddLowLevelRegen(Other, 2);
	
	Super(RPGClass).ModifyPawn(Other, AbilityLevel);
}

static function ScoreKill(Controller Killer, Controller Killed, bool bOwnedByKiller, int AbilityLevel)
{
	local RPGStatsInv StatsInv;
	
	if (Killer != None && Killer.Pawn != None && Killer.Pawn.Health > 0)
	{
		StatsInv = RPGStatsInv(Killer.Pawn.FindInventoryType(class'RPGStatsInv'));
		if (StatsInv != None && StatsInv.DataObject.Level <= default.MediumLevel)
		{
			class'AbilityLuckyStrike'.static.ScoreKill(Killer, Killed, True, 5);
		}
	}
	Super(RPGClass).ScoreKill(Killer,Killed,bOwnedByKiller,AbilityLevel);
}

defaultproperties
{
     AbilityName="Class: Monster/Medic Master"
     Description="Medic/Monster Masters receive extra damage reduction and an infinite healing weapon, for which players earn XP for healing others. Players can also summon a variety of friendly monsters to help fight in battle. This class is ideal for players who like a roaming support role.||At level 90, Medic/Monster Masters can branch off into various subclasses such as Healer, Summoner, and Necromancer.||You can not be more than one class at any time. You must purchase a class first before purchasing any ability or stats."
}
