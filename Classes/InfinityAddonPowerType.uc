class InfinityAddonPowerType extends AddonPowerType
	config(UT2004RPG);

static function bool AllowedFor(Weapon W)
{
	// check if superweapon 
	if (W == None)
		return false;

	if (  W.default.FireModeClass[0] != None && W.default.FireModeClass[0].default.AmmoClass != None
		&& class'MutUT2004RPG'.static.IsSuperWeaponAmmo(W.default.FireModeClass[0].default.AmmoClass) )
		return false;

	if(instr(caps(W), "LINK") > -1)
		return false;	
	if(instr(caps(W), "MINE LAYER") > -1)
		return false;		
	if(instr(caps(W), "UTILITY RIFLE") > -1)
		return false;	
	if(instr(caps(W), "PROASS") > -1)
		return false;		
	if(instr(caps(W), "GRAVITY") > -1)
		return false;	
	if(instr(caps(W), "SHIELD") > -1)
		return false;	
	if(instr(caps(W), "SINGULARITY") > -1)
		return false;
	if(instr(caps(W), "RAIL") > -1)
		return false;
	if(instr(caps(W), "BLOOD") > -1)
		return false;
	if(instr(caps(W), "SOUL") > -1)
		return false;
	if(instr(caps(W), "PHANTOM") > -1)
		return false;

	return true;
}

function bool CanCoexist( class<AddonPowerType> NewType )
{
	if (!Super.CanCoexist(NewType ))
		return false;

	if (NewType == class'InfinityAddonPowerType')	   	// no point having 2 of them
		return false;

	return true;
}

simulated event WeaponTick(float dt)
{
	TheWeapon.MaxOutAmmo();
}

defaultproperties
{
	PosName="Infinity"
	ZeroName="Infinity"
	NegName="Infinity"
	CanHaveZeroModifier=true
	CanHaveNegativeModifier=true
	AIBonus=0.05
	PowerOverlay=Shader'XGameShaders.BRShaders.BombIconRS'
	ThisPickupClass=Class'InfinityAddonPowerPickup'
}

