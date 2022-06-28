class DEKHellfireSentinelWeapon extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG209D.DEKHellfireSentinelFire'
     FireModeClass(1)=Class'DEKRPG209D.DEKHellfireSentinelFire'
     AttachmentClass=Class'DEKRPG209D.DEKHellfireSentinelAttachment'
     ItemName="Hellfire Sentinel"
}
