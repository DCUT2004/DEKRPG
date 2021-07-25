class DEKHellfireSentinelWeapon extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AB.DEKHellfireSentinelFire'
     FireModeClass(1)=Class'DEKRPG208AB.DEKHellfireSentinelFire'
     AttachmentClass=Class'DEKRPG208AB.DEKHellfireSentinelAttachment'
     ItemName="Hellfire Sentinel"
}
