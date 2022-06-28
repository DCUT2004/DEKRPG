//The combo that the player has purchased
class ComboAbilityPurifyingStrikeInv extends ComboAbilityInv
	config(UT2004RPG);
	
function DoEffect()
{
	if (Owner != None && Pawn(Owner) != None)
	{
		if (Combo != None)
		{
			Combo.ComboDamage(ComboDamage, bAll, False, bSingle, class'DEKRPG209E.DamTypeCombo', class'RocketExplosion', True);
			Combo.DispelAilment(Pawn(Owner), True, False);
		}
	}
}

defaultproperties
{
}
