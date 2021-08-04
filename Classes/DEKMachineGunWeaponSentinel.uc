class DEKMachineGunWeaponSentinel extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AF.DEKMachineGunSentinelFire'
     FireModeClass(1)=Class'DEKRPG208AF.DEKMachineGunSentinelFire'
     AttachmentClass=Class'DEKRPG208AF.DEKMachineGunAttachment'
     ItemName="Assault Sentinel"
}
