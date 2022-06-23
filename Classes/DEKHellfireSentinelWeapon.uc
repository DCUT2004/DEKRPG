class DEKHellfireSentinelWeapon extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG209C.DEKHellfireSentinelFire'
     FireModeClass(1)=Class'DEKRPG209C.DEKHellfireSentinelFire'
     AttachmentClass=Class'DEKRPG209C.DEKHellfireSentinelAttachment'
     ItemName="Hellfire Sentinel"
}
