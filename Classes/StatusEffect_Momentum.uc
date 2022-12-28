/*
* Positive Modifier = Sturdy
* Negative Modifier = Knockback
*/

class StatusEffect_Momentum extends StatusEffectData
	config(UT2004RPG);

defaultproperties
{
	StatusEffectName="Mmntm"
	FriendlyName="Momentum"
	StatusLifespan=5
	bDispellable=True
	bStackable=False
	MaxModifier=6
}
