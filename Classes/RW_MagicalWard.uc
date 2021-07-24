class RW_MagicalWard extends OneDropRPGWeapon
	HideDropDown
	CacheExempt
	config(UT2004RPG);
	
#exec OBJ LOAD FILE=..\Sounds\GeneralImpacts.uax		

var config float DamageBonus;
var config int ChanceToWardPerModifier;

function NewAdjustTargetDamage(out int Damage, int OriginalDamage, Actor Victim, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
	if(damage > 0)
	{
		if (Damage < (OriginalDamage * class'OneDropRPGWeapon'.default.MinDamagePercent))
			Damage = OriginalDamage * class'OneDropRPGWeapon'.default.MinDamagePercent;
	}
	Super.NewAdjustTargetDamage(Damage, OriginalDamage, Victim, HitLocation, Momentum, DamageType);
}

function AdjustTargetDamage(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	if (!bIdentified)
		Identify();

	if (!class'OneDropRPGWeapon'.static.CheckCorrectDamage(ModifiedWeapon, DamageType))
		return;

	if(damage > 0)
	{
		Damage = Max(1, Damage * (1.0 + DamageBonus * Modifier));
		Momentum *= 1.0 + DamageBonus * Modifier;
	}
}

function AdjustPlayerDamage(out int Damage, Pawn InstigatedBy, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	local MagicalWardProtectionInv Inv;
	
	if (Instigator != None && Instigator.Health > 0)
	{
		Inv = MagicalWardProtectionInv(Instigator.FindInventoryType(class'MagicalWardProtectionInv'));
		if (Inv != None)
		{
			Damage *= Inv.ProtectionMultiplier;
			if (Damage < 1)
				Damage = 1;
		}
	}
	Super.AdjustPlayerDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
}

defaultproperties
{
	 ChanceToWardPerModifier=10
     DamageBonus=0.020000
     ModifierOverlay=FinalBlend'FireEngine.Liquids.river-finalblend'
     MinModifier=3
     MaxModifier=7
     AIRatingBonus=0.080000
	 PostfixPos=" of Magical Ward"
}
