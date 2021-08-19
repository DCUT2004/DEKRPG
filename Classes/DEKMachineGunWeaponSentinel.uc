class DEKMachineGunWeaponSentinel extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AH.DEKMachineGunSentinelFire'
     FireModeClass(1)=Class'DEKRPG208AH.DEKMachineGunSentinelFire'
     AttachmentClass=Class'DEKRPG208AH.DEKMachineGunAttachment'
     ItemName="Assault Sentinel"
}
