class DEKMachineGunWeaponSentinel extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG209F.DEKMachineGunSentinelFire'
     FireModeClass(1)=Class'DEKRPG209F.DEKMachineGunSentinelFire'
     AttachmentClass=Class'DEKRPG209F.DEKMachineGunAttachment'
     ItemName="Assault Sentinel"
}
