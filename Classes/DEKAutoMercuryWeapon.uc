class DEKAutoMercuryWeapon extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG208AD.DEKAutoMercuryFire'
     FireModeClass(1)=Class'DEKRPG208AD.DEKAutoMercuryFire'
     AttachmentClass=None
     ItemName="Auto Mercury"
}
