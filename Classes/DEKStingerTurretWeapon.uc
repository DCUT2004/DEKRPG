class DEKStingerTurretWeapon extends Weapon_Turret_Minigun;

simulated function ClientStartFire(int mode)
{
	Super(Weapon).ClientStartFire( mode );
}

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AE.DEKStingerTurretFire'
     FireModeClass(1)=Class'DEKRPG208AE.DEKStingerTurretAltFire'
     AttachmentClass=Class'DEKRPG208AE.DEKStingerTurretAttachment'
}
