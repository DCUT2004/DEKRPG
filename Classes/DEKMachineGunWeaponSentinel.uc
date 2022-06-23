class DEKMachineGunWeaponSentinel extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG209C.DEKMachineGunSentinelFire'
     FireModeClass(1)=Class'DEKRPG209C.DEKMachineGunSentinelFire'
     AttachmentClass=Class'DEKRPG209C.DEKMachineGunAttachment'
     ItemName="Assault Sentinel"
}
