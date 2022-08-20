/*
* Positive Modifier = % chance to deal double damage
* Negative Modifier = % chance to have damage reduced to 1
*/

class StatusEffect_ChanceHit extends StatusEffect
	config(UT2004RPG);

defaultproperties
{
	StatusEffectName="Critical Chance"
	MaxModifier=7
}
