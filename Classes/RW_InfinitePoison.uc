class RW_InfinitePoison extends RW_Poison
	HideDropDown
	CacheExempt
	config(UT2004RPG);

var config float PoisonLifespan;
var config float DamageReduction;

static function bool AllowedFor(class<Weapon> Weapon, Pawn Other)
{
	if ( Weapon.default.FireModeClass[0] != None && Weapon.default.FireModeClass[0].default.AmmoClass != None
	          && class'MutUT2004RPG'.static.IsSuperWeaponAmmo(Weapon.default.FireModeClass[0].default.AmmoClass) )
		return false;
			
	if(instr(caps(Weapon), "SINGULARITY") > -1)
		return false;
	if(instr(caps(Weapon), "RAIL") > -1)
		return false;
	if(instr(caps(Weapon), "BLOOD") > -1)
		return false;
	if(instr(caps(Weapon), "SOUL") > -1)
		return false;
	if(instr(caps(Weapon), "PHANTOM") > -1)
		return false;
	if(instr(caps(Weapon), "LINK") > -1)
		return false;

	return true;
}

simulated function bool StartFire(int Mode)
{
	if (!bIdentified && Role == ROLE_Authority)
		Identify();

	return Super.StartFire(Mode);
}

function bool ConsumeAmmo(int Mode, float Load, bool bAmountNeededIsMax)
{
	if (!bIdentified)
		Identify();

	return true;
}

simulated function WeaponTick(float dt)
{
	MaxOutAmmo();

	Super.WeaponTick(dt);
}

simulated function int MaxAmmo(int mode)
{
	if (bNoAmmoInstances && HolderStatsInv != None)
		return (ModifiedWeapon.MaxAmmo(mode) * (1.0 + 0.01 * HolderStatsInv.Data.AmmoMax));

	return ModifiedWeapon.MaxAmmo(mode);
}

simulated function bool CanThrow()
{
	return false;
}

function DropFrom(vector StartLocation)
{
	Destroy();
}

function AdjustTargetDamage(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	local PoisonInv Inv;
	local Pawn P;

	if (DamageType == class'DamTypePoison' || Damage <= 0)
		return;
		
	if (Damage > 0)
		Damage *= DamageReduction;

	P = Pawn(Victim);
	if (P != None)
	{
		if (!bIdentified)
			Identify();

		Inv = PoisonInv(P.FindInventoryType(class'PoisonInv'));
		if (Inv != None)
			Inv.LifeSpan += Rand(Damage / 10) + 1;
		else
		{
			Inv = spawn(class'PoisonInv', P,,, rot(0,0,0));
			Inv.Modifier = Modifier;
			Inv.GiveTo(P);
			Inv.LifeSpan = PoisonLifespan;
		}
	}
}

defaultproperties
{
     PoisonLifespan=4.000000
     DamageReduction=0.800000
     MinModifier=1
     MaxModifier=6
     PostfixPos=" of Infinity"
}
