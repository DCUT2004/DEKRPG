class RuneEnergyballFire extends RuneProjectileFire
	config(DEKWeapons);
	
#exec  AUDIO IMPORT NAME="EnergyballFire" FILE="Sounds\EnergyStealAlt.WAV" GROUP="RuneSounds"

defaultproperties
{
	 AdrenCost=0
     bModeExclusive=False
     FireSound=Sound'DEKRPG209D.RuneSounds.EnergyballFire'
     FireForce="RocketLauncherFire"
     FireRate=4.000000
     ProjectileClass=Class'DEKRPG209D.RuneEnergyballProj'
     AmmoPerFire=4
     AmmoClass=Class'DEKRPG209D.RuneEnergyAmmo'
}
