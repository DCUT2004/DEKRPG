class DEKSniperWeaponSentinel extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AG.DEKSniperSentinelFire'
     FireModeClass(1)=Class'DEKRPG208AG.DEKSniperSentinelFire'
     AttachmentClass=Class'DEKRPG208AG.DEKSniperSentinelAttachment'
     ItemName="Sniper Sentinel"
}
