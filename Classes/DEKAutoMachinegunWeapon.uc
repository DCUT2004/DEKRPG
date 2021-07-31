class DEKAutoMachinegunWeapon extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AD.DEKMachineGunSentinelFire'
     FireModeClass(1)=Class'DEKRPG208AD.DEKMachineGunSentinelFire'
     AttachmentClass=Class'DEKRPG208AD.DEKMachineGunAttachment'
     ItemName="Auto Assault Sentinel"
}
