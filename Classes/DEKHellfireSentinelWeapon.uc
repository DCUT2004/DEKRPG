class DEKHellfireSentinelWeapon extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AD.DEKHellfireSentinelFire'
     FireModeClass(1)=Class'DEKRPG208AD.DEKHellfireSentinelFire'
     AttachmentClass=Class'DEKRPG208AD.DEKHellfireSentinelAttachment'
     ItemName="Hellfire Sentinel"
}
