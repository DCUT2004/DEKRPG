class FM_FireBallTurret_AltFire extends FM_BallTurret_Fire;

#exec  AUDIO IMPORT NAME="FireballTurretAltFire" FILE="Sounds\FireballTurretAltFire.WAV" GROUP="TurretSounds"

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
		
	if (Instigator != None)
		Instigator.AmbientSound = Sound'FireballTurretAltFire';

    p.Damage *= DamageAtten;
    return p;
}


function StopFiring()
{
	if (Instigator != None)
		Instigator.AmbientSound = None;
}

defaultproperties
{
     TeamProjectileClasses(0)=Class'DEKRPG999X.FlameProj'
     TeamProjectileClasses(1)=Class'DEKRPG999X.FlameProj'
     FireSound=None
     FireRate=0.200000
	 ProjSpawnOffset=(X=138,Y=-25,Z=+16)
}
