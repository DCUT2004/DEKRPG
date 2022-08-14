class RageAddonPowerType extends AddonPowerType
	config(UT2004RPG);

var config float RageDamageReturn;
var config int RageMinimumHealth;

static function bool AllowedFor(Weapon W)
{
	if (W == None)
		return false;

	if ( W.default.FireModeClass[0] != None && W.default.FireModeClass[0].default.AmmoClass != None
		          && class'MutUT2004RPG'.static.IsSuperWeaponAmmo(W.default.FireModeClass[0].default.AmmoClass) )
		return false;
	
	if (ClassIsChildOf(W.Class,class'LinkGun') || ClassIsChildOf(W.Class,class'MiniGun'))
		return false;

	if(instr(caps(string(W)), "MEGABLAST") > -1)
		return false;		

	return true;
}

// DoPowerEffect - use the damage here (e.g. energy vampire etc)
function DoPowerEffect(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	local Pawn P;
	local int localDamage;
	local MissionInvBETA MissionInv;

	Super.DoPowerEffect(Damage, Victim, HitLocation, Momentum, DamageType);

	if (Pawn(Victim) == None)
		return;
	P = Pawn(Victim);
    
    if (TheWeapon.Instigator == None)
        return;

	if (Damage > 0)
	{
		localDamage = Max(1, RageDamageReturn * Damage);
		if(localDamage >= TheWeapon.Instigator.Health - RageMinimumHealth)
			localDamage = TheWeapon.Instigator.Health - RageMinimumHealth;
		if(localDamage > 0)
		{
			if(TheWeapon.Instigator.Controller == None || TheWeapon.Instigator.Controller.bGodMode == False)
				TheWeapon.Instigator.Health -= localDamage; //ouch. Done this way to prevent damage reduction. It's dirty, but it works
			if (TheWeapon.Instigator.Controller != None)
			{
				MissionInv = class'MissionInvBETA'.static.GetMissionInv(TheWeapon.Instigator.Controller);
				if (MissionInv == None)
					return;
				if (!MissionInv.IsMissionActive("Anger Management"))
					return;
				MissionInv.TickMission(MissionInv.GetMissionIndex("Anger Management"), localDamage);
			}
		}


	}
}

function bool CanCoexist( class<AddonPowerType> NewType )
{
	if (!Super.CanCoexist(NewType ))
		return false;

	// test for healing protection vampire Power types, and bounce
	if (NewType == class'HealingAddonPowerType')
		return false;
	if (NewType == class'VampireAddonPowerType')
		return false;
	if (NewType == class'ProtectionAddonPowerType')
		return false;
	if (NewType == class'DamageAddonPowerType')    // would be too strong
		return false;
	if (NewType == class'RageAddonPowerType')      // would be too powerful
		return false;

	return true;
}

defaultproperties
{
	DamagePercent=20.0		// was 10% on modifier 6-10
	RageDamageReturn=0.125
	RageMinimumHealth=75
	PosName="Rage"
	ZeroName="Rage"
	NegName="Rage"
	CanHaveZeroModifier=false
	CanHaveNegativeModifier=false
	AIBonus=0.1
	PowerOverlay=FinalBlend'XEffectMat.Combos.RedBoltFB'
	ThisPickupClass=Class'RageAddonPowerPickup'
}

