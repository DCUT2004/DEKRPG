//The combo that the player has purchased
class ComboAbilityAdrenBoostInv extends ComboAbilityInv
	config(UT2004RPG);
	
function DoEffect()
{
	local Controller C, NextC;
	local AdrenMaxInv Inv;
	
	if (Owner != None && Pawn(Owner) != None && Pawn(Owner).Controller != None)
	{
		C = Level.ControllerList;
		
		while (C != None)
		{
			NextC = C.NextController;
			if (C != None && C.Pawn != None && C.Pawn.Health > 0 && C.SameTeamAs(Pawn(Owner).Controller))
			{
				Inv = AdrenMaxInv(C.Pawn.FindInventoryType(Class'AdrenMaxInv'));
				if (Inv != None)
					Inv.OriginalMaxAdren += int(EffectMultiplier);
				else
					C.AdrenalineMax += int(EffectMultiplier);
			}
			C = NextC;
		}
	}
}

defaultproperties
{
}
