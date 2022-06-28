class DEKHellfireSentinelWeapon extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG209E.DEKHellfireSentinelFire'
     FireModeClass(1)=Class'DEKRPG209E.DEKHellfireSentinelFire'
     AttachmentClass=Class'DEKRPG209E.DEKHellfireSentinelAttachment'
     ItemName="Hellfire Sentinel"
}
