class DEKSniperWeaponSentinel extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AD.DEKSniperSentinelFire'
     FireModeClass(1)=Class'DEKRPG208AD.DEKSniperSentinelFire'
     AttachmentClass=Class'DEKRPG208AD.DEKSniperSentinelAttachment'
     ItemName="Sniper Sentinel"
}
