class ProtectionAddonPowerType extends AddonPowerType
	config(UT2004RPG);

var config float ProtectionPercent;
var config float ProtectionRepeatLifespan;
var config int ProtectionHealthCap;


function AdjustPlayerDamage(out int Damage, Pawn InstigatedBy, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	local Actor A;

	Damage = Max(1, Damage * (1.0 - ((ProtectionPercent/100.0) *  TheWeapon.GetModifier() *PerformanceIncrease)));

	if (InstigatedBy != None && TheWeapon.Instigator != None && Damage > 0 && TheWeapon.GetModifier() > 0 && InstigatedBy.Controller != None && !InstigatedBy.Controller.SameTeamAs(TheWeapon.Instigator.Controller) && InstigatedBy != TheWeapon.Instigator )
	{
		A = Spawn(Class'DEKEffectProtection',,,TheWeapon.Owner.Location,rotator(Normal(HitLocation - Location)));
		if ( A != None )
		{
			A.RemoteRole = ROLE_SimulatedProxy;
			A.PlaySound(Sound'BShieldReflection',,1.0 * instigatedBy.TransientSoundVolume,,instigatedBy.TransientSoundRadius);
		}
	}
}

function PlayerTakenDamage(out int Damage, Pawn InstigatedBy, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	local ProtectionInv inv;
	if (TheWeapon.GetModifier() > 0 && Damage >= TheWeapon.Instigator.Health && TheWeapon.Instigator.Health > ProtectionHealthCap)
	{
		inv = ProtectionInv(TheWeapon.Instigator.FindInventoryType(class'ProtectionInv'));
		if (Inv == None)
		{
			Damage = TheWeapon.Instigator.Health - 1; //help protect them for the first shot Damage reduction still applies though.
			inv = spawn(class'ProtectionInv', TheWeapon.Instigator,,, rot(0,0,0));
			if(inv != None)
			{
				inv.Lifespan = (ProtectionRepeatLifespan / float(TheWeapon.GetModifier()));
				inv.giveTo(TheWeapon.Instigator);
			}
		}
	}
}


function bool CanCoexist( class<AddonPowerType> NewType )
{
	if (!Super.CanCoexist(NewType ))
		return false;

	// test for rage Power type, and bounce
	if (NewType == class'RageAddonPowerType')
		return false;
	return true;
}

defaultproperties
{
	ProtectionPercent=8.0		
	ProtectionRepeatLifespan=6.0	
	ProtectionHealthCap=10		
	PosName="Protection"
	ZeroName=""
	NegName="Harm"
	CanHaveZeroModifier=false
	CanHaveNegativeModifier=true
	AIBonus=0.1
	PowerOverlay=Shader'XGameShaders.PlayerShaders.PlayerShieldSh'
	ThisPickupClass=Class'ProtectionAddonPowerPickup'
}

