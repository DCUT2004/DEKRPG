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
     TeamProjectileClasses(0)=Class'DEKRPG209D.DEKPlasmaTurretProj'
     TeamProjectileClasses(1)=Class'DEKRPG209D.DEKPlasmaTurretProj'
     FireSound=Sound'DEKRPG209D.TurretSounds.PlasmaTurretFire'
     FireRate=0.300000
}
