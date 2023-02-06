class StatusEffectDamageRules extends Object;

static function int HandleDamage(int Damage, Pawn Instigator, StatusEffectInventory InstigatorStatusManager, Pawn Victim, StatusEffectInventory VictimStatusManager, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
	local int StatusIndex;

	//Adjust damage if Instigator has StatusEffect_DamageBonus
	if (Instigator != None && InstigatorStatusManager != None)
	{
		StatusIndex = InstigatorStatusManager.GetIndex(class'StatusEffect_DamageBonus');
		if (StatusIndex >= 0 && InstigatorStatusManager.StatusEffects[StatusIndex].Modifier != 0)
		{
			Damage *= 1 + (InstigatorStatusManager.StatusEffects[StatusIndex].Modifier * class'StatusEffectInventory'.static.GetDamagePercentPerModifier());
			if (Damage <= 0)
				Damage = 1;
		}
	}

	//Adjust damage if Victim has StatusEffect_DamageReduction
	if (Victim != None && VictimStatusManager != None)
	{
		StatusIndex = VictimStatusManager.GetIndex(class'StatusEffect_DamageReduction');
		if (StatusIndex >= 0 && VictimStatusManager.StatusEffects[StatusIndex].Modifier != 0)
		{
			Damage *= 1 + (-VictimStatusManager.StatusEffects[StatusIndex].Modifier * class'StatusEffectInventory'.static.GetDamagePercentPerModifier());
			if (Damage <= 0)
				Damage = 1;
		}

		//Adjust momentum if Victim has StatusEffect_Momentum
		StatusIndex = VictimStatusManager.GetIndex(class'StatusEffect_Momentum');
		if (StatusIndex >= 0 && VictimStatusManager.StatusEffects[StatusIndex].Modifier != 0)
		{
			if (VictimStatusManager.StatusEffects[StatusIndex].Modifier < 0)
				class'StatusEffectInventory'.static.AddMomentum(-VictimStatusManager.StatusEffects[StatusIndex].Modifier, Damage, Victim, Instigator, HitLocation, Momentum, DamageType);
			else if (VictimStatusManager.StatusEffects[StatusIndex].Modifier > 0)
				class'StatusEffectInventory'.static.ReduceMomentum(VictimStatusManager.StatusEffects[StatusIndex].Modifier, Damage, Momentum);
		}
	}

	//Adjust damage if Instigator has ChanceHit
	if (Instigator != None && InstigatorStatusManager != None)
	{
		StatusIndex = InstigatorStatusManager.GetIndex(class'StatusEffect_ChanceHit');
		if (StatusIndex >= 0 && InstigatorStatusManager.StatusEffects[StatusIndex].Modifier != 0)
		{
			if (Rand(100) <= abs(InstigatorStatusManager.StatusEffects[StatusIndex].Modifier)*class'StatusEffectInventory'.static.GetChanceHitPerModifier())
			{
				if (InstigatorStatusManager.StatusEffects[StatusIndex].Modifier > 0)
				{
					Damage *= 2;
					Instigator.Spawn(Class'GamblerHitEffect',,,Instigator.Location);
					Instigator.PlaySound(sound'GeneralImpacts.Wet.Breakbone_01',,1.1*Instigator.TransientSoundVolume,,Instigator.TransientSoundRadius);
					Victim.Spawn(Class'GamblerHitEffect',,,Victim.Location);
					Victim.PlaySound(sound'GeneralImpacts.Wet.Breakbone_01',,1.1*Victim.TransientSoundVolume,,Victim.TransientSoundRadius);
				}
				else if (InstigatorStatusManager.StatusEffects[StatusIndex].Modifier < 0)
				{
					Damage = 1;
					Instigator.Spawn(Class'MissedShotHitEffect',,,Instigator.Location);
					//Instigator.PlaySound(sound'2K4MenuSounds.Generic.msfxFade',,1.1*Instigator.TransientSoundVolume,,Instigator.TransientSoundRadius);
					Victim.Spawn(Class'MissedShotHitEffect',,,Victim.Location);
					//Victim.PlaySound(Sound'2K4MenuSounds.Generic.msfxFade',,1.1*Victim.TransientSoundVolume,,Victim.TransientSoundRadius);
				}
			}
		}
	}
	return Damage;
}

defaultproperties
{
}
