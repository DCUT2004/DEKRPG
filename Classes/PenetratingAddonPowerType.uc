class PenetratingAddonPowerType extends AddonPowerType
	config(UT2004RPG);

static function bool AllowedFor(Weapon W)
{
	local int x;

	if (W == None)
		return false;

	for (x = 0; x < W.NUM_FIRE_MODES; x++)
		if (class<InstantFire>(W.default.FireModeClass[x]) != None)
			return true;

	return false;
}

// DoPowerEffect - use the damage here (e.g. energy vampire etc)
function DoPowerEffect(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	local Pawn P;
	local int i;
	local vector X, Y, Z, StartTrace;

	Super.DoPowerEffect(Damage, Victim, HitLocation, Momentum, DamageType);

	if (Pawn(Victim) == None)
		return;
	P = Pawn(Victim);

	if (TheWeapon.IsSameTeam(P))
		return;		// no vampire from hurting teammates

	if (HitLocation != vect(0,0,0))
	{
		for (i = 0; i < TheWeapon.NUM_FIRE_MODES; i++)
			if (InstantFire(TheWeapon.GetFireMode(i)) != None && InstantFire(TheWeapon.GetFireMode(i)).DamageType == DamageType)
			{
				//HACK - compensate for shock rifle not firing on crosshair
				if (ShockBeamFire(TheWeapon.GetFireMode(i)) != None && PlayerController(TheWeapon.Instigator.Controller) != None)
				{
					StartTrace = TheWeapon.Instigator.Location + TheWeapon.Instigator.EyePosition();
					TheWeapon.GetViewAxes(X,Y,Z);
					StartTrace = StartTrace + X*class'ShockProjFire'.Default.ProjSpawnOffset.X;
					if (!TheWeapon.WeaponCentered())
						StartTrace = StartTrace + TheWeapon.Hand * Y*class'ShockProjFire'.Default.ProjSpawnOffset.Y + Z*class'ShockProjFire'.Default.ProjSpawnOffset.Z;
					InstantFire(TheWeapon.GetFireMode(i)).DoTrace(HitLocation + Normal(HitLocation - StartTrace) * Victim.CollisionRadius * 2, rotator(HitLocation - StartTrace));
				}
				else
					InstantFire(TheWeapon.GetFireMode(i)).DoTrace(HitLocation + Normal(HitLocation - (TheWeapon.Instigator.Location + Instigator.EyePosition())) * Victim.CollisionRadius * 2, rotator(HitLocation - (TheWeapon.Instigator.Location + TheWeapon.Instigator.EyePosition())));
				i = TheWeapon.NUM_FIRE_MODES;
			}
	}

}

function bool CanCoexist( class<AddonPowerType> NewType )
{
	if (!Super.CanCoexist(NewType ))
		return false;

	if (NewType == class'PenetratingAddonPowerType')	// 2 won't add anything
		return false;

	return true;
}

defaultproperties
{
	PosName="Penetrating"
	ZeroName="Penetrating"
	NegName="Penetrating"
	CanHaveZeroModifier=true
	CanHaveNegativeModifier=true
	AIBonus=0.1
	PowerOverlay=Shader'XGameShaders.PlayerShaders.PlayerTrans'
	ThisPickupClass=Class'PenetratingAddonPowerPickup'
}

