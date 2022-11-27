class PoisonAddonPowerType extends AddonPowerType
	config(UT2004RPG);

var config float PoisonLifespan;

static function bool AllowedFor(Weapon W)
{
	// check if superweapon 
	if (W == None)
		return false;

	if(instr(caps(W), "POISONBLAST") > -1)
		return false;

	return true;
}

// DoPowerEffect - use the damage here (e.g. energy vampire etc)
function DoPowerEffect(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	local MagicShieldInv MInv;
	local StatusEffectManager StatusInv;
	local Pawn P;

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

	if ((DamageType != class'DamTypePoison') && (Damage > 0) && (TheWeapon.GetModifier() > 0))
	{
		if (P != None)
		{
            MInv = MagicShieldInv(P.FindInventoryType(class'MagicShieldInv'));
    		if (MInv == None)
    		{
				StatusInv = StatusEffectManager(P.FindInventoryType(Class'StatusEffectManager'));
				if (StatusInv == None)
					return;
				StatusInv.AddStatusEffect(Class'StatusEffect_Poison', -TheWeapon.GetModifier()*PerformanceIncrease, True, PoisonLifespan*PerformanceIncrease, True, False, TheWeapon.Instigator);
            }
		}
	}
}

function bool CanCoexist( class<AddonPowerType> NewType )
{
	if (!Super.CanCoexist(NewType ))
		return false;

	// Bounce the poison power type because due to the way the code is implemented, it doesn't stack
	if (NewType == class'PoisonAddonPowerType')
		return false;
	return true;
}

defaultproperties
{
	PoisonLifespan=4.0
	PosName="Poison"
	ZeroName="Poison"
	NegName="Poison"
	CanHaveZeroModifier=false
	CanHaveNegativeModifier=false
	AIBonus=0.1
	PowerOverlay=Shader'XGameShaders.PlayerShaders.LinkHit'
	ThisPickupClass=Class'PoisonAddonPowerPickup'
}

