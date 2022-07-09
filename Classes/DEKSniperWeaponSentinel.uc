class DEKSniperWeaponSentinel extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG209F.DEKSniperSentinelFire'
     FireModeClass(1)=Class'DEKRPG209F.DEKSniperSentinelFire'
     AttachmentClass=Class'DEKRPG209F.DEKSniperSentinelAttachment'
     ItemName="Sniper Sentinel"
}
