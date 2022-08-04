class ReflectionAddonPowerType extends AddonPowerType;

var config float ReflectionBasePercent;
var config float ReflectionLevelFactor;

function bool CheckReflect( Vector HitLocation, out Vector RefNormal, int Damage )
{
	if(Damage > 0)
	{
		RefNormal=normal(HitLocation-Location);
		if(rand(100) < int((ReflectionLevelFactor^float(TheWeapon.GetModifier()))*ReflectionBasePercent))
		{
			TheWeapon.Instigator.SetOverlayMaterial(PowerOverlay, 1.0, false);
            CheckDeflectMission();
			return true;
		}
	}
	return false;
}

simulated function CheckDeflectMission()
{
	local MissionInvBETA MissionInv;
	
	if (TheWeapon.Instigator == None || TheWeapon.Instigator.Controller == None)
		return;
	MissionInv = class'MissionInvBETA'.static.GetMissionInv(TheWeapon.Instigator.Controller);
	if (MissionInv == None)
		return;
	if (!MissionInv.IsMissionActive("Deflector"))
		return;
	MissionInv.TickMission(MissionInv.GetMissionIndex("Deflector"), 1);
}

defaultproperties
{
	ReflectionBasePercent=30.0
	ReflectionLevelFactor=1.3
	PosName="Reflection"
	ZeroName=""
	NegName=""
	CanHaveZeroModifier=false
	CanHaveNegativeModifier=false
	PowerOverlay=TexEnvMap'VMVehicles-TX.Environments.ReflectionEnv'
	ThisPickupClass=Class'ReflectionAddonPowerPickup'
}

