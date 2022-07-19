class DEKAutoSniperWeapon extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG999X.DEKAutoSniperFire'
     FireModeClass(1)=Class'DEKRPG999X.DEKAutoSniperFire'
     AttachmentClass=None
     ItemName="Auto Sniper"
}
