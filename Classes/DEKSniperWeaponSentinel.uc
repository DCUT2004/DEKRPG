class DEKSniperWeaponSentinel extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG209E.DEKSniperSentinelFire'
     FireModeClass(1)=Class'DEKRPG209E.DEKSniperSentinelFire'
     AttachmentClass=Class'DEKRPG209E.DEKSniperSentinelAttachment'
     ItemName="Sniper Sentinel"
}
