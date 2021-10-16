class DEKStingerTurretWeapon extends Weapon_Turret_Minigun;

simulated function ClientStartFire(int mode)
{
	Super(Weapon).ClientStartFire( mode );
}

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG209B.DEKStingerTurretFire'
     FireModeClass(1)=Class'DEKRPG209B.DEKStingerTurretAltFire'
     AttachmentClass=Class'DEKRPG209B.DEKStingerTurretAttachment'
}
