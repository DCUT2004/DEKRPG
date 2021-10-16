class RuneEnergyballFire extends RuneProjectileFire
	config(DEKWeapons);
	
#exec  AUDIO IMPORT NAME="EnergyballFire" FILE="Sounds\EnergyStealAlt.WAV" GROUP="RuneSounds"

defaultproperties
{
	 AdrenCost=0
     bModeExclusive=False
     FireSound=Sound'DEKRPG209B.RuneSounds.EnergyballFire'
     FireForce="RocketLauncherFire"
     FireRate=4.000000
     ProjectileClass=Class'DEKRPG209B.RuneEnergyballProj'
     AmmoPerFire=1
     AmmoClass=Class'DEKRPG209B.RuneEnergyAmmo'
}
