class RuneSparkleFire extends RuneProjectileFire
	config(DEKWeapons);

defaultproperties
{
	 AdrenCost=2
     //bModeExclusive=False
     bSplashDamage=True
     bSplashJump=False
     bRecommendSplashDamage=True
     FireSound=Sound'DEKRPG209E.TurretSounds.LightningTurretFire'
     FireForce="RocketLauncherFire"
     FireRate=0.380000
     ProjectileClass=Class'DEKRPG209E.RuneSparkleProj'
}
