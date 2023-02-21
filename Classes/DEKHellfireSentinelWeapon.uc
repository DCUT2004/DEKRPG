class DEKHellfireSentinelWeapon extends BaseWeaponSentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG999X.DEKHellfireSentinelFire'
     FireModeClass(1)=Class'DEKRPG999X.DEKHellfireSentinelFire'
     AttachmentClass=Class'DEKRPG999X.DEKHellfireSentinelAttachment'
     ItemName="Hellfire Sentinel"
}
