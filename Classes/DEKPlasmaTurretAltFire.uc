class DEKPlasmaTurretAltFire extends FM_BallTurret_Fire;

#exec  AUDIO IMPORT NAME="PlasmaTurretAltFire" FILE="Sounds\PlasmaTurretAltFire.WAV" GROUP="TurretSounds"

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile p;

	p = Weapon.Spawn(class'DEKPlasmaTurretBallProj', Instigator, , Start, Dir);
    if ( p == None )
        return None;
		
	Instigator.PlaySound(Sound'DEKRPG208AC.TurretSounds.PlasmaTurretAltFire',,200.000);

    p.Damage *= DamageAtten;
    return p;
}

defaultproperties
{
     TeamProjectileClasses(0)=Class'DEKRPG208AC.DEKPlasmaTurretBallProj'
     TeamProjectileClasses(1)=Class'DEKRPG208AC.DEKPlasmaTurretBallProj'
     FireSound=None
     FireRate=1.500000
}
