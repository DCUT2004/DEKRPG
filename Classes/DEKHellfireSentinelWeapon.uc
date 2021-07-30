class DEKHellfireSentinelWeapon extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AC.DEKHellfireSentinelFire'
     FireModeClass(1)=Class'DEKRPG208AC.DEKHellfireSentinelFire'
     AttachmentClass=Class'DEKRPG208AC.DEKHellfireSentinelAttachment'
     ItemName="Hellfire Sentinel"
}
