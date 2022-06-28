class DEKAutoMachinegunWeapon extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG209E.DEKMachineGunSentinelFire'
     FireModeClass(1)=Class'DEKRPG209E.DEKMachineGunSentinelFire'
     AttachmentClass=Class'DEKRPG209E.DEKMachineGunAttachment'
     ItemName="Auto Assault Sentinel"
}
