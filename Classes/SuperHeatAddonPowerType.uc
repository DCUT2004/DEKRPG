class SuperHeatAddonPowerType extends AddonPowerType
	config(UT2004RPG);

var config int HeatLifespan;

// DoPowerEffect - use the damage here (e.g. energy vampire etc)
function DoPowerEffect(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	local FireInv FInv;
	local MagicShieldInv MInv;
	local Pawn P;
	local Actor A;
	local IceInv IInv;
	local MissionInv MiInv;
	local Mission1Inv M1Inv;
	local Mission2Inv M2Inv;
	local MIssion3Inv M3Inv;
	local SuperHeatInv SInv;

	Super.DoPowerEffect(Damage, Victim, HitLocation, Momentum, DamageType);

	if (Pawn(Victim) == None)
		return;
	P = Pawn(Victim);

	if (TheWeapon.IsSameTeam(P))
		return;

	if (Damage <= 0 || Victim.isA('Vehicle') || TheWeapon.GetModifier() <= 0)
		return;

	FInv = FireInv(P.FindInventoryType(class'FireInv'));
	if (FInv != None)     // if it is already on fire then we can't ignite it
		return;

	if (P != None && TheWeapon.static.NullCanTriggerPhysics(P))
	{
		MInv = MagicShieldInv(P.FindInventoryType(class'MagicShieldInv'));
		if (MInv == None)
		{
    		SInv = SuperHeatInv(P.FindInventoryType(class'SuperHeatInv'));
    		if (SInv == None)
    		{
    			SInv = spawn(class'SuperHeatInv', P,,, rot(0,0,0));
    			SInv.Modifier = TheWeapon.GetModifier();
    			SInv.LifeSpan = HeatLifespan;
                SInv.RPGRules= TheWeapon.Rules;
                
    			IInv = IceInv(P.FindInventoryType(class'IceInv'));
    			if (IInv != None)
    			{
        				// slightly longer burn effect
        				SInv.Modifier += 1;
        				SInv.LifeSpan += 1;
    			}
    			SInv.GiveTo(P);
                
    			A = P.spawn(class'HeatHitEffect', P,, P.Location, P.Rotation);
    			if (A != None)
    				A.RemoteRole = ROLE_SimulatedProxy;

    			MiInv = MissionInv(TheWeapon.Instigator.FindInventoryType(class'MissionInv'));
				if (TheWeapon.Instigator != None && TheWeapon.Instigator != P && MiInv != None && !MiInv.PyromancerComplete)
				{
        			M1Inv = Mission1Inv(TheWeapon.Instigator.FindInventoryType(class'Mission1Inv'));
        			M2Inv = Mission2Inv(TheWeapon.Instigator.FindInventoryType(class'Mission2Inv'));
        			M3Inv = Mission3Inv(TheWeapon.Instigator.FindInventoryType(class'Mission3Inv'));
    				if (M1Inv != None && !M1Inv.Stopped && M1Inv.PyromancerActive)
    				{
    					M1Inv.MissionCount++;
    					if (TheWeapon.GetModifier() > 2)
    						M1Inv.MissionCount++;
    				}
    				if (M2Inv != None && !M2Inv.Stopped && M2Inv.PyromancerActive)
    				{
    					M2Inv.MissionCount++;
    					if (TheWeapon.GetModifier() > 2)
    						M2Inv.MissionCount++;
    				}
    				if (M3Inv != None && !M3Inv.Stopped && M3Inv.PyromancerActive)
    				{
    					M3Inv.MissionCount++;
    					if (TheWeapon.GetModifier() > 2)
    						M3Inv.MissionCount++;
    				}
	            }
        	}
        	else
        	{
    			SInv.Modifier = TheWeapon.GetModifier();
    			SInv.LifeSpan = HeatLifespan;
        	}
        }
	}
}

function bool CanCoexist( class<AddonPowerType> NewType )
{
	if (!Super.CanCoexist(NewType ))
		return false;

	if (NewType == class'FreezeAddonPowerType')	   	// opposite
		return false;

	if (NewType == class'EarthAddonPowerType')	   	// opposite
		return false;

	if (NewType == class'SuperHeatAddonPowerType')	   	// 2 of them doesn't really work
		return false;

	return true;
}

defaultproperties
{
	DamagePercent=2.0      // since burning hurts
    DamageBonusAgainstEarthMonsters=-0.020000
    DamageBonusAgainstIceMonsters=0.100000
    DamageBonusAgainstFireMonsters=0.000000
    HeatLifespan=4
	PosName="Heat"
	ZeroName=""
	NegName=""
	CanHaveZeroModifier=false
	CanHaveNegativeModifier=false
	AIBonus=0.1
	PowerOverlay=FinalBlend'DEKWeaponsMaster206.fX.SuperHeatFB'
	ThisPickupClass=Class'SuperHeatAddonPowerPickup'
}

