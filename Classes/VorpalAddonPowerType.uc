class VorpalAddonPowerType extends AddonPowerType
	config(UT2004RPG);

var config float VorpalPercent;

static function bool AllowedFor(Weapon W)
{
	if (W == None)
		return false;

	if(instr(caps(string(W)), "AVRIL") > -1)   //hack for vinv avril
		return true;
		
	if(instr(caps(string(W)), "MERCURY") > -1)
		return true;	
	
	if(instr(caps(string(W)), "D-E-K ZAP") > -1)
		return true;	
		
	if(instr(caps(string(W)), "SNIPER") > -1)
		return true;
		
	if(instr(caps(string(W)), "SHOCK") > -1)
		return true;
		
	if(instr(caps(string(W)), "SHIELD GUN") > -1)
		return true;
		
	if(instr(caps(string(W)), "EQUALIZER") > -1)
		return true;

	if(instr(caps(string(W)), "RAIL GUN") > -1)
		return true;
		
	if(instr(caps(string(W)), "BIO") > -1)
		return true;		

	if(instr(caps(string(W)), "MEGABLAST") > -1)
		return false;		

	return false;
}

function DoPowerEffect(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	local int Chance;
	local int iRandom;
	local Pawn P;
	local Actor A;
 	local MagicShieldInv MInv;
	local MissionInv MiInv;
	local Mission1Inv M1Inv;
	local Mission2Inv M2Inv;
	local MIssion3Inv M3Inv;
//    local int x;

	Super.DoPowerEffect(Damage, Victim, HitLocation, Momentum, DamageType);

	P = Pawn(Victim);
	if (P == None)
		return;

	if (TheWeapon.IsSameTeam(P))
		return;		// dont vorpal teammates

    if (P.Health <= 0)
        return;     // no points for killing it if it is already dead
    
//	if (Randomizer != None)
//	{
//		for (x = 0; x < Randomizer.BossMonsterClass.Length; x++)
//		{
//			if (P.Class == Randomizer.BossMonsterClass[x])
//			{
//				return;
//			}
//		}
//	}
    
	MInv = MagicShieldInv(Pawn(Victim).FindInventoryType(class'MagicShieldInv'));
	if (MInv != None)
        return;
        
    if (Damage <= 0)
        return;
        
    if (P.HealthMax > 5000)      // cheap and cheerful don't instagib a Boss
        return;
    
    Chance = int(10*(VorpalPercent * TheWeapon.GetModifier()) +0.01);
	iRandom = rand(999);

	if (Chance >= iRandom)
	{
		//this is a vorpal hit. Frag them.
    	MiInv = MissionInv(TheWeapon.Instigator.FindInventoryType(class'MissionInv'));
    	M1Inv = Mission1Inv(TheWeapon.Instigator.FindInventoryType(class'Mission1Inv'));
    	M2Inv = Mission2Inv(TheWeapon.Instigator.FindInventoryType(class'Mission2Inv'));
    	M3Inv = Mission3Inv(TheWeapon.Instigator.FindInventoryType(class'Mission3Inv'));
		if (TheWeapon.Instigator != None && TheWeapon.Instigator != Victim && MiInv != None && !MiInv.PopComplete)
		{
			if (M1Inv != None && !M1Inv.Stopped && M1Inv.PopActive)
			{
				M1Inv.MissionCount++;
			}
			if (M2Inv != None && !M2Inv.Stopped && M2Inv.PopActive)
			{
				M2Inv.MissionCount++;
			}
			if (M3Inv != None && !M3Inv.Stopped && M3Inv.PopActive)
			{
				M3Inv.MissionCount++;
			}
		}

		//fire the sound
 		if (P != None)
		{
			A = spawn(class'RocketExplosion',,, TheWeapon.Instigator.Location);
			if (A != None)
			{
				A.RemoteRole = ROLE_SimulatedProxy;
				A.PlaySound(sound'WeaponSounds.Misc.instagib_rifleshot',,2.5*TheWeapon.Instigator.TransientSoundVolume,,TheWeapon.Instigator.TransientSoundRadius);
			}

			Damage=10000;
			A = spawn(class'RocketExplosion',,, Victim.Location);
			if (A != None)
			{
				A.RemoteRole = ROLE_SimulatedProxy;
				A.PlaySound(sound'WeaponSounds.Misc.instagib_rifleshot',,2.5*Victim.TransientSoundVolume,,Victim.TransientSoundRadius);
			}
		}
	}
}

defaultproperties
{
	VorpalPercent=1.0
	PosName="Vorpal"
	ZeroName=""
	NegName=""
	CanHaveZeroModifier=false
	CanHaveNegativeModifier=false
	AIBonus=0.1
	PowerOverlay=FinalBlend'DEKWeaponsMaster206.fX.VORP'
	ThisPickupClass=Class'VorpalAddonPowerPickup'
}

