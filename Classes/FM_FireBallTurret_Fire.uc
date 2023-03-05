class FM_FireBallTurret_Fire extends FM_BallTurret_Fire;


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
