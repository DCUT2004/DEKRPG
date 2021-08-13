class DEKHellfireSentinelWeapon extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AG.DEKHellfireSentinelFire'
     FireModeClass(1)=Class'DEKRPG208AG.DEKHellfireSentinelFire'
     AttachmentClass=Class'DEKRPG208AG.DEKHellfireSentinelAttachment'
     ItemName="Hellfire Sentinel"
}
