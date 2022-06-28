class DEKAutoSniperWeapon extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG209D.DEKAutoSniperFire'
     FireModeClass(1)=Class'DEKRPG209D.DEKAutoSniperFire'
     AttachmentClass=None
     ItemName="Auto Sniper"
}
