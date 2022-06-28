class AbilityMaterialNaliFruit extends AbilityMaterial
	config(UT2004RPG)
	abstract;
	
var config int MaxHealthForLetter, MaxAdrenForLetter;
var config int LetterSChance, ScoringValueForS;
var config float ChancePerLevel;

static function ScoreKill(Controller Killer, Controller Killed, bool bOwnedByKiller, int AbilityLevel)
{
	if (!bOwnedByKiller)
		return;

	if ( Killed == Killer || Killed == None || Killer == None || Killed.Level == None || Killed.Level.Game == None)
		return;
		
	class'DEKRPG209E.AbilityLuckyStrike'.static.LuckyStrike(Killer, Killed, bOwnedByKiller, AbilityLevel, default.ChancePerLevel);
}

defaultproperties
{
	 ChancePerLevel=0.100000
     AbilityName="Nali Fruit*"
     Description="Fruit grown on Na Pali and a favorite of the Nali. It is known to have healing effects. Increases your Lucky Strike chance by 1% every 10 levels.||Rarity: Low*||This material can be found by making kills, completing solo and team missions, using Loot magic modifier, winning the game, or defeating bosses.||You must be level 90 to purchase this.||Cost (per level): 3"
	 MaxLevel=50
}
