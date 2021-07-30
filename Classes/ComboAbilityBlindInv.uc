//The combo that the player has purchased
class ComboAbilityBlindInv extends ComboAbilityInv
	config(UT2004RPG);
	
function DoEffect()
{
	if (Owner != None && Pawn(Owner) != None)
	{
		if (Combo != None)
		{
			Combo.AddAilment(Pawn(Owner), bAll, False, bSingle, ComboLifespan, class'ComboInaccuracyInv', EffectMultiplier, bDispellable);
		}
	}
}

defaultproperties
{

}
