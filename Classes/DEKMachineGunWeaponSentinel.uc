class DEKMachineGunWeaponSentinel extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AC.DEKMachineGunSentinelFire'
     FireModeClass(1)=Class'DEKRPG208AC.DEKMachineGunSentinelFire'
     AttachmentClass=Class'DEKRPG208AC.DEKMachineGunAttachment'
     ItemName="Assault Sentinel"
}
