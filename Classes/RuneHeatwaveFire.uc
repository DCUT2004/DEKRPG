class RuneHeatwaveFire extends RuneProjectileFire
	config(DEKWeapons);

defaultproperties
{
	 bModeExclusive=False
	 AdrenCost=15
     bSplashDamage=True
     bRecommendSplashDamage=True
     FireSound=SoundGroup'WeaponSounds.RocketLauncher.RocketLauncherFire'
     FireForce="RocketLauncherFire"
     FireRate=3.000000
     ProjectileClass=Class'DEKRPG209F.RuneHeatwaveProj'
}
