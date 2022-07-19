class DEKHellfireSentinelWeapon extends Weapon_Sentinel
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
