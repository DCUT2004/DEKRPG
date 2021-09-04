class DEKHellfireSentinelWeapon extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG209A.DEKHellfireSentinelFire'
     FireModeClass(1)=Class'DEKRPG209A.DEKHellfireSentinelFire'
     AttachmentClass=Class'DEKRPG209A.DEKHellfireSentinelAttachment'
     ItemName="Hellfire Sentinel"
}
