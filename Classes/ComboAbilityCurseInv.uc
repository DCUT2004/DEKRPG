//The combo that the player has purchased
class ComboAbilityCurseInv extends ComboAbilityInv
	config(UT2004RPG);
	
function DoEffect()
{
	if (Owner != None && Pawn(Owner) != None)
	{
		if (Combo != None)
		{
			Combo.AddAilment(Pawn(Owner), bAll, False, bSingle, ComboLifespan, class'ComboCurseInv', EffectMultiplier, bDispellable);
		}
	}
}

defaultproperties
{

}
