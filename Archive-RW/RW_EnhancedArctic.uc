//Arctic includes healing and freezing.  Based off of WailOfSuicide's RW_SkaarjBane in DWRPG from the Death Warrant Invasion Servers

class RW_EnhancedArctic extends RW_Healer
   HideDropDown
   CacheExempt
	config(UT2004RPG);

var Sound FreezeSound;
var config float IceOnEarthDamageBonus;

static function bool AllowedFor(class<Weapon> Weapon, Pawn Other)
{
	local int x;
	local RPGStatsInv StatsInv;
	
	if(instr(caps(Weapon), "TRANSLAUNCHER") > -1)
		return false;	
	
	if(instr(caps(Weapon), "MERCURY") > -1)
		return false;		

	if ( Weapon.default.FireModeClass[0] != None && Weapon.default.FireModeClass[0].default.AmmoClass != None
	          && class'MutUT2004RPG'.static.IsSuperWeaponAmmo(Weapon.default.FireModeClass[0].default.AmmoClass) )
		return false;

	StatsInv = RPGStatsInv(Other.FindInventoryType(class'RPGStatsInv'));

	for (x = 0; StatsInv != None && x < StatsInv.Data.Abilities.length; x++)
		if (StatsInv.Data.Abilities[x] == class'AbilityMagicVault' && StatsInv.Data.AbilityLevels[x] >= 3)
		return true;

	return false;

}

function AdjustTargetDamage(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	local Pawn P;
	Local Actor A;
	local EarthInv Inv;

	if (!bIdentified)
		Identify();

	if (!class'OneDropRPGWeapon'.static.CheckCorrectDamage(ModifiedWeapon, DamageType))
		return;
	
	P = Pawn(Victim);

	if (Damage > 0)
	{
		if (P != None && P.Health > 0)
		{
			Inv = EarthInv(P.FindInventoryType(class'EarthInv'));
			if (Inv != None)
			{
				Damage *= (1.0 + IceOnEarthDamageBonus* Modifier);
				Momentum *= 1.0 + IceOnEarthDamageBonus * Modifier;
				A = P.spawn(class'IceMercenaryPlasmaHitEffect', P,, P.Location);
				if (A != None)
					A.RemoteRole = ROLE_SimulatedProxy;
			}
			else
			{
				Damage = Max(1, Damage * (1.0 + DamageBonus * Modifier));
				Momentum *= 1.0 + DamageBonus * Modifier;
			}
			Freeze(P);
		}
		
	}
	Super(RPGWeapon).AdjustTargetDamage(Damage, Victim, HitLocation, Momentum, DamageType);	
}

function Freeze(Pawn P)
{
	local FreezeInv Inv;
	local Actor A;
	local MagicShieldInv MInv;
	local MissionInv MiInv;
	local Mission1Inv M1Inv;
	local Mission2Inv M2Inv;
	local MIssion3Inv M3Inv;
	local IceInv IInv;
	
	MInv = MagicShieldInv(P.FindInventoryType(class'MagicShieldInv'));
	MiInv = MissionInv(Instigator.FindInventoryType(class'MissionInv'));
	M1Inv = Mission1Inv(Instigator.FindInventoryType(class'Mission1Inv'));
	M2Inv = Mission2Inv(Instigator.FindInventoryType(class'Mission2Inv'));
	M3Inv = Mission3Inv(Instigator.FindInventoryType(class'Mission3Inv'));
	
	if (P != None && P.Health > 0 && class'RW_Freeze'.static.canTriggerPhysics(P) && (!P.Controller.SameTeamAs(Instigator.Controller) || P == Instigator))
	{
		IInv = IceInv(P.FindInventoryType(class'IceInv'));
		if (IInv != None)
			return;
		if (MInv != None)
			return;
		else
		{		
			Inv = FreezeInv(P.FindInventoryType(class'FreezeInv'));
			//dont add to the time a pawn is already frozen. It just wouldn't be fair.
			if (Inv == None)
			{
				Inv = spawn(class'FreezeInv', P,,, rot(0,0,0));
				Inv.Modifier = Modifier;
				Inv.LifeSpan = Modifier;
				Inv.GiveTo(P);
				if (Instigator != None && Instigator != P && MiInv != None && !MiInv.FrostmancerComplete)
				{
					if (M1Inv != None && !M1Inv.Stopped && M1Inv.FrostmancerActive)
					{
						if (Modifier <= 3)
						{
							M1Inv.MissionCount++;
						}
						else
						{
							M1Inv.MissionCount++;
							M1Inv.MissionCount++;
						}
					}
					if (M2Inv != None && !M2Inv.Stopped && M2Inv.FrostmancerActive)
					{
						if (Modifier <= 3)
						{
							M2Inv.MissionCount++;
						}
						else
						{
							M2Inv.MissionCount++;
							M2Inv.MissionCount++;
						}
					}
					if (M3Inv != None && !M3Inv.Stopped && M3Inv.FrostmancerActive)
					{
						if (Modifier <= 3)
						{
							M3Inv.MissionCount++;
						}
						else
						{
							M3Inv.MissionCount++;
							M3Inv.MissionCount++;
						}
					}
				}
				A = P.spawn(class'DEKEffectArctic', P,, P.Location, P.Rotation); 
				if (A != None)
				{
					A.RemoteRole = ROLE_SimulatedProxy;
						A.PlaySound(FreezeSound,,2.5*P.TransientSoundVolume,,P.TransientSoundRadius);
				}	
			}
		}
		if (!bIdentified)
			Identify();
	}
}

defaultproperties
{
     FreezeSound=Sound'Slaughtersounds.Machinery.Heavy_End'
     IceOnEarthDamageBonus=0.100000
     DamageBonus=0.050000
     HealthBonus=0.02000
     ModifierOverlay=FinalBlend'D-E-K-HoloGramFX.NonWireframe.FunkyStuff_1'
     MinModifier=2
     MaxModifier=7
     PrefixPos="Arctic "
}
