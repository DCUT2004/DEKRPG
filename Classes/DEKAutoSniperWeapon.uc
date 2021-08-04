class DEKAutoSniperWeapon extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AF.DEKAutoSniperFire'
     FireModeClass(1)=Class'DEKRPG208AF.DEKAutoSniperFire'
     AttachmentClass=None
     ItemName="Auto Sniper"
}
