class RW_SolarPower extends RW_EnhancedInfinity
   HideDropDown
   CacheExempt
   config(UT2004RPG);
   
var RPGRules RPGRules;
var config int HeatLifespan;
var config float FireOnIceDamageBonus;

function PostBeginPlay()
{
	Local GameRules G;
	super.PostBeginPlay();
	for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
	{
		if(G.isA('RPGRules'))
		{
			RPGRules = RPGRules(G);
			break;
		}
	}

	if(RPGRules == None)
		Log("WARNING: Unable to find RPGRules in GameRules. EXP will not be properly awarded");
}

static function bool AllowedFor(class<Weapon> Weapon, Pawn Other)
{
	local int x;
	local RPGStatsInv StatsInv;
	
	if ( Weapon.default.FireModeClass[0] != None && Weapon.default.FireModeClass[0].default.AmmoClass != None
	          && class'MutUT2004RPG'.static.IsSuperWeaponAmmo(Weapon.default.FireModeClass[0].default.AmmoClass) )
		return false;

	if(instr(caps(Weapon), "LINK") > -1)
		return false;	
	if(instr(caps(Weapon), "MINE LAYER") > -1)
		return false;		
	if(instr(caps(Weapon), "UTILITY RIFLE") > -1)
		return false;	
	if(instr(caps(Weapon), "PROASS") > -1)
		return false;		
	if(instr(caps(Weapon), "GRAVITY") > -1)
		return false;	
	if(instr(caps(Weapon), "SHIELD") > -1)
		return false;	
	if(instr(caps(Weapon), "SINGULARITY") > -1)
		return false;
	if(instr(caps(Weapon), "RAIL GUN") > -1)
		return false;
		
	StatsInv = RPGStatsInv(Other.FindInventoryType(class'RPGStatsInv'));

	for (x = 0; StatsInv != None && x < StatsInv.Data.Abilities.length; x++)
		if (StatsInv.Data.Abilities[x] == class'AbilityMagicVault' && StatsInv.Data.AbilityLevels[x] >= 3)
		return true;

	return false;
}

simulated function bool StartFire(int Mode)
{
	if (!bIdentified && Role == ROLE_Authority)
		Identify();

	return Super.StartFire(Mode);
}

function bool ConsumeAmmo(int Mode, float Load, bool bAmountNeededIsMax)
{
	if (!bIdentified)
		Identify();

	return true;
}

simulated function WeaponTick(float dt)
{
	MaxOutAmmo();

	Super.WeaponTick(dt);
}

simulated function int MaxAmmo(int mode)
{
	if (bNoAmmoInstances && HolderStatsInv != None)
		return (ModifiedWeapon.MaxAmmo(mode) * (1.0 + 0.01 * HolderStatsInv.Data.AmmoMax));

	return ModifiedWeapon.MaxAmmo(mode);
}

function AdjustTargetDamage(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	local Pawn P;
	Local Actor A;
	local IceInv Inv;

	if (!bIdentified)
		Identify();

	if (!class'OneDropRPGWeapon'.static.CheckCorrectDamage(ModifiedWeapon, DamageType))
		return;
	
	P = Pawn(Victim);

	if (Damage > 0)
	{
		if (P != None && P.Health > 0)
		{
			Inv = IceInv(P.FindInventoryType(class'IceInv'));
			if (Inv != None)
			{
				Damage *= (1.0 + FireOnIceDamageBonus* Modifier);
				Momentum *= 1.0 + FireOnIceDamageBonus * Modifier;
				A = P.spawn(class'FireMercenaryPlasmaHitEffect', P,, P.Location);
				if (A != None)
					A.RemoteRole = ROLE_SimulatedProxy;
			}
			else
			{
				Damage = Max(1, Damage * (1.0 + DamageBonus * Modifier));
				Momentum *= 1.0 + DamageBonus * Modifier;
			}
			Burn(P);
		}
		
	}
}

function Burn(Pawn P)
{
	local SuperHeatInv Inv;
	local MagicShieldInv MInv;
	local MissionInv MiInv;
	local Mission1Inv M1Inv;
	local Mission2Inv M2Inv;
	local MIssion3Inv M3Inv;
	local FireInv FInv;
	
	MInv = MagicShieldInv(P.FindInventoryType(class'MagicShieldInv'));
	MiInv = MissionInv(Instigator.FindInventoryType(class'MissionInv'));
	M1Inv = Mission1Inv(Instigator.FindInventoryType(class'Mission1Inv'));
	M2Inv = Mission2Inv(Instigator.FindInventoryType(class'Mission2Inv'));
	M3Inv = Mission3Inv(Instigator.FindInventoryType(class'Mission3Inv'));
   
	if (P != None && P.Health > 0 && (!P.Controller.SameTeamAs(Instigator.Controller) || P == Instigator))
	{
		FInv = FireInv(P.FindInventoryType(class'FireInv'));
		if (FInv != None)
			return;
		if (MInv != None)
			return;
		else
		{
			Inv = SuperHeatInv(P.FindInventoryType(class'SuperHeatInv'));
			if (Inv == None)
			{
				Inv = spawn(class'SuperHeatInv', P,,, rot(0,0,0));
				Inv.Modifier = Modifier;
				Inv.LifeSpan = HeatLifespan;
				Inv.RPGRules = RPGRules;
				Inv.GiveTo(P);
				if (Instigator != None && Instigator != P && MiInv != None && !MiInv.PyromancerComplete)
				{
					if (M1Inv != None && !M1Inv.Stopped && M1Inv.PyromancerActive)
					{
						if (Modifier <= 2)
						{
							M1Inv.MissionCount++;
						}
						else
						{
							M1Inv.MissionCount++;
							M1Inv.MissionCount++;
						}
					}
					if (M2Inv != None && !M2Inv.Stopped && M2Inv.PyromancerActive)
					{
						if (Modifier <= 2)
						{
							M2Inv.MissionCount++;
						}
						else
						{
							M2Inv.MissionCount++;
							M2Inv.MissionCount++;
						}
					}
					if (M3Inv != None && !M3Inv.Stopped && M3Inv.PyromancerActive)
					{
						if (Modifier <= 2)
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
			}
			else
			{
				Inv.Modifier = Modifier;
				Inv.LifeSpan = HeatLifespan;
			}
		}
		if (!bIdentified)
			Identify();
	}
}

defaultproperties
{
	 DamageBonus=0.04000000
     HeatLifespan=4
     FireOnIceDamageBonus=0.100000
	 MinModifier=1
     MaxModifier=5
     PostfixPos=" of Solar Power"
     ModifierOverlay=TexPanner'Bastien_02.Lava.01B_PanLava'
}
