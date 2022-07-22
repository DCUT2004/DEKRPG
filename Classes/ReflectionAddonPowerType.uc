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
	local MissionInv MiInv;
	local Mission1Inv M1Inv;
	local Mission2Inv M2Inv;
	local MIssion3Inv M3Inv;
	
	MiInv = MissionInv(TheWeapon.Instigator.FindInventoryType(class'MissionInv'));
	
	if (TheWeapon.Instigator != None && MiInv != None && !MiInv.DeflectorComplete)
	{
    	M1Inv = Mission1Inv(TheWeapon.Instigator.FindInventoryType(class'Mission1Inv'));
    	M2Inv = Mission2Inv(TheWeapon.Instigator.FindInventoryType(class'Mission2Inv'));
    	M3Inv = Mission3Inv(TheWeapon.Instigator.FindInventoryType(class'Mission3Inv'));
        
		if (M1Inv != None && !M1Inv.Stopped && M1Inv.DeflectorActive)
		{
			M1Inv.MissionCount++;
		}
		if (M2Inv != None && !M2Inv.Stopped && M2Inv.DeflectorActive)
		{
			M2Inv.MissionCount++;
		}
		if (M3Inv != None && !M3Inv.Stopped && M3Inv.DeflectorActive)
		{
			M3Inv.MissionCount++;
		}
	}
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

