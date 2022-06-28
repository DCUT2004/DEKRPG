class RuneIcicleFire extends RuneProjectileFire
	config(DEKWeapons);

#exec  AUDIO IMPORT NAME="IcicleFireSound" FILE="Sounds\IcicleFireSound.WAV" GROUP="RuneSounds"

defaultproperties
{
	 AdrenCost=10
     //bModeExclusive=False
     bSplashDamage=True
     bSplashJump=True
     bRecommendSplashDamage=True
     FireSound=Sound'DEKRPG209E.RuneSounds.IcicleFireSound'
     FireForce="RocketLauncherFire"
     FireRate=1.510000
     ProjectileClass=Class'DEKRPG209E.RuneIcicleProj'
}
