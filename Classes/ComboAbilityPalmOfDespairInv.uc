//The combo that the player has purchased
class ComboAbilityPalmOfDespairInv extends ComboAbilityInv
	config(UT2004RPG);
	
#exec  AUDIO IMPORT NAME="ComboSoundPalmOfDespair" FILE="Sounds\ComboSoundPalmOfDespair.WAV" GROUP="ComboSounds"
	
function DoEffect()
{
	if (Owner != None && Pawn(Owner) != None)
	{
		if (Combo != None)
		{
			Combo.AddAilment(Pawn(Owner), bAll, False, bSingle, ComboLifespan, class'ComboAttackInv', EffectMultiplier, bDispellable);
			EffectEmitter = Pawn(Owner).Spawn(EffectEmitterClass, Pawn(Owner), , Pawn(Owner).Location, Pawn(Owner).Rotation);
		}
	}
}

defaultproperties
{

}
