class DEKSniperWeaponSentinel extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AA.DEKSniperSentinelFire'
     FireModeClass(1)=Class'DEKRPG208AA.DEKSniperSentinelFire'
     AttachmentClass=Class'DEKRPG208AA.DEKSniperSentinelAttachment'
     ItemName="Sniper Sentinel"
}
