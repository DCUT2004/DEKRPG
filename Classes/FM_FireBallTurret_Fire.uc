class FM_FireBallTurret_Fire extends FM_BallTurret_Fire;

function DoFireEffect()
{
	local Vector	Start, X,Y,Z, HL, HN;

	ProjSpawnOffset = ASVehicle(Instigator).default.VehicleProjSpawnOffset;
	if ( bSwitch )
		ProjSpawnOffset.Y = -ProjSpawnOffset.Y;

	Instigator.MakeNoise(1.0);
    Instigator.GetAxes(Instigator.Rotation, X, Y, Z);

	Start = MyGetFireStart(X, Y, Z);

	ASVehicle(Instigator).CalcWeaponFire( HL, HN );
	SpawnProjectile(Start, Rotator(HL - Start));
}

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile p;

	p = Weapon.Spawn(class'PROJ_FireBallTurretSmall', Instigator, , Start, Dir);
    if ( p == None )
        return None;

    p.Damage *= DamageAtten;
    return p;
}

defaultproperties
{
     FireRate=0.25000
}
