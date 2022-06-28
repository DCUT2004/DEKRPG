class DEKAutoMachinegunWeapon extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG209D.DEKMachineGunSentinelFire'
     FireModeClass(1)=Class'DEKRPG209D.DEKMachineGunSentinelFire'
     AttachmentClass=Class'DEKRPG209D.DEKMachineGunAttachment'
     ItemName="Auto Assault Sentinel"
}
