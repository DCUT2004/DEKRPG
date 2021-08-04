class DEKHellfireSentinelWeapon extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AF.DEKHellfireSentinelFire'
     FireModeClass(1)=Class'DEKRPG208AF.DEKHellfireSentinelFire'
     AttachmentClass=Class'DEKRPG208AF.DEKHellfireSentinelAttachment'
     ItemName="Hellfire Sentinel"
}
