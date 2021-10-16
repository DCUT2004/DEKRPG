class DEKHellfireSentinelWeapon extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG209B.DEKHellfireSentinelFire'
     FireModeClass(1)=Class'DEKRPG209B.DEKHellfireSentinelFire'
     AttachmentClass=Class'DEKRPG209B.DEKHellfireSentinelAttachment'
     ItemName="Hellfire Sentinel"
}
