class DruidMiniTurretWeapon extends Weapon_Turret_Minigun
    config(user)
    HideDropDown
	CacheExempt;
	
simulated function ClientStartFire(int mode)
{
	Super(Weapon).ClientStartFire( mode );
}

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG209A.FM_DruidMiniTurret_Fire'
     FireModeClass(1)=Class'DEKRPG209A.FM_DruidMiniTurret_AltFire'
}
