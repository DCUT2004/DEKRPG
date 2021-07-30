//The combo that the player has purchased
class ComboAbilityShieldBoostInv extends ComboAbilityInv
	config(UT2004RPG);
	
function DoEffect()
{
	local Controller C, NextC;
	local ShieldMaxInv Inv;
	
	if (Owner != None && Pawn(Owner) != None && Pawn(Owner).Controller != None)
	{
		C = Level.ControllerList;
		
		while (C != None)
		{
			NextC = C.NextController;
			if (C != None && C.Pawn != None && C.Pawn.Health > 0 && C.SameTeamAs(Pawn(Owner).Controller))
			{
				if (xPawn(C.Pawn) != None)
				{
					Inv = ShieldMaxInv(C.Pawn.FindInventoryType(Class'ShieldMaxInv'));
					if (Inv != None)
						Inv.OriginalMaxShield += int(EffectMultiplier);
					else
						xPawn(C.Pawn).ShieldStrengthMax += int(EffectMultiplier);
				}
			}
			C = NextC;
		}
	}
}

defaultproperties
{
}
