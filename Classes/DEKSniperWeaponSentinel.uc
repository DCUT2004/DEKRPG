class DEKSniperWeaponSentinel extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AF.DEKSniperSentinelFire'
     FireModeClass(1)=Class'DEKRPG208AF.DEKSniperSentinelFire'
     AttachmentClass=Class'DEKRPG208AF.DEKSniperSentinelAttachment'
     ItemName="Sniper Sentinel"
}
