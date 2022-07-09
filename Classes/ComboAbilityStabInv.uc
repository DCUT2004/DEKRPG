//The combo that the player has purchased
class ComboAbilityStabInv extends ComboAbilityInv
	config(UT2004RPG);
	
var int Counter;
	
function DoEffect()
{
	if (Owner != None && Pawn(Owner) != None)
	{
		if (Combo != None)
		{
			Combo.ComboDamage(ComboDamage, bAll, False, bSingle, class'DEKRPG209F.DamTypeCombo', class'RocketExplosion', True);
		}
	}
	Counter = ComboLifespan;
	SetTimer(1, True);
	Log("SetTimer called. Counter is " $ Counter);
}

simulated function Timer()
{
	if (Owner != None && Pawn(Owner) != None)
	{
		if (Counter > 0)
		{
			if (Combo != None)
			{
				Combo.ComboDamage(EffectMultiplier, bAll, False, bSingle, class'DEKRPG209F.DamTypeCombo', class'RocketExplosion', True);
			}
			Counter--;
			Log("Counter: " $ Counter);
		}
		else
			return;
	}
}

defaultproperties
{
}
