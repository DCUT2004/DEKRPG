class DEKSniperWeaponSentinel extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AE.DEKSniperSentinelFire'
     FireModeClass(1)=Class'DEKRPG208AE.DEKSniperSentinelFire'
     AttachmentClass=Class'DEKRPG208AE.DEKSniperSentinelAttachment'
     ItemName="Sniper Sentinel"
}
