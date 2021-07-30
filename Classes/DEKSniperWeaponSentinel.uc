class DEKSniperWeaponSentinel extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AC.DEKSniperSentinelFire'
     FireModeClass(1)=Class'DEKRPG208AC.DEKSniperSentinelFire'
     AttachmentClass=Class'DEKRPG208AC.DEKSniperSentinelAttachment'
     ItemName="Sniper Sentinel"
}
