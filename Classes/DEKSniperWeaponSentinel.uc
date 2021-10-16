class DEKSniperWeaponSentinel extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG209B.DEKSniperSentinelFire'
     FireModeClass(1)=Class'DEKRPG209B.DEKSniperSentinelFire'
     AttachmentClass=Class'DEKRPG209B.DEKSniperSentinelAttachment'
     ItemName="Sniper Sentinel"
}
