class AbilityBloodLustEWM extends AbilityNiche
	config(UT2004RPG) 
	abstract;
	
var config float DamageMultiplier;

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
	if (!bOwnedByKiller)
		return;

	if ( Killed == Killer || Killed == None || Killer == None || Killed.Level == None || Killed.Level.Game == None)
		return;

	if (Killed.Pawn != None && Killed.Pawn.IsA('Monster'))
	{
		GiveVampire(int(Killed.Pawn.GetPropertyText("ScoringValue")) * AbilityLevel, Killer);
		return;
	}


	if (Killed.Level.Game.bTeamGame)
	{
		if ( (Killer.PlayerReplicationInfo == None) || (Killed.PlayerReplicationInfo == None) || (Killer.PlayerReplicationInfo.Team == Killed.PlayerReplicationInfo.Team))
			return;	//no bonus for team kills
	}

	if (Killer.bIsPlayer && Killed.bIsPlayer)
		GiveVampire(Deathmatch(Killed.Level.Game).ADR_Kill * AbilityLevel, Killer);
}

	
static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{	
	if (bOwnedByInstigator)
		return;
	if (!bOwnedByInstigator)
	{
		if (Damage > 0)
			Damage *= 1 + (default.DamageMultiplier);
	}
}

defaultproperties
{
     DamageMultiplier=0.250000
     ExcludingAbilities(0)=Class'DEKRPG209C.AbilityPrimalEWM'
     ExcludingAbilities(1)=Class'DEKRPG209C.AbilityRageEWM'
     AbilityName="Niche: Bloodlust"
     Description="For each level of this ability, you gain health from all kills. Your damage reduction is reduced by 25%.|You must have at least 50 Damage Bonus to purchase this niche. You must be level 180 to buy a niche. You can not be in more than one niche at a time.|Cost (per level): 10"
     StartingCost=10
	 MaxLevel=10
}
