/*
* Positive Modifier = faster speed
* Negative Modifier = slower speed (i.e. Freezing effect)
*/

class StatusEffect_Speed extends StatusEffectData
	config(UT2004RPG);

defaultproperties
{
	StatusEffectName="Spd"
	FriendlyName="Speed"
	MaxModifier=5
	StatusLifespan=5
	bDispellable=True
	bStackable=False
}
