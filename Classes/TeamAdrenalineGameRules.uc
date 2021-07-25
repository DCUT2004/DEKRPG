class TeamAdrenalineGameRules extends GameRules
	config(UT2004RPG);

var MutTeamAdrenaline TA;
var Pawn TauntPawn;
var config Array < Class < AbilityMaterial > > LowMaterials, MediumMaterials, HighMaterials;
var config int MaterialKillChance, MaterialGameWinChance;	//The chance to unlock a material upon a kill or upon winning game
var config int LowMaterialChance, MediumMaterialChance;
var config float PlayerAdrenPerKill, MonsterAdrenPerHit;

function PostBeginPlay()
{
	SetTimer(1, true);
	Super.PostBeginPlay();
}

function Timer()
{
	local Controller C;
	local GiveItemsInv GInv;
	local int MaterialRankChance;
	
	if (Level.Game.bGameEnded)
	{
		if (TeamInfo(Level.Game.GameReplicationInfo.Winner) != None)
		{
			for (C = Level.ControllerList; C != None; C = C.NextController)
			{
				if (C.PlayerReplicationInfo != None && C.PlayerReplicationInfo.Team == Level.Game.GameReplicationInfo.Winner)
				{
					if (Rand(100) <= MaterialGameWinChance)
					{
						GInv = class'GiveItemsInv'.static.GetGiveItemsInv(C);
						if (GInv != None)
						{
							MaterialRankChance = Rand(100);
							if (MaterialRankChance <= LowMaterialChance)
							{
								GInv.AddMaterial(LowMaterials[RandRange(0, LowMaterials.Length)]);
							}
							else if (MaterialRankChance <= MediumMaterialChance)
							{
								GInv.AddMaterial(MediumMaterials[RandRange(0, MediumMaterials.Length)]);
							}
							else
							{
								GInv.AddMaterial(HighMaterials[RandRange(0, HighMaterials.Length)]);
							}
						}
					}
				}
			}
		}
		else if ( PlayerReplicationInfo(Level.Game.GameReplicationInfo.Winner) != None
			  && Controller(PlayerReplicationInfo(Level.Game.GameReplicationInfo.Winner).Owner) != None )
		{
			if (Rand(100) <= MaterialGameWinChance)
			{
				GInv = class'GiveItemsInv'.static.GetGiveItemsInv(Controller(PlayerReplicationInfo(Level.Game.GameReplicationInfo.Winner).Owner));
				if (GInv != None)
				{
					MaterialRankChance = Rand(100);
					if (MaterialRankChance <= LowMaterialChance)
					{
						GInv.AddMaterial(LowMaterials[RandRange(0, LowMaterials.Length)]);
					}
					else if (MaterialRankChance <= MediumMaterialChance)
					{
						GInv.AddMaterial(MediumMaterials[RandRange(0, MediumMaterials.Length)]);
					}
					else
					{
						GInv.AddMaterial(HighMaterials[RandRange(0, HighMaterials.Length)]);
					}
				}
			}
		}
		Level.Game.Broadcast(self, "Take the time now to purchase any materials before stats are permanently saved.");
		SetTimer(0, False);
	}
}

function int NetDamage( int OriginalDamage, int Damage, pawn injured, pawn instigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType )
{
	local Controller C, NextC;
	local ComboDefenseInv ComboDefense;
	local ComboDefenseGazeInv ComboDefenseGaze;
	local ComboAttackInv ComboAttack;
	//local ComboSharedDamageInv ComboSharedDamage;
	local ComboInaccuracyInv ComboInaccuracy;
	local ComboVampireTargetInv ComboVampireTarget;
	local ComboTauntInv ComboTaunt;
	local int DamageToTauntPawn;
	local int InaccuracyChance;
	local Actor A;
	
	//Add to monster team adrenaline on each hit
	if (TA != None)
	{
		if (injured != None && instigatedBy != None)
		{
			if (instigatedBy.IsA('Monster') && injured.GetTeamNum() != instigatedBy.GetTeamNum() && TA.MonsterTeamAdrenaline < TA.FullAdrenalineMonster)
			{
				AddMonsterTeamAdren();
			}
		}
	}
	
	//Combo effects that modify damage where injured and instigatedBy are not on the same team
	if (instigatedBy != None && injured != None && instigatedBy.GetTeamNum() != injured.GetTeamNum())
	{
		//If the attacker has ComboAttack, modify the damage
		ComboAttack = ComboAttackInv(instigatedBy.FindInventoryType(class'ComboAttackInv'));
		if (ComboAttack != None)
		{
			Damage *= ComboAttack.EffectMultiplier;				
		}
		
		//If the injured has ComboDefense or ComboDefenseGaze, modify the damage
		ComboDefense = ComboDefenseInv(Injured.FindInventoryType(class'ComboDefenseInv'));
		ComboDefenseGaze = ComboDefenseGazeInv(Injured.FindInventoryType(class'ComboDefenseGazeInv'));
		if (ComboDefense != None)
		{
			Damage *= ComboDefense.EffectMultiplier;		
		}
		if (ComboDefenseGaze != None)
		{
			Damage *= ComboDefenseGaze.EffectMultiplier;
		}
		
		//If the attacker has ComboInaccuracy, modify the damage
		ComboInaccuracy = ComboInaccuracyInv(instigatedBy.FindInventoryType(class'ComboInaccuracyInv'));
		if (ComboInaccuracy != None)
		{
			InaccuracyChance = Rand(100);
			if (InaccuracyChance <= ComboInaccuracy.EffectMultiplier)
			{
				Damage = 1;
			}
		}
		//If the injured has ComboSharedDamage, modify the damage
		/*ComboSharedDamage = ComboSharedDamageInv(Injured.FindInventoryType(class'ComboSharedDamageInv'));
		if (ComboSharedDamage != None && Injured.Controller != None && instigatedBy != None && instigatedBy.Controller != None && !instigatedBy.Controller.SameTeamAs(Injured.Controller) && !DamageType.IsA('DamTypeSharedDamage'))
		{
			if (ComboSharedDamage.TotalPlayers > 1)
			{
				ComboSharedDamage.ServeDamage(Damage, instigatedBy);
				Damage /= ComboSharedDamage.TotalPlayers;
			}
			if (Damage <= 0)
				Damage = 1;
		}*/
		
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
	}
	return Super.NetDamage(OriginalDamage, Damage, injured, instigatedBy, HitLocation, Momentum, DamageType);
}

function ScoreKill(Controller Killer, Controller Killed)
{
	local int MaterialRankChance;
	local int RandIndex;
	local GiveItemsInv GInv;
	
	if (TA != None)
	{
		if (Killer != None && Killed != None)
		{
			if (Killer.Pawn != None && Killer.Pawn.Health > 0 && Killed.Pawn != None && Killed.Pawn.IsA('Monster') && Killer.Pawn.GetTeamNum() != Killed.Pawn.GetTeamNum() && !Killed.Pawn.IsA('HealerNali') && !Killed.Pawn.IsA('MissionCow') && TA.PlayerTeamAdrenaline < TA.FullAdrenalinePlayer)
			{
				AddPlayerTeamAdren();
			}
		}
	}
	
	if (Killer != None && Killer.Pawn != None && Rand(100) <= MaterialKillChance)
	{
		MaterialRankChance = Rand(100);
		GInv = class'GiveItemsInv'.static.GetGiveItemsInv(Killer);
		if (GInv != None)
		{
			if (MaterialRankChance <= LowMaterialChance)
			{
				RandIndex = RandRange(0, LowMaterials.Length);
				GInv.AddMaterial(LowMaterials[RandIndex]);
			}
			else if (MaterialRankChance <= MediumMaterialChance)
			{
				RandIndex = RandRange(0, MediumMaterials.Length);
				GInv.AddMaterial(MediumMaterials[RandIndex]);
			}
			else
			{
				RandIndex = RandRange(0, HighMaterials.Length);
				GInv.AddMaterial(HighMaterials[RandIndex]);
			}
		}
	}
	Super.ScoreKill(Killer, Killed);
}

function AddPlayerTeamAdren()
{
	if (TA != None)
	{
		TA.PlayerTeamAdrenaline += PlayerAdrenPerKill;
		if (TA.PlayerTeamAdrenaline > TA.FullAdrenalinePlayer)
			TA.PlayerTeamAdrenaline = TA.FullAdrenalinePlayer;
	}
}

function AddMonsterTeamAdren()
{
	if (TA != None)
	{
		TA.MonsterTeamAdrenaline += MonsterAdrenPerHit;
		if (TA.MonsterTeamAdrenaline > TA.FullAdrenalineMonster)
			TA.MonsterTeamAdrenaline = TA.FullAdrenalineMonster;
	}
}

defaultproperties
{
	PlayerAdrenPerKill=1.00000000
	MonsterAdrenPerHit=0.20000000
	MaterialKillChance=1
	MaterialGameWinChance=10
	LowMaterialChance=80	//80% chance to get a low material
	MediumMaterialChance=95	//15% chance to get a medium material, 5% for a high material
	LowMaterials(0)=Class'DEKRPG208AB.AbilityMaterialLumber'
	LowMaterials(1)=Class'DEKRPG208AB.AbilityMaterialCombatBoots'
	LowMaterials(2)=Class'DEKRPG208AB.AbilityMaterialTarydiumShards'
	LowMaterials(3)=Class'DEKRPG208AB.AbilityMaterialSteel'
	LowMaterials(4)=Class'DEKRPG208AB.AbilityMaterialNaliFruit'
	LowMaterials(5)=Class'DEKRPG208AB.AbilityMaterialGloves'
	MediumMaterials(0)=Class'DEKRPG208AB.AbilityMaterialLeather'
	MediumMaterials(1)=Class'DEKRPG208AB.AbilityMaterialPlatedArmor'
	MediumMaterials(2)=Class'DEKRPG208AB.AbilityMaterialHoneysuckleVine'
	MediumMaterials(3)=Class'DEKRPG208AB.AbilityMaterialEmbers'
	MediumMaterials(4)=Class'DEKRPG208AB.AbilityMaterialArcticSuit'
	HighMaterials(0)=Class'DEKRPG208AB.AbilityMaterialMoss'
	HighMaterials(1)=Class'DEKRPG208AB.AbilityMaterialDust'
	HighMaterials(2)=Class'DEKRPG208AB.AbilityMaterialNanite'
	HighMaterials(3)=Class'DEKRPG208AB.AbilityMaterialPumice'
	HighMaterials(4)=Class'DEKRPG208AB.AbilityMaterialIcicle'
}
