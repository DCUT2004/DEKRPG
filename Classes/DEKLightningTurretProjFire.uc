class DEKLightningTurretProjFire extends FM_BallTurret_Fire;

#exec  AUDIO IMPORT NAME="LightningTurretFire" FILE="Sounds\LightningTurretFire.WAV" GROUP="TurretSounds"

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile p;

	p = Weapon.Spawn(class'DEKLightningTurretProj', Instigator, , Start, Dir);
    if ( p == None )
		return None;
	
	p.Damage *= DamageAtten;
	return p;
}

defaultproperties
{
     TeamProjectileClasses(0)=Class'DEKRPG209C.DEKLightningTurretProj'
     TeamProjectileClasses(1)=Class'DEKRPG209C.DEKLightningTurretProj'
     FireAnimRate=6.000000
     FireSound=Sound'DEKRPG209C.TurretSounds.LightningTurretFire'
     FireRate=0.500000
     ProjectileClass=Class'DEKRPG209C.DEKLightningTurretProj'
}
