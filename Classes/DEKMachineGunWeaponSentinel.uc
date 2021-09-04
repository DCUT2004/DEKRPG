class DEKMachineGunWeaponSentinel extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG209A.DEKMachineGunSentinelFire'
     FireModeClass(1)=Class'DEKRPG209A.DEKMachineGunSentinelFire'
     AttachmentClass=Class'DEKRPG209A.DEKMachineGunAttachment'
     ItemName="Assault Sentinel"
}
