class DEKMachineGunWeaponSentinel extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AJ.DEKMachineGunSentinelFire'
     FireModeClass(1)=Class'DEKRPG208AJ.DEKMachineGunSentinelFire'
     AttachmentClass=Class'DEKRPG208AJ.DEKMachineGunAttachment'
     ItemName="Assault Sentinel"
}
