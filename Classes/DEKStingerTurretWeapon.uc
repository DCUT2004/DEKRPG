class DEKStingerTurretWeapon extends Weapon_Turret_Minigun;

simulated function ClientStartFire(int mode)
{
	Super(Weapon).ClientStartFire( mode );
}

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG999X.DEKStingerTurretFire'
     FireModeClass(1)=Class'DEKRPG999X.DEKStingerTurretAltFire'
     AttachmentClass=Class'DEKRPG999X.DEKStingerTurretAttachment'
}
