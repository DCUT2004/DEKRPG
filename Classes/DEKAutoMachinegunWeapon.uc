class DEKAutoMachinegunWeapon extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG209B.DEKMachineGunSentinelFire'
     FireModeClass(1)=Class'DEKRPG209B.DEKMachineGunSentinelFire'
     AttachmentClass=Class'DEKRPG209B.DEKMachineGunAttachment'
     ItemName="Auto Assault Sentinel"
}
