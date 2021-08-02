class DEKHellfireSentinelWeapon extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AE.DEKHellfireSentinelFire'
     FireModeClass(1)=Class'DEKRPG208AE.DEKHellfireSentinelFire'
     AttachmentClass=Class'DEKRPG208AE.DEKHellfireSentinelAttachment'
     ItemName="Hellfire Sentinel"
}
