class RW_CriticalHit extends OneDropRPGWeapon
	HideDropDown
	CacheExempt
	config(UT2004RPG);

var config float ChancePerModifier;
var config float DamageReduction, DamageBoost;

function AdjustTargetDamage(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	local int Chance;
	local Actor A;
	local Mission1Inv M1Inv;
	local Mission2Inv M2Inv;
	local Mission3Inv M3Inv;

	if (!bIdentified)
		Identify();

	if (!class'OneDropRPGWeapon'.static.CheckCorrectDamage(ModifiedWeapon, DamageType))
		return;

	if(Victim == None)
		return; //nothing to do

	Chance = Modifier*ChancePerModifier;

	if(Damage > 0 && Instigator != None && Victim != None && Victim.IsA('Pawn'))
	{
		if (Chance >= Rand(100))
		{
			Damage *= DamageBoost;
			A = spawn(class'GamblerHitEffect',,, Instigator.Location);
			if (A != None)
			{
				A.RemoteRole = ROLE_SimulatedProxy;
				A.PlaySound(sound'GeneralImpacts.Wet.Breakbone_01',,1.1*Instigator.TransientSoundVolume,,Instigator.TransientSoundRadius);
			}
				
			A = spawn(class'GamblerHitEffect',,, Victim.Location);
		
			if (A != None)
			{
				A.RemoteRole = ROLE_SimulatedProxy;
				A.PlaySound(sound'GeneralImpacts.Wet.Breakbone_01',,1.1*Victim.TransientSoundVolume,,Victim.TransientSoundRadius);
			}
			if (Instigator != None)
			{
				M1Inv = Mission1Inv(Instigator.FindInventoryType(class'Mission1Inv'));
				M2Inv = Mission2Inv(Instigator.FindInventoryType(class'Mission2Inv'));
				M3Inv = Mission3Inv(Instigator.FindInventoryType(class'Mission3Inv'));
				if (M1Inv != None && !M1Inv.Stopped && M1Inv.GamblersLuckActive)
				{
					M1Inv.MissionCount += Damage;
				}
				if (M2Inv != None && !M2Inv.Stopped && M2Inv.GamblersLuckActive)
				{
					M2Inv.MissionCount += Damage;
				}
				if (M3Inv != None && !M3Inv.Stopped && M3Inv.GamblersLuckActive)
				{
					M3Inv.MissionCount += Damage;
				}
			}
		}
		else
		{
			Damage *= DamageReduction;
		}
	}
}

defaultproperties
{
     ChancePerModifier=7.000000
     DamageReduction=0.800000
     DamageBoost=2.000000
     ModifierOverlay=Shader'UT2004Weapons.Shaders.ShockHitShader'
     MinModifier=1
     MaxModifier=5
     AIRatingBonus=0.080000
     PrefixPos="Gambler's "
}
