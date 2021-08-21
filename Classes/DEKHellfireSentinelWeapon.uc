class DEKHellfireSentinelWeapon extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AJ.DEKHellfireSentinelFire'
     FireModeClass(1)=Class'DEKRPG208AJ.DEKHellfireSentinelFire'
     AttachmentClass=Class'DEKRPG208AJ.DEKHellfireSentinelAttachment'
     ItemName="Hellfire Sentinel"
}
