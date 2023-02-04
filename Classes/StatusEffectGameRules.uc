class StatusEffectGameRules extends GameRules
	config(UT2004RPG);

var config int ChanceHitPerModifier;

function int NetDamage( int OriginalDamage, int Damage, pawn injured, pawn instigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType )
{
	local Controller C, NextC;
	local int StatusIndex;
	local StatusEffectManager InstigatorStatusInv, InjuredStatusInv;
	local ComboAbilityTeleStealthInv TeleStealth;
	local ComboAbilityBeastsRevengeInv BeastsRevenge;
	local ComboAbilityHealingStrikeInv HealStrike;

	if (InstigatedBy != None && Injured != None && InstigatedBy.GetTeamNum() == Injured.GetTeamNum())
		return super.NetDamage(OriginalDamage, Damage, Injured, InstigatedBy, HitLocation, Momentum, DamageType);
	
	if (InstigatedBy != None)
		InstigatorStatusInv = class'StatusEffectManager'.static.GetStatusEffectManager(InstigatedBy);
	if (Injured != None)
		InjuredStatusInv = class'StatusEffectManager'.static.GetStatusEffectManager(Injured);

	//If the injured has BeastsRevenge, accumulate his damage
	//We do this here, before defense buffs/ailments are applied, so the defense buff from Beasts Revenge does not negate the effect
	BeastsRevenge = ComboAbilityBeastsRevengeInv(injured.FindInventoryType(Class'ComboAbilityBeastsRevengeInv'));
	if (BeastsRevenge != None)
		BeastsRevenge.AccumulatedDamage += Damage;	
	
	//Adjust damage if Instigator has ChanceHit
	if (InstigatorStatusInv != None)
	{
		StatusIndex = InstigatorStatusInv.GetIndex(class'StatusEffect_ChanceHit');
		if (StatusIndex >= 0 && InstigatorStatusInv.StatusEffects[StatusIndex].Modifier != 0)
		{
			if (Rand(100) <= abs(InstigatorStatusInv.StatusEffects[StatusIndex].Modifier)*ChanceHitPerModifier)
			{
				if (InstigatorStatusInv.StatusEffects[StatusIndex].Modifier > 0)
				{
					Damage *= 2;
					InstigatedBy.Spawn(Class'GamblerHitEffect',,,InstigatedBy.Location);
					InstigatedBy.PlaySound(sound'GeneralImpacts.Wet.Breakbone_01',,1.1*InstigatedBy.TransientSoundVolume,,InstigatedBy.TransientSoundRadius);
					Injured.Spawn(Class'GamblerHitEffect',,,Injured.Location);
					Injured.PlaySound(sound'GeneralImpacts.Wet.Breakbone_01',,1.1*Injured.TransientSoundVolume,,Injured.TransientSoundRadius);
				}
				else if (InstigatorStatusInv.StatusEffects[StatusIndex].Modifier < 0)
				{
					Damage = 1;
					InstigatedBy.Spawn(Class'MissedShotHitEffect',,,InstigatedBy.Location);
					//InstigatedBy.PlaySound(sound'2K4MenuSounds.Generic.msfxFade',,1.1*InstigatedBy.TransientSoundVolume,,InstigatedBy.TransientSoundRadius);
					Injured.Spawn(Class'MissedShotHitEffect',,,Injured.Location);
					//Injured.PlaySound(Sound'2K4MenuSounds.Generic.msfxFade',,1.1*Injured.TransientSoundVolume,,Injured.TransientSoundRadius);
				}
			}
		}
	}

	//If the instigator used Healing Strike, heal the instigator and his allies
	if (DamageType == class'DamTypeHealingStrike' && instigatedBy != None && instigatedBy.Health > 0)
	{
		HealStrike = ComboAbilityHealingStrikeInv(instigatedBy.FindInventoryType(Class'ComboAbilityHealingStrikeInv'));
		if (HealStrike != None)
		{
			C = Level.ControllerList;
			while (C != None)
			{
				NextC = C.NextController;
				if (C != None && C.Pawn != None && C.Pawn.Health > 0 && C.Pawn.GetTeamNum() == instigatedBy.GetTeamNum())
					C.Pawn.GiveHealth(HealStrike.EffectMultiplier*Damage, C.Pawn.HealthMax);
				C = NextC;
			}
		}
	}

	//If the instigator has TeleStealth, accumulate his damage
	TeleStealth = ComboAbilityTeleStealthInv(instigatedBy.FindInventoryType(Class'ComboAbilityTeleStealthInv'));
	if (TeleStealth != None)
		TeleStealth.AccumulatedDamage += Damage;
	
	return Super.NetDamage(OriginalDamage, Damage, injured, instigatedBy, HitLocation, Momentum, DamageType);
}

defaultproperties
{
	ChanceHitPerModifier=5
}
