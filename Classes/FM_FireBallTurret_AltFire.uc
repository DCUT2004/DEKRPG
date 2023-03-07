class FM_FireBallTurret_AltFire extends FM_BallTurret_Fire;

#exec  AUDIO IMPORT NAME="PlasmaTurretAltFire" FILE="Sounds\PlasmaTurretAltFire.WAV" GROUP="TurretSounds"

function DoFireEffect()
{
	local Vector	Start, X,Y,Z, HL, HN;

	ProjSpawnOffset = default.ProjSpawnOffset;
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

	p = Weapon.Spawn(class'FlameProj', Instigator, , Start, Dir);
    if ( p == None )
        return None;
		
	Instigator.PlaySound(Sound'DEKRPG999X.TurretSounds.PlasmaTurretAltFire',,150.000);

    p.Damage *= DamageAtten;
    return p;
}

defaultproperties
{
     TeamProjectileClasses(0)=Class'DEKRPG999X.FlameProj'
     TeamProjectileClasses(1)=Class'DEKRPG999X.FlameProj'
     FireSound=None
     FireRate=0.200000
	 ProjSpawnOffset=(X=138,Y=-25,Z=+16)
}
