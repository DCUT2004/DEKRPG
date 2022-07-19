class DEKAutoMachinegunWeapon extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG999X.DEKMachineGunSentinelFire'
     FireModeClass(1)=Class'DEKRPG999X.DEKMachineGunSentinelFire'
     AttachmentClass=Class'DEKRPG999X.DEKMachineGunAttachment'
     ItemName="Auto Assault Sentinel"
}
