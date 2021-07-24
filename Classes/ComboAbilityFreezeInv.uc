//The combo that the player has purchased
class ComboAbilityFreezeInv extends ComboAbilityInv
	config(UT2004RPG);
	
#exec  AUDIO IMPORT NAME="ComboSoundFreeze" FILE="Sounds\ComboSoundFreeze.WAV" GROUP="ComboSounds"
	
function DoEffect()
{
	if (Owner != None && Pawn(Owner) != None)
	{
		if (Combo != None)
		{
			Combo.AddAilment(Pawn(Owner), bAll, False, bSingle, ComboLifespan, class'ComboFreezeInv', EffectMultiplier, bDispellable);
			Combo.ComboDamage(ComboDamage, bAll, False, bSingle, ComboDamageType, , False);
		}
		EffectxEmitter = Pawn(Owner).Spawn(EffectxEmitterClass, Pawn(Owner), , Pawn(Owner).Location, Pawn(Owner).Rotation);
	}
}

defaultproperties
{
	EffectxEmitterClass=Class'ComboAbilityFreezeFX'
}
