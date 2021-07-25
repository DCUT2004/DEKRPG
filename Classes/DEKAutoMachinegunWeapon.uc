class DEKAutoMachinegunWeapon extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AB.DEKMachineGunSentinelFire'
     FireModeClass(1)=Class'DEKRPG208AB.DEKMachineGunSentinelFire'
     AttachmentClass=Class'DEKRPG208AB.DEKMachineGunAttachment'
     ItemName="Auto Assault Sentinel"
}
