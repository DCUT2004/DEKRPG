class DEKAutoSniperWeapon extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AJ.DEKAutoSniperFire'
     FireModeClass(1)=Class'DEKRPG208AJ.DEKAutoSniperFire'
     AttachmentClass=None
     ItemName="Auto Sniper"
}
