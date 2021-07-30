//The combo that the player has purchased
class ComboAbilityAttackAilmentInv extends ComboAbilityInv
	config(UT2004RPG);
	
function DoEffect()
{
	if (Owner != None && Pawn(Owner) != None)
	{
		if (Combo != None)
		{
			Combo.AddAilment(Pawn(Owner), bAll, False, bSingle, ComboLifespan, class'ComboAttackInv', EffectMultiplier, bDispellable);
		}
	}
}

defaultproperties
{

}
