class ClassClassicRPG extends RPGClass
	config(UT2004RPG)
	abstract;

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	class'ClassWeaponsMaster'.static.ModifyPawn(Other, AbilityLevel);
	
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
			class'DruidVampireSurge'.static.ScoreKill(Killer, Killed, True, 3);
		}
		else if (StatsInv != None && StatsInv.DataObject.Level <= default.LowLevel)
		{
			class'AbilityLuckyStrike'.static.ScoreKill(Killer, Killed, True, 5);
			class'DruidVampireSurge'.static.ScoreKill(Killer, Killed, True, 5);
		}
	}
	Super(RPGClass).ScoreKill(Killer,Killed,bOwnedByKiller,AbilityLevel);
}

defaultproperties
{
     AbilityName="Class: Classic RPG"
     Description="Classic-styled, vanilla RPG with higher levels of core stats including weapon speed, health bonus, damage bonus, and damage reduction. This class is ideal for players who like a challenging run-and-gun play.||You can not be more than one class at any time. You must purchase a class first before purchasing any ability or stats."
     BotChance=11
}
