class DEKMachineGunWeaponSentinel extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AE.DEKMachineGunSentinelFire'
     FireModeClass(1)=Class'DEKRPG208AE.DEKMachineGunSentinelFire'
     AttachmentClass=Class'DEKRPG208AE.DEKMachineGunAttachment'
     ItemName="Assault Sentinel"
}
