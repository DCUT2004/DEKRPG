class DEKSniperWeaponSentinel extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AH.DEKSniperSentinelFire'
     FireModeClass(1)=Class'DEKRPG208AH.DEKSniperSentinelFire'
     AttachmentClass=Class'DEKRPG208AH.DEKSniperSentinelAttachment'
     ItemName="Sniper Sentinel"
}
