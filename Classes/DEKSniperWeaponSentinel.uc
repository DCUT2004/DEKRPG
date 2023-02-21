class DEKSniperWeaponSentinel extends BaseWeaponSentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG999X.DEKSniperSentinelFire'
     FireModeClass(1)=Class'DEKRPG999X.DEKSniperSentinelFire'
     AttachmentClass=Class'DEKRPG999X.DEKSniperSentinelAttachment'
     ItemName="Sniper Sentinel"
}
