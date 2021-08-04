//The combo that the player has purchased
class ComboAbilityRecklessStrikeInv extends ComboAbilityInv
	config(UT2004RPG);
	
function DoEffect()
{
	if (Owner != None && Pawn(Owner) != None)
	{
		if (Combo != None)
		{
			Combo.ComboDamage(ComboDamage, bAll, False, bSingle, class'DEKRPG208AF.DamTypeCombo', class'RocketExplosion', True);
			Combo.AddBuff(Pawn(Owner), False, False, True,  ComboLifespan, class'ComboDefenseInv', EffectMultiplier, False);
		}
	}
}

defaultproperties
{
}
