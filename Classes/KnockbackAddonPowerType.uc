class KnockbackAddonPowerType extends AddonPowerType
	config(UT2004RPG);

var config float KnockbackPercent;
var Sound KnockbackSound;

#exec OBJ LOAD FILE="..\Textures\AWTroff.utx"

static function bool AllowedFor(Weapon W)
{
	// check if superweapon 
	if (W == None)
		return false;

	if(instr(caps(W), "HEATWHIP") > -1)
		return false;
	if(instr(caps(W), "MAGNET") > -1)
		return false;

	return true;
}

// DoPowerEffect - use the damage here (e.g. energy vampire etc)
function DoPowerEffect(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	local Pawn P;
	local StatusEffectManager StatusInv;
	local MagicShieldInv MInv;

	Super.DoPowerEffect(Damage, Victim, HitLocation, Momentum, DamageType);

	if (Pawn(Victim) == None)
		return;
	P = Pawn(Victim);

	if (TheWeapon.GetModifier() <= 0)
		return;

	if (TheWeapon.IsSameTeam(P))
		return;

	if (Victim.isA('Vehicle'))
		return;

	if (!TheWeapon.static.NullcanTriggerPhysics(P))
		return;
        
    if (P.HealthMax > 5000)    // Bosses too big to throw around
        return;
        
    if (Damage <= 0)
        return;

	MInv = MagicShieldInv(P.FindInventoryType(class'MagicShieldInv'));
	if (MInv != None)
        return;
		
	StatusInv = StatusEffectManager(P.FindInventoryType(Class'StatusEffectManager'));
	if (StatusInv == None)
		return;
		
	StatusInv.AddStatusEffect(Class'StatusEffect_Momentum', -TheWeapon.GetModifier() *PerformanceIncrease, True, TheWeapon.GetModifier()*PerformanceIncrease, True, False);
}

function bool CanCoexist( class<AddonPowerType> NewType )
{
	if (!Super.CanCoexist(NewType ))
		return false;

	// Put in a test for nullentropy and freeze Power type, and bounce
	if (NewType == class'ForceAddonPowerType')
		return false;
	if (NewType == class'FreezeAddonPowerType')
		return false;
	if (NewType == class'KnockbackAddonPowerType')	// I don't think two of them will help
		return false;
	return true;
}

defaultproperties
{
	KnockbackPercent=6.0
	KnockbackSound=Sound'WeaponSounds.Misc.ballgun_launch'
	PosName="Knockback"
	ZeroName=""
	NegName=""
	CanHaveZeroModifier=false
	CanHaveNegativeModifier=false
	AIBonus=0.1
	PowerOverlay=FinalBlend'AWTroff.Shaders.TroffBackRedFinal'
	ThisPickupClass=Class'KnockbackAddonPowerPickup'
}

