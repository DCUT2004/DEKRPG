class AbilityComboOffense extends AbilityCombo
	config(UT2004RPG)
	abstract;

var config int NumTargets;
var config int NumHits;
var config int DamagePerHit;
var config int TimeBetweenHits;

defaultproperties
{
	StartingCost=3
	CostAddPerLevel=3
	MaxLevel=20
	ComboType=2
}
