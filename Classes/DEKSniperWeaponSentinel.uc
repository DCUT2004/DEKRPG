class DEKSniperWeaponSentinel extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG209A.DEKSniperSentinelFire'
     FireModeClass(1)=Class'DEKRPG209A.DEKSniperSentinelFire'
     AttachmentClass=Class'DEKRPG209A.DEKSniperSentinelAttachment'
     ItemName="Sniper Sentinel"
}
