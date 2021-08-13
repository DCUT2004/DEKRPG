class DEKAutoSniperWeapon extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AG.DEKAutoSniperFire'
     FireModeClass(1)=Class'DEKRPG208AG.DEKAutoSniperFire'
     AttachmentClass=None
     ItemName="Auto Sniper"
}
