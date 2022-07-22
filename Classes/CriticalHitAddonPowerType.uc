class CriticalHitAddonPowerType extends AddonPowerType
	config(UT2004RPG);

var config float ChancePerModifier;
var config float DamageReduction, DamageBoost;

function AdjustDamage(out int Damage, int OriginalDamage, Actor Victim, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
	local int Chance;
	local Actor A;
	local Mission1Inv M1Inv;
	local Mission2Inv M2Inv;
	local Mission3Inv M3Inv;

	Super.AdjustDamage(Damage, OriginalDamage, Victim, HitLocation, Momentum, DamageType);

	if (Damage <= 0)
        return;
    
    Chance = TheWeapon.GetModifier()*ChancePerModifier;
 
 	if(TheWeapon.Instigator != None && Victim != None && Victim.IsA('Pawn'))
	{
		if (Chance >= Rand(100))
		{
			Damage *= DamageBoost;
			A = spawn(class'GamblerHitEffect',,, TheWeapon.Instigator.Location);
			if (A != None)
			{
				A.RemoteRole = ROLE_SimulatedProxy;
				A.PlaySound(sound'GeneralImpacts.Wet.Breakbone_01',,1.1*TheWeapon.Instigator.TransientSoundVolume,,TheWeapon.Instigator.TransientSoundRadius);
			}
				
			A = spawn(class'GamblerHitEffect',,, Victim.Location);
		
			if (A != None)
			{
				A.RemoteRole = ROLE_SimulatedProxy;
				A.PlaySound(sound'GeneralImpacts.Wet.Breakbone_01',,1.1*Victim.TransientSoundVolume,,Victim.TransientSoundRadius);
			}
			if (TheWeapon.Instigator != None)
			{
				M1Inv = Mission1Inv(TheWeapon.Instigator.FindInventoryType(class'Mission1Inv'));
				M2Inv = Mission2Inv(TheWeapon.Instigator.FindInventoryType(class'Mission2Inv'));
				M3Inv = Mission3Inv(TheWeapon.Instigator.FindInventoryType(class'Mission3Inv'));
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
	PosName="Gambling"
	ZeroName="Gambling"
	NegName="Gambling"
	CanHaveZeroModifier=false
	CanHaveNegativeModifier=false
	AIBonus=0.1
	PowerOverlay=Shader'UT2004Weapons.Shaders.ShockHitShader'
	ThisPickupClass=Class'CriticalHitAddonPowerPickup'
}

