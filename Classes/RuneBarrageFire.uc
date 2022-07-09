class RuneBarrageFire extends RuneProjectileFire
	config(DEKWeapons);

defaultproperties
{
     ProjPerFire=9
	 AdrenCost=2
     bSplashDamage=True
     bSplashJump=True
     bRecommendSplashDamage=True
     FireSound=SoundGroup'WeaponSounds.RocketLauncher.RocketLauncherFire'
     FireForce="RocketLauncherFire"
     FireRate=3.000000
     ProjectileClass=Class'DEKRPG209F.RuneBarrageProj'
     Spread=2800.000000
     SpreadStyle=SS_Random
}
