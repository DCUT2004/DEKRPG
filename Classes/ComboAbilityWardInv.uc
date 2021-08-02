//The combo that the player has purchased
class ComboAbilityWardInv extends ComboAbilityInv
	config(UT2004RPG);
	
function DoEffect()
{
	if (Owner != None && Pawn(Owner) != None)
	{
		if (Combo != None)
		{
			Combo.AddBuff(Pawn(Owner), bAll, False, bSingle, ComboLifespan, class'ComboWardInv', EffectMultiplier, bDispellable);
		}
	}
}

defaultproperties
{
}
