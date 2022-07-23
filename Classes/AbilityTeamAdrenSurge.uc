class AbilityTeamAdrenSurge extends CostRPGAbility
	abstract
	config(UT2004RPG);
	
var config float PercentPerLevel;

static function ScoreKill(Controller Killer, Controller Killed, bool bOwnedByKiller, int AbilityLevel)
{
	if (!bOwnedByKiller)
		return;

	if (Killed.Pawn != None && Killed.Pawn.IsA('Monster'))
	{
		class'MutTeamAdrenaline'.static.AddPlayerTeamAdren( float(Killed.Pawn.GetPropertyText("ScoringValue")) * default.PercentPerLevel * AbilityLevel);
	}
}

defaultproperties
{
	 PercentPerLevel=0.04000
     MinAdrenalineMax=150
     MinDB=50
     AbilityName="Team Adrenal Surge"
     Description="For each level of this ability, you gain 4% more team adrenaline from kills. You must have a Damage Bonus of at least 50 and an Adrenaline Max stat at least 150 to purchase this ability. |Cost (per level): 2,4,6,8,10,12..."
     StartingCost=2
     CostAddPerLevel=2
     MaxLevel=25
}
