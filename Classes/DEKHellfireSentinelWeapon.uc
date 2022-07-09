class DEKHellfireSentinelWeapon extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG209F.DEKHellfireSentinelFire'
     FireModeClass(1)=Class'DEKRPG209F.DEKHellfireSentinelFire'
     AttachmentClass=Class'DEKRPG209F.DEKHellfireSentinelAttachment'
     ItemName="Hellfire Sentinel"
}
