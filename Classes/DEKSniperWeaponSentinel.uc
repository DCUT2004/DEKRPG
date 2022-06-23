class DEKSniperWeaponSentinel extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG209C.DEKSniperSentinelFire'
     FireModeClass(1)=Class'DEKRPG209C.DEKSniperSentinelFire'
     AttachmentClass=Class'DEKRPG209C.DEKSniperSentinelAttachment'
     ItemName="Sniper Sentinel"
}
