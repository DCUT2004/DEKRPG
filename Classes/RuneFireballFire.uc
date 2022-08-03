class RuneFireballFire extends RuneProjectileFire
	config(DEKWeapons);

defaultproperties
{
	 AdrenCost=5
     //bModeExclusive=False
     bSplashDamage=True
     bSplashJump=True
     bRecommendSplashDamage=True
     FireSound=SoundGroup'WeaponSounds.RocketLauncher.RocketLauncherFire'
     FireForce="RocketLauncherFire"
     FireRate=0.900000
     ProjectileClass=Class'DEKRPG999X.RuneFireballProj'
}
