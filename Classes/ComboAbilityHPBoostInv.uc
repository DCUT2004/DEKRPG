//The combo that the player has purchased
class ComboAbilityHPBoostInv extends ComboAbilityInv
	config(UT2004RPG);
	
function DoEffect()
{
	local Controller C, NextC;
	
	if (Owner != None && Pawn(Owner) != None && Pawn(Owner).Controller != None)
	{
		C = Level.ControllerList;
		
		while (C != None)
		{
			NextC = C.NextController;
			if (C != None && C.Pawn != None && C.Pawn.Health > 0 && C.SameTeamAs(Pawn(Owner).Controller))
			{
				C.Pawn.HealthMax += EffectMultiplier;
			}
			C = NextC;
		}
	}
}

defaultproperties
{
}
