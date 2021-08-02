//The combo that the player has purchased
class ComboAbilityAdrenHealInv extends ComboAbilityInv
	config(UT2004RPG);
	
function DoEffect()
{
	local Controller C, NextC;
	local AdrenMaxTempInv Inv;
	
	if (Owner != None && Pawn(Owner) != None && Pawn(Owner).Controller != None)
	{
		C = Level.ControllerList;
		
		while (C != None)
		{
			NextC = C.NextController;
			if (C != None && C.Pawn != None && C.Pawn.Health > 0 && C.SameTeamAs(Pawn(Owner).Controller))
			{
				if (C.Adrenaline + EffectMultiplier > C.AdrenalineMax)
				{
					Inv = AdrenMaxTempInv(C.Pawn.FindInventoryType(Class'AdrenMaxTempInv'));
					if (Inv != None)	//This person currently has boosted Adren. We still want to heal the adren, but not change the original max amount
					{
						C.AdrenalineMax += EffectMultiplier;
					}
					else
					{
						Inv = C.Pawn.Spawn(Class'AdrenMaxTempInv');
						Inv.OriginalMaxAdren = C.AdrenalineMax;
						C.AdrenalineMax += EffectMultiplier;
						Inv.GiveTo(C.Pawn);
					}
				}
				C.Adrenaline += EffectMultiplier;
				if (PlayerController(C) != None)
					PlayerController(C).ClientPlaySound(Sound'AdrenelinPickup');
			}
			C = NextC;
		}
	}
}

defaultproperties
{
}
