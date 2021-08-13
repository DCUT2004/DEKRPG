class DEKMachineGunWeaponSentinel extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AG.DEKMachineGunSentinelFire'
     FireModeClass(1)=Class'DEKRPG208AG.DEKMachineGunSentinelFire'
     AttachmentClass=Class'DEKRPG208AG.DEKMachineGunAttachment'
     ItemName="Assault Sentinel"
}
