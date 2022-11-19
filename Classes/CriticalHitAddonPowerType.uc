class CriticalHitAddonPowerType extends AddonPowerType
	config(UT2004RPG);

var config float ChancePerModifier;
var config float DamageReduction, DamageBoost;

function AdjustDamage(out int Damage, int OriginalDamage, Actor Victim, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
	local int Chance;
	local Actor A;
	local MissionInvBETA MissionInv;

	Super.AdjustDamage(Damage, OriginalDamage, Victim, HitLocation, Momentum, DamageType);

	if (Damage <= 0)
        return;
    
    Chance = TheWeapon.GetModifier()*ChancePerModifier*PerformanceIncrease;
 
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
			if (TheWeapon.Instigator.Controller != None)
			{
				MissionInv = class'MissionInvBETA'.static.GetMissionInv(TheWeapon.Instigator.Controller);
				if (MissionInv == None)
					return;
				if (!MissionInv.IsMissionActive("Gambler's Luck"))
					return;
				MissionInv.TickMission(MissionInv.GetMissionIndex("Gambler's Luck"), Damage);
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

