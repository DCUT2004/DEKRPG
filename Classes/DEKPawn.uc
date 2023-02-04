class DEKPawn extends xPawn;

var StatusEffectInventory StatusManager;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	StatusManager = StatusEffectInventory_Player(Instigator.FindInventoryType(Class'StatusEffectInventory_Player'));
	if (StatusManager == None)
	{
		StatusManager = Instigator.Spawn(Class'StatusEffectInventory_Player');
		StatusManager.GiveTo(Instigator);
	}
}

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
	local DEKPawn Other;
	local int StatusIndex;

	Other = DEKPawn(EventInstigator);

	//Adjust damage if EventInstigator has StatusEffect_DamageBonus
	if (Other != None && Other.StatusManager != None)
	{
		StatusIndex = Other.StatusManager.GetIndex(class'StatusEffect_DamageBonus');
		if (StatusIndex >= 0 && Other.StatusManager.StatusEffects[StatusIndex].Modifier != 0)
		{
			Damage *= 1 + (Other.StatusManager.StatusEffects[StatusIndex].Modifier * class'StatusEffectInventory'.static.GetDamagePercentPerModifier());
			if (Damage <= 0)
				Damage = 1;
		}
	}

	//Adjust damage if this Pawn has StatusEffect_DamageReduction
	if (Instigator != None && StatusManager != None)
	{
		StatusIndex = StatusManager.GetIndex(class'StatusEffect_DamageReduction');
		if (StatusIndex >= 0 && StatusManager.StatusEffects[StatusIndex].Modifier != 0)
		{
			Damage *= 1 + (-StatusManager.StatusEffects[StatusIndex].Modifier * class'StatusEffectInventory'.static.GetDamagePercentPerModifier());
			if (Damage <= 0)
				Damage = 1;
		}

		//Adjust momentum if this Pawn has StatusEffect_Momentum
		StatusIndex = StatusManager.GetIndex(class'StatusEffect_Momentum');
		if (StatusIndex >= 0 && StatusManager.StatusEffects[StatusIndex].Modifier != 0)
		{
			if (StatusManager.StatusEffects[StatusIndex].Modifier < 0)
				class'StatusEffectInventory'.static.AddMomentum(-StatusManager.StatusEffects[StatusIndex].Modifier, Damage, Instigator, EventInstigator, HitLocation, Momentum, DamageType);
			else if (StatusManager.StatusEffects[StatusIndex].Modifier > 0)
				class'StatusEffectInventory'.static.ReduceMomentum(StatusManager.StatusEffects[StatusIndex].Modifier, Damage, Momentum);
		}
	}
	Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
}

defaultproperties
{
}
