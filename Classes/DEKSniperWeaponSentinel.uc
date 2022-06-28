class DEKSniperWeaponSentinel extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG209D.DEKSniperSentinelFire'
     FireModeClass(1)=Class'DEKRPG209D.DEKSniperSentinelFire'
     AttachmentClass=Class'DEKRPG209D.DEKSniperSentinelAttachment'
     ItemName="Sniper Sentinel"
}
