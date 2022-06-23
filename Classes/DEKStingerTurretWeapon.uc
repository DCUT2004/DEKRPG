class DEKStingerTurretWeapon extends Weapon_Turret_Minigun;

simulated function ClientStartFire(int mode)
{
	Super(Weapon).ClientStartFire( mode );
}

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG209C.DEKStingerTurretFire'
     FireModeClass(1)=Class'DEKRPG209C.DEKStingerTurretAltFire'
     AttachmentClass=Class'DEKRPG209C.DEKStingerTurretAttachment'
}
