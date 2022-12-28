/*
* Positive Modifier = % chance to deal double damage
* Negative Modifier = % chance to have damage reduced to 1
*/

class StatusEffect_ChanceHit extends StatusEffectData
	config(UT2004RPG);

defaultproperties
{
	StatusEffectName="ChncHt"
	FriendlyName="Critical Hit"
	MaxModifier=7
}
