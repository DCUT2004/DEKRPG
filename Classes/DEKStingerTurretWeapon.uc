class DEKStingerTurretWeapon extends Weapon_Turret_Minigun;

simulated function ClientStartFire(int mode)
{
	Super(Weapon).ClientStartFire( mode );
}

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG209A.DEKStingerTurretFire'
     FireModeClass(1)=Class'DEKRPG209A.DEKStingerTurretAltFire'
     AttachmentClass=Class'DEKRPG209A.DEKStingerTurretAttachment'
}
