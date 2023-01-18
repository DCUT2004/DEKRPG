class AbilityRageEWM extends AbilityNiche
	config(UT2004RPG) 
	abstract;
	
var config float MaxDamageIncrease;
var config float HurtDamageMultiplier;
var config float DamageAdjustmentFactor;

static function GiveVampire(int VampHealth, Controller Killer)
{
	local Pawn P;

	if (Killer == None || Killer.Pawn == None)
	    return;
	P = Killer.Pawn;
	    
	if (Vehicle(P) != None)
	{
		P = Vehicle(P).Driver;
		if (P == None)
		{
			return;
		}
	}

	P.GiveHealth(VampHealth, P.HealthMax + Class'DruidVampire'.default.AdjustableHealingDamage);
}

static function ScoreKill(Controller Killer, Controller Killed, bool bOwnedByKiller, int AbilityLevel)
{
    local int HealthToGive;
	if (!bOwnedByKiller)
		return;

	if ( Killed == Killer || Killed == None || Killer == None || Killed.Level == None || Killed.Level.Game == None)
		return;

	if (Killed.Pawn != None && Killed.Pawn.IsA('Monster'))
	{
        HealthToGive = int(Killed.Pawn.GetPropertyText("ScoringValue")) * AbilityLevel;
		GiveVampire(HealthToGive, Killer);
        // Log("+++ RageEWM giving vampire health" @ HealthToGive @ "AbilityLevel" @ AbilityLevel @ "monster@" @ Killed.Pawn.Class);
		return;
	}

	if (Killed.Level.Game.bTeamGame)
	{
		if ( (Killer.PlayerReplicationInfo == None) || (Killed.PlayerReplicationInfo == None) || (Killer.PlayerReplicationInfo.Team == Killed.PlayerReplicationInfo.Team))
			return;	//no bonus for team kills
	}

	if (Killer.bIsPlayer && Killed.bIsPlayer)
    {
		GiveVampire(Deathmatch(Killed.Level.Game).ADR_Kill * AbilityLevel, Killer);
    }
}

	
static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	local float DamageToMultiply;

	if (!bOwnedByInstigator)
    {
		if (Damage > 0)
        {
            DamageToMultiply = (AbilityLevel * default.HurtDamageMultiplier);
			Damage *= (1 + DamageToMultiply);
            // Log("+++ RageEWM Hurt Damage increased by" @ DamageToMultiply @ "for ability level" @ AbilityLevel);
        }
	}
    else
    {
    	if (Damage > 0)
    	{
    		DamageToMultiply = ((AbilityLevel * default.DamageAdjustmentFactor)/ Instigator.Health)  +1;
    		if (DamageToMultiply > default.MaxDamageIncrease)
    			DamageToMultiply = default.MaxDamageIncrease;
    		Damage *= DamageToMultiply;
            // Log("+++ RageEWM Damage increased by" @ DamageToMultiply @ "for ability level" @ AbilityLevel @ "with Health" @ Instigator.Health);
    	}
    }
}

defaultproperties
{
     MaxDamageIncrease=1.750000
     HurtDamageMultiplier=0.050000
     DamageAdjustmentFactor=6.00000
     ExcludingAbilities(0)=Class'DEKRPG999X.AbilityPrimalEWM'
     AbilityName="Niche: Vengeance"
     Description="Each level of this ability increases your cumulative damage bonus as your health decreases. You gain health from kills, but the damage you take increases by 3% per level.|You must be level 180 to buy a niche. You can not be in more than one niche at a time. Cost (per level): 10."
     StartingCost=10
     MaxLevel=20
}
