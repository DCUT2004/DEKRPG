class TeamAdrenalineGameRules extends GameRules
	config(UT2004RPG);

var Pawn TauntPawn;

var config int MaterialKillChance;	//The chance to unlock a material upon a kill
var config int LowMaterialChance, MediumMaterialChance;
var config float MonsterScoreMultiplier;	//% of the monster's scoring value to add as adrenaline

function int NetDamage( int OriginalDamage, int Damage, pawn injured, pawn instigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType )
{
	local Controller C, NextC;
	local ComboDefenseInv ComboDefense;
	local ComboDefenseGazeInv ComboDefenseGaze;
	local ComboAttackInv ComboAttack;
	local ComboCriticalHitInv ComboCriticalHit;
	//local ComboSharedDamageInv ComboSharedDamage;
	local ComboInaccuracyInv ComboInaccuracy;
	local ComboVampireTargetInv ComboVampireTarget;
	local ComboTauntInv ComboTaunt;
	local int DamageToTauntPawn;
	local int InaccuracyChance;
	local ComboAbilityHealingStrikeInv HealStrike;
	local ComboAbilityTeleStealthInv TeleStealth;
	local ComboAbilityBeastsRevengeInv BeastsRevenge;
	local Actor A;
	
	//Add to monster team adrenaline on each hit
	if (injured != None && instigatedBy != None)
	{
		if (instigatedBy.IsA('Monster') && !injured.IsA('Monster') && !injured.IsA('DruidBlock') && injured.GetTeamNum() != instigatedBy.GetTeamNum())
		{
			class'MutTeamAdrenaline'.static.AddMonsterTeamAdren();
		}
	}
	
	//Combo effects that modify damage where injured and instigatedBy are not on the same team
	if (instigatedBy != None && injured != None && instigatedBy.GetTeamNum() != injured.GetTeamNum())
	{
		//If the attacker has Attack buff/ailment, modify the damage
		ComboAttack = ComboAttackInv(instigatedBy.FindInventoryType(class'ComboAttackInv'));
		if (ComboAttack != None)
			Damage *= ComboAttack.EffectMultiplier;

		//If the injured has BeastsRevenge, accumulate his damage
		//We do this here, before defense buffs/ailments are applied, so the defense buff from Beasts Revenge does not negate the effect
		BeastsRevenge = ComboAbilityBeastsRevengeInv(injured.FindInventoryType(Class'ComboAbilityBeastsRevengeInv'));
		if (BeastsRevenge != None)
			BeastsRevenge.AccumulatedDamage += Damage;			
		
		//If the injured has defense buff/ailment, modify the damage
		ComboDefense = ComboDefenseInv(Injured.FindInventoryType(class'ComboDefenseInv'));
		ComboDefenseGaze = ComboDefenseGazeInv(Injured.FindInventoryType(class'ComboDefenseGazeInv'));
		if (ComboDefense != None)
			Damage *= ComboDefense.EffectMultiplier;		
		if (ComboDefenseGaze != None)
			Damage *= ComboDefenseGaze.EffectMultiplier;
		
		//If the attacker has ComboCriticalHit, double the damage
		ComboCriticalHit = ComboCriticalHitInv(instigatedBy.FindInventoryType(Class'ComboCriticalHitInv'));
		if (ComboCriticalHit != None && DamageType != Class'DamTypeRetaliation' && Rand(100) <= ComboCriticalHit.EffectMultiplier)
		{
			Damage *= 2;
			A = spawn(class'GamblerHitEffect',,, instigatedBy.Location);
			if (A != None)
			{
				A.RemoteRole = ROLE_SimulatedProxy;
				A.PlaySound(sound'GeneralImpacts.Wet.Breakbone_01',,1.1*instigatedBy.TransientSoundVolume,,instigatedBy.TransientSoundRadius);
			}
				
			A = spawn(class'GamblerHitEffect',,, injured.Location);
		
			if (A != None)
			{
				A.RemoteRole = ROLE_SimulatedProxy;
				A.PlaySound(sound'GeneralImpacts.Wet.Breakbone_01',,1.1*injured.TransientSoundVolume,,injured.TransientSoundRadius);
			}
		}
		
		//If the attacker has Blind ailment, add a % chance to set the damage to 1
		ComboInaccuracy = ComboInaccuracyInv(instigatedBy.FindInventoryType(class'ComboInaccuracyInv'));
		if (ComboInaccuracy != None)
		{
			InaccuracyChance = Rand(100);
			if (InaccuracyChance <= ComboInaccuracy.EffectMultiplier)
			{
				Damage = 1;
			}
		}
		
		//If the injured is protected by an ally with Taunt, modify the damage
		//Search for a TauntPawn iff a Taunt Pawn does not exist
		if (TauntPawn == None)
		{
			C = Level.ControllerList;
			while (C != None)
			{
				NextC = C.NextController;
				if (C != None && C.Pawn != None && C.Pawn.Health > 0 && C.SameTeamAs(injured.Controller) && C.Pawn != injured)
				{
					if (ComboTauntInv(C.Pawn.FindInventoryType(class'ComboTauntInv')) != None)
					{
						TauntPawn = C.Pawn;
						break;
					}
				}
				C = NextC;
			}
		}
		if (TauntPawn != None && TauntPawn != injured && TauntPawn.GetTeamNum() == injured.GetTeamNum())
		{
			ComboTaunt = ComboTauntInv(TauntPawn.FindInventoryType(class'ComboTauntInv'));
			if (ComboTaunt != None)
			{
				if (ComboTaunt.EffectMultiplier >= 1.0)
					ComboTaunt.EffectMultiplier = 0.99;
				DamageToTauntPawn = (Damage*ComboTaunt.EffectMultiplier);
				if (DamageToTauntPawn < 1)
					DamageToTauntPawn = 1;
				TauntPawn.TakeDamage(DamageToTauntPawn, instigatedBy, TauntPawn.Location, Vect(0,0,0), class'DamTypeTaunt');
				A = TauntPawn.Spawn(class'EarthHitEffect', TauntPawn,, TauntPawn.Location);
				if (A != None)
					A.RemoteRole = ROLE_SimulatedProxy;
				Damage -= DamageToTauntPawn;
				if (Damage < 1)
					Damage = 1;
			}
		}
		
		//If the injured has ComboVampireTargetInv, heal the instigator
		ComboVampireTarget = ComboVampireTargetInv(Injured.FindInventoryType(class'ComboVampireTargetInv'));
		if (ComboVampireTarget != None)
		{
			instigatedBy.GiveHealth(ComboVampireTarget.EffectMultiplier*Damage, instigatedBy.HealthMax + 50);
		}
		
		//If the instigator used Healing Strike, heal the instigator and his allies
		if (DamageType == class'DamTypeHealingStrike' && instigatedBy != None && instigatedBy.Health > 0)
		{
			HealStrike = ComboAbilityHealingStrikeInv(instigatedBy.FindInventoryType(Class'ComboAbilityHealingStrikeInv'));
			if (HealStrike != None)
			{
				C = Level.ControllerList;
				while (C != None)
				{
					NextC = C.NextController;
					if (C != None && C.Pawn != None && C.Pawn.Health > 0 && C.Pawn.GetTeamNum() == instigatedBy.GetTeamNum())
						C.Pawn.GiveHealth(HealStrike.EffectMultiplier*Damage, C.Pawn.HealthMax);
					C = NextC;
				}
			}
		}
		
		//If the instigator has TeleStealth, accumulate his damage
		TeleStealth = ComboAbilityTeleStealthInv(instigatedBy.FindInventoryType(Class'ComboAbilityTeleStealthInv'));
		if (TeleStealth != None)
			TeleStealth.AccumulatedDamage += Damage;
	}
	return Super.NetDamage(OriginalDamage, Damage, injured, instigatedBy, HitLocation, Momentum, DamageType);
}

function ScoreKill(Controller Killer, Controller Killed)
{
	local int MaterialRankChance;
	local GiveItemsInv GInv;
	local Monster M;
	local MutTeamAdrenaline MutTeamAdren;

	if (Killer != None && Killed != None)
	{
		if (Killer.Pawn != None && Killer.Pawn.Health > 0 && Killed.Pawn != None && Killer.Pawn.GetTeamNum() != Killed.Pawn.GetTeamNum() && !Killed.Pawn.IsA('HealerNali') && !Killed.Pawn.IsA('MissionCow'))
		{
			if (Killed.Pawn != None && Killed.Pawn.IsA('Monster'))
			{
				M = Monster(Killed.Pawn);
				class'MutTeamAdrenaline'.static.AddPlayerTeamAdren(M.ScoringValue * MonsterScoreMultiplier);
			}
			else
				class'MutTeamAdrenaline'.static.AddPlayerTeamAdren(1);
		}
		if (Rand(100) <= MaterialKillChance && Killed.Pawn.IsA('Monster'))		//Quick condition for materials, though not proper (i.e. monster kills a pet)
		{
			GInv = class'GiveItemsInv'.static.GetGiveItemsInv(Killer);
			if (GInv != None)
			{
				MutTeamAdren = Class'MutTeamAdrenaline'.static.GetMutTeamAdrenaline(Level.Game);
				if (MutTeamAdren != None)
				{
					MaterialRankChance = Rand(100);
					if (MaterialRankChance <= LowMaterialChance)
						GInv.AddMaterial(MutTeamAdren.LowMaterials[Rand(MutTeamAdren.LOW_MATERIALS_LENGTH)]);
					else if (MaterialRankChance <= MediumMaterialChance)
						GInv.AddMaterial(MutTeamAdren.MediumMaterials[Rand(MutTeamAdren.MED_MATERIALS_LENGTH)]);
					else
						GInv.AddMaterial(MutTeamAdren.HighMaterials[Rand(MutTeamAdren.HIGH_MATERIALS_LENGTH)]);
				}
			}
		}
	}
	
	Super.ScoreKill(Killer, Killed);
}

defaultproperties
{
	MonsterScoreMultiplier=0.50000000
	MaterialKillChance=1
	LowMaterialChance=80	//80% chance to get a low material
	MediumMaterialChance=95	//15% chance to get a medium material, 5% for a high material
}
