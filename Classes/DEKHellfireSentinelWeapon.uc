class DEKHellfireSentinelWeapon extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AA.DEKHellfireSentinelFire'
     FireModeClass(1)=Class'DEKRPG208AA.DEKHellfireSentinelFire'
     AttachmentClass=Class'DEKRPG208AA.DEKHellfireSentinelAttachment'
     ItemName="Hellfire Sentinel"
}
