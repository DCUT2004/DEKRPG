//The combo that the player has purchased

class ComboAbilityPortalDimensionInv extends ComboAbilityInv
	config(UT2004RPG);
	
var int SkillLevel;
var float MonsterLifespan;
	
function DoEffect()
{
	if (Owner != None && Pawn(Owner) != None)
	{
		if (Combo != None)
		{
			Combo.SpawnPortal(Pawn(Owner), SkillLevel, MonsterLifespan);
		}
	}
}

defaultproperties
{
}
