//The combo that the player has purchased
class ComboAbilityWardInv extends ComboAbilityInv
	config(UT2004RPG);
	
var float AdrenEffectMultiplier;
	
function DoEffect()
{
	if (Owner != None && Pawn(Owner) != None)
	{
		if (Combo != None)
		{
			Combo.AddBuff(Pawn(Owner), bAll, False, bSingle, ComboLifespan, class'ComboWardInv', EffectMultiplier, bDispellable);
		}
		EffectxEmitter = Pawn(Owner).Spawn(EffectxEmitterClass, Pawn(Owner), , Pawn(Owner).Location, Pawn(Owner).Rotation);
	}
}

defaultproperties
{
	EffectxEmitterClass=Class'ComboAbilitySoothingMelodyEffect'
}
