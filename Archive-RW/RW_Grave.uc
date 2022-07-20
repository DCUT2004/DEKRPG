class RW_Grave extends OneDropRPGWeapon
	HideDropDown
	CacheExempt
	config(UT2004RPG);

var config float DamageBonus;
var RPGRules Rules;
var config float BaseChance;
var MutWaveRandomizer Randomizer;

function PostBeginPlay()
{
	local Mutator m;
	
	super.PostBeginPlay();
	
	if (Level.Game != None)
		for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
			if (MutWaveRandomizer(m) != None)
			{
				Randomizer = MutWaveRandomizer(m);
				break;
			}

	CheckRPGRules();
}

function CheckRPGRules()
{
	Local GameRules G;

	if (Level.Game == None)
		return;		//try again later

	for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
	{
		if(G.isA('RPGRules'))
		{
			Rules = RPGRules(G);
			break;
		}
	}

	if(Rules == None)
		Log("SNICKER SNACK WARNING: Unable to find RPGRules in GameRules. EXP will not be properly awarded");
}

static function bool AllowedFor(class<Weapon> Weapon, Pawn Other)
{	
	if ( ClassIsChildOf(Weapon, class'Minigun') || ClassIsChildOf(Weapon, class'Linkgun') || ClassIsChildOf(Weapon, class'RPGLinkgun') || ClassIsChildOf(Weapon, class'AssaultRifle'))
		return true;

	if(instr(caps(string(Weapon)), "UTILITY RIFLE") > -1)//hack for Utility Rifle
		return true;

	return false;
	
}

function NewAdjustTargetDamage(out int Damage, int OriginalDamage, Actor Victim, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
	if(damage > 0)
	{
		if (Damage < (OriginalDamage * class'OneDropRPGWeapon'.default.MinDamagePercent))
			Damage = OriginalDamage * class'OneDropRPGWeapon'.default.MinDamagePercent;
	}

	Super.NewAdjustTargetDamage(Damage, OriginalDamage, Victim, HitLocation, Momentum, DamageType);
}

function AdjustTargetDamage(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	local Actor A;
	local MagicShieldInv MInv;
	local MissionInv MiInv;
	local Mission1Inv M1Inv;
	local Mission2Inv M2Inv;
	local MIssion3Inv M3Inv;
	local bool ValidTarget;
	local int x;
	
	ValidTarget = True;
	MiInv = MissionInv(Instigator.FindInventoryType(class'MissionInv'));
	M1Inv = Mission1Inv(Instigator.FindInventoryType(class'Mission1Inv'));
	M2Inv = Mission2Inv(Instigator.FindInventoryType(class'Mission2Inv'));
	M3Inv = Mission3Inv(Instigator.FindInventoryType(class'Mission3Inv'));

	if (!bIdentified)
		Identify();

	if (!class'OneDropRPGWeapon'.static.CheckCorrectDamage(ModifiedWeapon, DamageType))
		return;

	if(Victim == None)
		return; //nothing to do

	if(damage > 0)
	{
		Damage = Max(1, Damage * (1.0 + DamageBonus * Modifier));
		Momentum *= 1.0 + DamageBonus * Modifier;
	}
	
	if (Victim != None && Pawn(Victim) != None && Pawn(Victim).Health > 0 && Randomizer != None)
	{
		for (x = 0; x < Randomizer.BossMonsterClass.Length; x++)
		{
			if (Pawn(Victim).Class == Randomizer.BossMonsterClass[x])
			{
				ValidTarget = False;
				break;
			}
		}
	}

	MInv = MagicShieldInv(Pawn(Victim).FindInventoryType(class'MagicShieldInv'));
	if (MInv == None && ValidTarget)
	{
		if(Damage > 0 && rand(99) < BaseChance)
		{
			//this is a vorpal hit. Frag them.

			//fire the sound

			if(Victim != None && Victim.isA('Pawn'))
			{
				A = spawn(class'RocketExplosion',,, Instigator.Location);
				if (A != None)
				{
					A.RemoteRole = ROLE_SimulatedProxy;
					A.PlaySound(sound'WeaponSounds.Misc.instagib_rifleshot',,2.5*Instigator.TransientSoundVolume,,Instigator.TransientSoundRadius);
				}
			
				if (Rules == None)
					CheckRPGRules();
				if (Rules != None)
					Rules.AwardEXPForDamage(Instigator.Controller, RPGStatsInv(Instigator.FindInventoryType(class'RPGStatsInv')), Pawn(Victim), Pawn(Victim).Health - 1);   // give the xp

				if(Victim != None)
					Pawn(Victim).Died(Instigator.Controller, DamageType, Victim.Location);
				
				if(Victim != None)
				{
					A = spawn(class'RocketExplosion',,, Victim.Location);
				
					if (A != None)
					{
						A.RemoteRole = ROLE_SimulatedProxy;
					A.PlaySound(sound'WeaponSounds.Misc.instagib_rifleshot',,2.5*Victim.TransientSoundVolume,,Victim.TransientSoundRadius);
					}
				}
				if (Instigator != None && Instigator != Victim && MiInv != None && !MiInv.PopComplete)
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
			}
		}
	}
}

defaultproperties
{
     DamageBonus=0.050000
     BaseChance=0.400000
     ModifierOverlay=FinalBlend'DEKWeaponsMaster206.fX.VORP'
     MinModifier=1
     MaxModifier=6
     AIRatingBonus=0.080000
     PrefixPos="Vorpal "
}
