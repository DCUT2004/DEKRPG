//The combo that the player has purchased
class ComboAbilityHealInv extends ComboAbilityInv
	config(UT2004RPG);
	
var config float MaxMultiplier;
	
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
				C.Pawn.GiveHealth(EffectMultiplier, C.Pawn.Health + EffectMultiplier);
				if (C.Pawn.Health > C.Pawn.HealthMax*MaxMultiplier)
					C.Pawn.Health = C.Pawn.HealthMax*MaxMultiplier;
				if (PlayerController(C) != None)
					PlayerController(C).ClientPlaySound(Sound'PickupSounds.HealthPack');
			}
			C = NextC;
		}
	}
}

defaultproperties
{
	MaxMultiplier=2.000000
}
