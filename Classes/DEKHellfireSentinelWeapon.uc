class DEKHellfireSentinelWeapon extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AH.DEKHellfireSentinelFire'
     FireModeClass(1)=Class'DEKRPG208AH.DEKHellfireSentinelFire'
     AttachmentClass=Class'DEKRPG208AH.DEKHellfireSentinelAttachment'
     ItemName="Hellfire Sentinel"
}
