class DEKSniperWeaponSentinel extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AB.DEKSniperSentinelFire'
     FireModeClass(1)=Class'DEKRPG208AB.DEKSniperSentinelFire'
     AttachmentClass=Class'DEKRPG208AB.DEKSniperSentinelAttachment'
     ItemName="Sniper Sentinel"
}
