class DEKSniperWeaponSentinel extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AJ.DEKSniperSentinelFire'
     FireModeClass(1)=Class'DEKRPG208AJ.DEKSniperSentinelFire'
     AttachmentClass=Class'DEKRPG208AJ.DEKSniperSentinelAttachment'
     ItemName="Sniper Sentinel"
}
