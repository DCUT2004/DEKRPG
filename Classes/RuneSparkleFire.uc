class RuneSparkleFire extends RuneProjectileFire
	config(DEKWeapons);

defaultproperties
{
	 AdrenCost=2
     //bModeExclusive=False
     bSplashDamage=True
     bSplashJump=False
     bRecommendSplashDamage=True
     FireSound=Sound'DEKRPG999X.TurretSounds.LightningTurretFire'
     FireForce="RocketLauncherFire"
     FireRate=0.500000
     ProjectileClass=Class'DEKRPG999X.RuneSparkleProj'
}
