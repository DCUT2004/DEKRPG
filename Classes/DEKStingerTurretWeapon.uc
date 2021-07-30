class DEKStingerTurretWeapon extends Weapon_Turret_Minigun;

simulated function ClientStartFire(int mode)
{
	Super(Weapon).ClientStartFire( mode );
}

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AC.DEKStingerTurretFire'
     FireModeClass(1)=Class'DEKRPG208AC.DEKStingerTurretAltFire'
     AttachmentClass=Class'DEKRPG208AC.DEKStingerTurretAttachment'
}
