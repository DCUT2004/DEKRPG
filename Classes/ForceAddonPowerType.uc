class ForceAddonPowerType extends AddonPowerType
	config(UT2004RPG);

var config float ForceIncrease;
var int LastFlashCount;

static function bool AllowedFor(Weapon W)
{
	local int x;

	if (W == None)
		return false;

  	if(instr(caps(string(W)), "AVRIL") > -1)    //can't have slow-6 avril or will cause crash
	   return false;

	for (x = 0; x < W.NUM_FIRE_MODES; x++)
		if (class<ProjectileFire>(W.default.FireModeClass[x]) != None)
			return true;

	return false;
}

simulated event WeaponTick(float dt)
{
	local Projectile Proj;
	local ProjectileSpeedChanger PSC;

	if ( Role == ROLE_Authority && TheWeapon.Instigator != None
		&& (WeaponAttachment(TheWeapon.ThirdPersonActor) == None || LastFlashCount != WeaponAttachment(TheWeapon.ThirdPersonActor).FlashCount) )
	{
		foreach TheWeapon.Instigator.CollidingActors(class'Projectile', Proj, 200)
			if (Proj.Instigator == TheWeapon.Instigator && Proj.Speed == Proj.default.Speed && Proj.MaxSpeed == Proj.default.MaxSpeed)
			{
				Proj.Speed *= 1.0 + ForceIncrease * TheWeapon.GetModifier();
				Proj.MaxSpeed *= 1.0 + ForceIncrease * TheWeapon.GetModifier();
				Proj.Velocity *= 1.0 + ForceIncrease * TheWeapon.GetModifier();
				if (Level.NetMode != NM_Standalone)
				{
					PSC = spawn(class'ProjectileSpeedChanger',,,Proj.Location, Proj.Rotation);
					if (PSC != None)
					{
						PSC.Modifier = TheWeapon.GetModifier();
						PSC.ModifiedProjectile = Proj;
						PSC.SetBase(Proj);
						if (PSC.AmbientSound != None)
						{
							PSC.AmbientSound = Proj.AmbientSound;
							PSC.SoundRadius = Proj.SoundRadius;
						}
						else
							PSC.bAlwaysRelevant = true;
					}
				}
			}
		if (WeaponAttachment(TheWeapon.ThirdPersonActor) != None)
			LastFlashCount = WeaponAttachment(TheWeapon.ThirdPersonActor).FlashCount;
	}
}

function DoPowerEffect(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	Super.DoPowerEffect(Damage, Victim, HitLocation, Momentum, DamageType);

	if (TheWeapon.GetModifier()<0)
		Momentum /= 1.0 + (0.05 * abs(TheWeapon.GetModifier()));
}

function bool CanCoexist( class<AddonPowerType> NewType )
{
	if (!Super.CanCoexist(NewType ))
		return false;

	if (NewType == class'FreezeAddonPowerType')   // incompatible
		return false;
	if (NewType == class'ForceAddonPowerType')   // I don't think two of them will help
		return false;
	if (NewType == class'KnockbackAddonPowerType')	// I don't think two of them will help
		return false;
	return true;
}

defaultproperties
{
	ForceIncrease=0.2
	PosName="Force"
	ZeroName="Force"
	NegName="Slow Motion"
	CanHaveZeroModifier=false
	CanHaveNegativeModifier=true
	AIBonus=0.1
	PowerOverlay=Shader'XGameShaders.PlayerShaders.PlayerTransRed'
	ThisPickupClass=Class'ForceAddonPowerPickup'
}

