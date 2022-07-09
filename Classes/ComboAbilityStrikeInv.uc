//The combo that the player has purchased
class ComboAbilityStrikeInv extends ComboAbilityInv
	config(UT2004RPG);
	
function DoEffect()
{
	if (Owner != None && Pawn(Owner) != None)
	{
		if (Combo != None)
		{
			Combo.ComboDamage(ComboDamage, bAll, False, bSingle, class'DEKRPG209F.DamTypeCombo', class'RocketExplosion', True);
		}
	}
}

defaultproperties
{
}
