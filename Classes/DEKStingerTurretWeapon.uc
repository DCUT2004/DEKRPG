class DEKStingerTurretWeapon extends Weapon_Turret_Minigun;

simulated function ClientStartFire(int mode)
{
	Super(Weapon).ClientStartFire( mode );
}

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG209F.DEKStingerTurretFire'
     FireModeClass(1)=Class'DEKRPG209F.DEKStingerTurretAltFire'
     AttachmentClass=Class'DEKRPG209F.DEKStingerTurretAttachment'
}
