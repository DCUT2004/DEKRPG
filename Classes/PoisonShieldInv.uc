class PoisonShieldInv extends Inventory
	config(UT2004RPG);

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	Super.GiveTo(Other);
	SetTimer(0.5, True);
}

simulated function Timer()
{
	local StatusEffectManager StatusManager;
	
	if (Instigator == None)
	{
		Destroy();
		return;
	}

	if (Instigator == None || Instigator.Health < 0)
	{
		Destroy();
		return;     // cant do anything
	}
	else
	{
		StatusManager = Class'StatusEffectManager'.static.GetStatusEffectmanager(Instigator);
		if (StatusManager != None)
		{
			StatusManager.RemoveStatusEffect(StatusManager.GetIndex(Class'StatusEffect_Poison'));
		}
	}
}

defaultproperties
{
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
