//The combo that the player has purchased
class ComboAbilityShieldHealInv extends ComboAbilityInv
	config(UT2004RPG);
	
function DoEffect()
{
	local Controller C, NextC;
	local xPawn xP;
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
					xP = xPawn(C.Pawn);
					if (C.Pawn.ShieldStrength + EffectMultiplier > xP.GetShieldStrengthMax())
					{
						Inv = ShieldMaxInv(C.Pawn.FindInventoryType(Class'ShieldMaxInv'));
						if (Inv != None)
							Inv.OriginalMaxShield += EffectMultiplier;
						else
						{
							Inv = C.Pawn.Spawn(Class'ShieldMaxInv');
							Inv.OriginalMaxShield = xP.GetShieldStrengthMax();
							xP.ShieldStrengthMax += EffectMultiplier;
							Inv.GiveTo(C.Pawn);
						}
					}
					xP.ShieldStrength += EffectMultiplier;
					if (PlayerController(C) != None)
						PlayerController(C).ClientPlaySound(Sound'PickupSounds.ShieldPack');
				}
			}
			C = NextC;
		}
	}
}

defaultproperties
{
}
