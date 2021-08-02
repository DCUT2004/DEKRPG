class DEKPlasmaTurretFire extends FM_BallTurret_Fire;

#exec  AUDIO IMPORT NAME="PlasmaTurretFire" FILE="Sounds\PlasmaTurretFire.WAV" GROUP="TurretSounds"

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile p;

	p = Weapon.Spawn(class'DEKPlasmaTurretProj', Instigator, , Start, Dir);
    if ( p == None )
        return None;

    p.Damage *= DamageAtten;
    return p;
}

defaultproperties
{
     TeamProjectileClasses(0)=Class'DEKRPG208AE.DEKPlasmaTurretProj'
     TeamProjectileClasses(1)=Class'DEKRPG208AE.DEKPlasmaTurretProj'
     FireSound=Sound'DEKRPG208AE.TurretSounds.PlasmaTurretFire'
     FireRate=0.300000
}
