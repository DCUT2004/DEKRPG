class AbilityConstructionHealthBonus extends EngineerAbility
	config(UT2004RPG)
	abstract;

var config float HealthBonus;

static simulated function ModifyConstruction(Pawn Other, int AbilityLevel)
{
	Other.HealthMax += Other.HealthMax * (Default.HealthBonus * AbilityLevel);
	Other.Health += Other.Health * (Default.HealthBonus * AbilityLevel);
	Other.SuperHealthMax += Other.SuperHealthMax * (Default.HealthBonus * AbilityLevel);
}

static function int GetLevelConstructionHealthBonus(Pawn Other)
{
	local RPGStatsInv StatsInv;
    local int x;
    
	StatsInv = RPGStatsInv(Other.FindInventoryType(Class'RPGStatsInv'));
    if (StatsInv == None)
        return 0;

	for (x = 0; StatsInv != None && x < StatsInv.Data.Abilities.length; x++)
	{
		if (StatsInv.Data.Abilities[x] == Class'AbilityConstructionHealthBonus')
		{
			return StatsInv.Data.AbilityLevels[x];
			break;
		}
	}
    
    return 0;
}

defaultproperties
{
     HealthBonus=0.200000
     AbilityName="Constructions: Health Bonus"
     Description="Gives an additional health bonus to your summoned constructions. Each level adds 20% health to your construction's max health.|Cost (per level): 2,4,6,8,10,12,14,16,18,20"
     StartingCost=2
     CostAddPerLevel=2
     MaxLevel=20
}
