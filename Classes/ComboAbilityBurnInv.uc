//The combo that the player has purchased
class ComboAbilityBurnInv extends ComboAbilityInv
	config(UT2004RPG);
	
function DoEffect()
{
	if (Owner != None && Pawn(Owner) != None)
	{
		if (Combo != None)
		{
			Combo.AddAilment(Pawn(Owner), bAll, False, bSingle, ComboLifespan, class'ComboHeatInv', EffectMultiplier, bDispellable);
		}
		EffectEmitter = Pawn(Owner).Spawn(EffectEmitterClass, Pawn(Owner), , Pawn(Owner).Location, Pawn(Owner).Rotation);
	}
}

defaultproperties
{
	EffectEmitterClass=Class'ComboAbilityBurnFX'
}
