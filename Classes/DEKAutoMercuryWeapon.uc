class DEKAutoMercuryWeapon extends Weapon_Sentinel
    config(user)
    HideDropDown
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG209A.DEKAutoMercuryFire'
     FireModeClass(1)=Class'DEKRPG209A.DEKAutoMercuryFire'
     AttachmentClass=None
     ItemName="Auto Mercury"
}
