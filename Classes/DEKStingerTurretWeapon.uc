class DEKStingerTurretWeapon extends Weapon_Turret_Minigun;

simulated function ClientStartFire(int mode)
{
	Super(Weapon).ClientStartFire( mode );
}

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG209D.DEKStingerTurretFire'
     FireModeClass(1)=Class'DEKRPG209D.DEKStingerTurretAltFire'
     AttachmentClass=Class'DEKRPG209D.DEKStingerTurretAttachment'
}
