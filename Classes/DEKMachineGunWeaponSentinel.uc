class DEKMachineGunWeaponSentinel extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AA.DEKMachineGunSentinelFire'
     FireModeClass(1)=Class'DEKRPG208AA.DEKMachineGunSentinelFire'
     AttachmentClass=Class'DEKRPG208AA.DEKMachineGunAttachment'
     ItemName="Assault Sentinel"
}
