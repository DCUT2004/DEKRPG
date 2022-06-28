//ComboInv handles all the buffs and debuffs applied to players and monsters
//Given to players via RPGClass
//Given to Boss monsters via self
class ComboInv extends Inventory;

//AddAilment() searches for the correct enemies of Instigator to apply the combo to
function AddAilment(Pawn Instigator, bool All, bool Multi, bool Single, float Lifespan, class<ComboEffectInv> ComboClass, float EffectMultiplier, bool bDispellable, optional Pawn Target)
{
	local Controller C, NextC;
	local RPGStatsInv StatsInv;
	local int HighestLevel;
	local Pawn Player1, Player2, Player3;	//for bMulti
	
	C = Level.ControllerList;
	HighestLevel = 0;
	Player1 = None;
	Player2 = None;
	Player3 = None;
	
	if (Instigator != None && Instigator.Controller != None)
	{
		if (All)
		{
			while (C != None)
			{
				NextC = C.NextController;
				if (C != None && C.Pawn != None && C.Pawn.Health > 0 && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow') && !ClassIsChildOf(C.Pawn.Class, class'SMPNaliRabbit')
				&& ((TeamGame(Level.Game) != None && C.Pawn.GetTeamNum() != Instigator.GetTeamNum())
				|| (TeamGame(Level.Game) == None && C.Pawn != Instigator)))
				{
					DoEffect(C.Pawn, Lifespan, ComboClass, EffectMultiplier, bDispellable, Instigator);
				}
				C = NextC;
			}
		}
		else if (Multi)		//Only monsters will have bMulti. Selects the 3 top-level players
		{
			while (C != None)
			{
				NextC = C.NextController;
				if (C != None && C.Pawn != None && C.Pawn.Health > 0 && !C.Pawn.IsA('Monster') && C.Pawn != Player2 && C.Pawn != Player3)
				{
					StatsInv = RPGStatsInv(C.Pawn.FindInventoryType(class'RPGStatsInv'));
					if (StatsInv != None)
					{
						if (StatsInv.DataObject.Level > HighestLevel)
						{
							HighestLevel = StatsInv.DataObject.Level;
							Player1 = C.Pawn;
						}
					}
				}
				C = NextC;
			}
			C = Level.ControllerList;
			HighestLevel = 0;
			while (C != None)
			{
				NextC = C.NextController;
				if (C != None && C.Pawn != None && C.Pawn.Health > 0 && !C.Pawn.IsA('Monster') && C.Pawn != Player1 && C.Pawn != Player3)
				{
					StatsInv = RPGStatsInv(C.Pawn.FindInventoryType(class'RPGStatsInv'));
					if (StatsInv != None)
					{
						if (StatsInv.DataObject.Level > HighestLevel)
						{
							HighestLevel = StatsInv.DataObject.Level;
							Player2 = C.Pawn;
						}
					}
				}
				C = NextC;
			}
			C = Level.ControllerList;
			HighestLevel = 0;
			while (C != None)
			{
				NextC = C.NextController;
				if (C != None && C.Pawn != None && C.Pawn.Health > 0 && !C.Pawn.IsA('Monster') && C.Pawn != Player2 && C.Pawn != Player1)
				{
					StatsInv = RPGStatsInv(C.Pawn.FindInventoryType(class'RPGStatsInv'));
					if (StatsInv != None)
					{
						if (StatsInv.DataObject.Level > HighestLevel)
						{
							HighestLevel = StatsInv.DataObject.Level;
							Player3 = C.Pawn;
						}
					}
				}
				C = NextC;
			}
			
			if (Player1 != None)
			{
				DoEffect(Player1, Lifespan, ComboClass, EffectMultiplier, bDispellable, Instigator);
			}
			if (Player2 != None)
			{
				DoEffect(Player2, Lifespan, ComboClass, EffectMultiplier, bDispellable, Instigator);
			}
			if (Player3 != None)
			{
				DoEffect(Player3, Lifespan, ComboClass, EffectMultiplier, bDispellable, Instigator);
			}
		}
		else if (Single)	//Only monsters will have bSingle. Adds ailment to highest level player
		{
			Player1 = FindSinglePawn(Instigator);
			if (Player1 != None)
			{
				DoEffect(Player1, Lifespan, ComboClass, EffectMultiplier, bDispellable, Instigator);
			}
		}
		else if (Target != None)
		{
			DoEffect(Target, Lifespan, ComboClass, EffectMultiplier, bDispellable, Instigator);
		}
	}
}

//AddBuff() searches for the correct teammates of Instigator to apply the combo to
function AddBuff(Pawn Instigator, bool All, bool Multi, bool Single, float Lifespan, class<ComboEffectInv> ComboClass, float EffectMultiplier, bool bDispellable)
{
	local Controller C, NextC;
	
	C = Level.ControllerList;
	
	if (All)
	{	
		while (C != None)
		{
			NextC = C.NextController;
			if (C != None && C.Pawn != None && C.Pawn.Health > 0 && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow') && !ClassIsChildOf(C.Pawn.Class, class'SMPNaliRabbit')
			&& ((TeamGame(Level.Game) != None && C.Pawn.GetTeamNum() == Instigator.GetTeamNum())
			|| (TeamGame(Level.Game) == None && C.Pawn == Instigator)))
			{
				DoEffect(C.Pawn, Lifespan, ComboClass, EffectMultiplier, bDispellable);
			}
			C = NextC;
		}
	}
	else if (Single)	//Give Buff to Instigator
	{
		DoEffect(Instigator, Lifespan, ComboClass, EffectMultiplier, bDispellable);
	}
}

//This function adds the buff/ailment to the target Pawn P
//Enemy is the pawn giving the buff/ailment
function DoEffect(Pawn P, float Lifespan, class<ComboEffectInv> ComboClass, float EffectMultiplier, bool bDispellable, optional Pawn Enemy)
{
	local ComboEffectInv Inv;
	
	if (P != None)
	{
		if (P.IsA('Vehicle'))
			P = Vehicle(P).Driver;
		if (P != None)
		{
			Inv = ComboEffectInv(P.FindInventoryType(ComboClass));
			if (Inv == None)
			{
				Inv = P.Spawn(ComboClass);
				Inv.Lifespan = Lifespan;
				Inv.EffectMultiplier = EffectMultiplier;
				Inv.bDispellable = bDispellable;
				if (Enemy != None)
					Inv.Enemy = Enemy;
				Inv.GiveTo(P);
			}
			else
			{
				Inv.ApplyCounter += 1.0;
				Inv.Lifespan = Lifespan;	//Reset the timer
				Inv.bDispellable = bDispellable;	//The same buff/ailment could be applied, but this time the Dispellable value changed
				if (Inv.EffectMultiplier > 1.0 && EffectMultiplier > 1.0)
					Inv.EffectMultiplier += ((abs(1.0-EffectMultiplier))/Inv.ApplyCounter);			//If the current multiplier is > 1 and we are applying a multiplier > 1, then add a diminished multiplier
				if (Inv.EffectMultiplier < 1.0 && EffectMultiplier < 1.0)
					Inv.EffectMultiplier -= ((abs(1.0-EffectMultiplier))/Inv.ApplyCounter);				//If the current multiplier is < 1 and we are applying a multiplier < 1, then subtract a diminished multiplier
				if (Inv.EffectMultiplier > 1.0 && EffectMultiplier < 1.0)
					Inv.EffectMultiplier -= abs(1.0 - EffectMultiplier);				//If the current multiplier is > 1 and we are applying a multiplier < 1, then subract the multiplier from the current multiplier
				if (Inv.EffectMultiplier < 1.0 && EffectMultiplier > 1.0)
					Inv.EffectMultiplier += abs(1.0-EffectMultiplier);				//If the current multiplier is < 1 and we are applying a multiplier > 1, then multiplier to the current multiplier
				if (Inv.EffectMultiplier < 0.0)
					Inv.EffectMultiplier = 0.1;										//Last resort to stop EffectMultiplier from reaching 0
				//For some combos, they apply a buff or ailment at an instantaneous moment rather than over time. Call GiveTo() again
				Inv.GiveTo(P);
			}
		}
	}
}

//DispelAilment() searches for all dispellable ailments on the Instigator and its teammates and deletes them
function DispelAilment(Pawn Instigator, bool bAll, bool bSingle)
{
	local Controller C, NextC;
	local Inventory Inv, TempInv;
	local ComboEffectInv CInv;
	local int Count;

	C = Level.ControllerList;
	
	if (bAll)
	{
		while (C != None)
		{
			NextC = C.NextController;
			if (C != None && C.Pawn != None && C.Pawn.Health > 0 && Instigator != None &&
			(Instigator.IsA('Monster') && ((C.Pawn.IsA('Monster') && FriendlyMonsterInv(C.Pawn.FindInventoryType(class'FriendlyMonsterInv')) == None))) ||
			(!Instigator.IsA('Monster') && Instigator.GetTeamNum() == C.Pawn.GetTeamNum()))
			{
				Count = 0;
				for( Inv=C.Pawn.Inventory; Inv!=None && Count < 1000; Inv=Inv.Inventory )
				{
					if (TempInv != None)	//Loop automatically iterates to next slot in inventory. This will set Inv back to the temp pointer
					{
						Inv = TempInv;
						TempInv = None;
					}
					if (ClassIsChildOf(Inv.Class, class'ComboEffectInv'))
					{
						CInv = ComboEffectInv(Inv);
						if (CInv != None && !CInv.bBuff && CInv.bDispellable)
						{
							TempInv = Inv.Inventory;
							CInv.Destroy();
							Inv = TempInv;
						}
					}
					else if (Inv.IsA('FreezeInv') || Inv.IsA('DruidPoisonInv') || Inv.IsA('SuperHeatInv'))
					{
						TempInv = Inv.Inventory;
						Inv.Destroy();
						Inv = TempInv;
					}
					Count++;
				}
			}
			C = NextC;
		}
	}
	else if (bSingle)
	{
		if (Instigator != None)
		{
			for( Inv=Inventory; Inv!=None && Count < 1000; Inv=Inv.Inventory )
			{
				if (ClassIsChildOf(Inv.Class, class'ComboEffectInv'))
				{
					CInv = ComboEffectInv(Inv);
					if (CInv != None && !CInv.bBuff && CInv.bDispellable)
						CInv.Destroy();
				}
				Count++;
			}
		}
	}
}

//DispelBuff() searches for all dispellable buffs on Instigator's enemies and deletes them
function DispelBuff(Pawn Instigator, bool bAll, bool bMulti, bool bSingle)
{
	local Controller C, NextC;
	local Inventory Inv;
	local ComboEffectInv CInv;
	local int Count;
	local Pawn Player1, Player2, Player3;
	local RPGStatsInv StatsInv;
	local int HighestLevel;

	C = Level.ControllerList;
	Count = 0;
	
	if (bAll)
	{
		while (C != None)
		{
			NextC = C.NextController;
			if (C != None && C.Pawn != None && C.Pawn.Health > 0 &&
			(Instigator.IsA('Monster') && ((C.Pawn.IsA('Monster') && FriendlyMonsterInv(C.Pawn.FindInventoryType(class'FriendlyMonsterInv')) != None) || !C.Pawn.IsA('Monster'))) ||
			(!Instigator.IsA('Monster') && !C.SameTeamAs(Instigator.Controller) && !C.Pawn.IsA('Vehicle') && FriendlyMonsterInv(C.Pawn.FindInventoryType(class'FriendlyMonsterInv')) == None) )
			{
				for( Inv=Inventory; Inv!=None && Count < 1000; Inv=Inv.Inventory )
				{
					if (ClassIsChildOf(Inv.Class, class'ComboEffectInv'))
					{
						CInv = ComboEffectInv(Inv);
						if (CInv != None && CInv.bBuff && CInv.bDispellable)
							CInv.Destroy();
					}
					Count++;
				}
			}
			C = NextC;
		}
	}
	else if (bMulti)
	{
		while (C != None)
		{
			NextC = C.NextController;
			if (C != None && C.Pawn != None && C.Pawn.Health > 0 && !C.Pawn.IsA('Monster'))
			{
				StatsInv = RPGStatsInv(C.Pawn.FindInventoryType(class'RPGStatsInv'));
				if (StatsInv != None)
				{
					if (StatsInv.DataObject.Level > HighestLevel)
					{
						HighestLevel = StatsInv.DataObject.Level;
						Player1 = C.Pawn;
					}
				}
			}
			C = NextC;
		}
		while (C != None)
		{
			NextC = C.NextController;
			if (C != None && C.Pawn != None && C.Pawn.Health > 0 && !C.Pawn.IsA('Monster') && C.Pawn != Player1)
			{
				StatsInv = RPGStatsInv(C.Pawn.FindInventoryType(class'RPGStatsInv'));
				if (StatsInv != None)
				{
					if (StatsInv.DataObject.Level > HighestLevel)
					{
						HighestLevel = StatsInv.DataObject.Level;
						Player2 = C.Pawn;
					}
				}
			}
			C = NextC;
		}
		while (C != None)
		{
			NextC = C.NextController;
			if (C != None && C.Pawn != None && C.Pawn.Health > 0 && !C.Pawn.IsA('Monster') && C.Pawn != Player1 && C.Pawn != Player2)
			{
				StatsInv = RPGStatsInv(C.Pawn.FindInventoryType(class'RPGStatsInv'));
				if (StatsInv != None)
				{
					if (StatsInv.DataObject.Level > HighestLevel)
					{
						HighestLevel = StatsInv.DataObject.Level;
						Player3 = C.Pawn;
					}
				}
			}
			C = NextC;
		}
		if (Player1 != None)
		{
			for( Inv=Inventory; Inv!=None && Count < 1000; Inv=Inv.Inventory )
			{
				if (ClassIsChildOf(Inv.Class, class'ComboEffectInv'))
				{
					CInv = ComboEffectInv(Inv);
					if (CInv != None && CInv.bBuff && CInv.bDispellable)
						CInv.Destroy();
				}
				Count++;
			}
		}
		if (Player2 != None)
		{
			for( Inv=Inventory; Inv!=None && Count < 1000; Inv=Inv.Inventory )
			{
				if (ClassIsChildOf(Inv.Class, class'ComboEffectInv'))
				{
					CInv = ComboEffectInv(Inv);
					if (CInv != None && CInv.bBuff && CInv.bDispellable)
						CInv.Destroy();
				}
				Count++;
			}
		}
		if (Player3 != None)
		{
			for( Inv=Inventory; Inv!=None && Count < 1000; Inv=Inv.Inventory )
			{
				if (ClassIsChildOf(Inv.Class, class'ComboEffectInv'))
				{
					CInv = ComboEffectInv(Inv);
					if (CInv != None && CInv.bBuff && CInv.bDispellable)
						CInv.Destroy();
				}
				Count++;
			}
		}
	}
	else if (bSingle)
	{
		while (C != None)
		{
			NextC = C.NextController;
			if (C != None && C.Pawn != None && C.Pawn.Health > 0 && !C.Pawn.IsA('Monster'))
			{
				StatsInv = RPGStatsInv(C.Pawn.FindInventoryType(class'RPGStatsInv'));
				if (StatsInv != None)
				{
					if (StatsInv.DataObject.Level > HighestLevel)
					{
						HighestLevel = StatsInv.DataObject.Level;
						Player1 = C.Pawn;
					}
				}
			}
			C = NextC;
		}
		if (Player1 != None)
		{
			for( Inv=Inventory; Inv!=None && Count < 1000; Inv=Inv.Inventory )
			{
				if (ClassIsChildOf(Inv.Class, class'ComboEffectInv'))
				{
					CInv = ComboEffectInv(Inv);
					if (CInv != None && CInv.bBuff && CInv.bDispellable)
						CInv.Destroy();
				}
				Count++;
			}
		}
	}
}

function SpawnPortal(Pawn Instigator, int SkillLevel, float MonsterLifespan)
{
	local FriendlyPortal Portal;
	
	if (Instigator != None)
	{
		Portal = Instigator.Spawn(class'FriendlyPortal',Instigator,,Instigator.Location);
		if (Portal != None)
		{
			Portal.Instigator = Instigator;
			Portal.SkillLevel = SkillLevel;
			Portal.MonsterLifespan = MonsterLifespan;
		}
	}
}

function Monster SummonMinion(Pawn Instigator, class<Monster> MinionClass, int Health, float HealthPercent, bool Taunt, float MonsterLifespan, optional int ComboLifespan, optional float EffectMultiplier, optional bool Dispellable)
{
	local Monster M;
	local int x;
	local ComboInv CInv;
	local DEKFriendlyMonsterController C;
	local FriendlyMonsterInv FriendlyInv;
	local Inventory Inv;
	local RPGStatsInv StatsInv;
	
	for (x = 0; x < 10; x++)
	{
		if (M == None)
			M = Instigator.spawn(MinionClass, Instigator,, getSpawnLocation(Instigator, MinionClass));
		if (M != None)
			break;
	}
	if (M != None)
	{
		//Check to see if a player spawned the minion. If so, make it a friendly monster
		if (!Instigator.IsA('Monster'))
		{
			if (M.Controller != None)
				M.Controller.Destroy();
			FriendlyInv = M.Spawn(class'FriendlyMonsterInv');
			FriendlyInv.MasterPRI = Instigator.PlayerReplicationInfo;
			FriendlyInv.Skill = 7;
			FriendlyInv.GiveTo(M);				
			FriendlyInv.MonsterPointsInv = None;
			Spawn(class'FriendlyPortalDeres',M,,M.Location);
			Spawn(class'FriendlyPortalDeresEffect',M,,M.Location);
			M.Lifespan = MonsterLifespan;
			
			C = spawn(class'DEKFriendlyMonsterController');
			if(C == None)
			{
				FriendlyInv.Destroy();
				M.Destroy();
				return None;
			}
			C.Possess(M); //do not call InitializeSkill before this line.
			C.SetMaster(Instigator.Controller);
			C.InitializeSkill(7);
			
			//allow Instigator's abilities to affect the monster
			for (Inv = Instigator.Controller.Inventory; Inv != None; Inv = Inv.Inventory)
			{
				StatsInv = RPGStatsInv(Inv);
				if (StatsInv != None)
					break;
			}
			if (StatsInv != None) //this should always be the case
			{
				for (x = 0; x < StatsInv.Data.Abilities.length; x++)
				{
					if(ClassIsChildOf(StatsInv.Data.Abilities[x], class'MonsterAbility'))
						class<MonsterAbility>(StatsInv.Data.Abilities[x]).static.ModifyMonster(M, StatsInv.Data.AbilityLevels[x]);
					else
						StatsInv.Data.Abilities[x].static.ModifyPawn(M, StatsInv.Data.AbilityLevels[x]);
				}

				if (C.Inventory == None) //should never be the case.
					C.Inventory = StatsInv;
				else
				{
					for (Inv = C.Inventory; Inv.Inventory != None; Inv = Inv.Inventory)
					{}
					Inv.Inventory = StatsInv;
				}
			}
		}
		M.Health = (Health*HealthPercent);
		M.HealthMax = Health;
		if (Taunt)
		{
			CInv = ComboInv(M.FindInventoryType(class'ComboInv'));
			if (CInv == None)
			{
				CInv = M.Spawn(class'ComboInv');
				CInv.GiveTo(M);
			}
			CInv.AddBuff(M, False, False, True, ComboLifespan, class'DEKRPG209D.ComboTauntInv', EffectMultiplier, Dispellable);
		}
		return M;
	}
	else
		return None;
}

function vector getSpawnLocation(Pawn Instigator, Class<Monster> ChosenMonster)
{
	local float Dist, BestDist;
	local vector SpawnLocation;
	local NavigationPoint N, BestDest;

	BestDist = 50000.f;
	for (N = Level.NavigationPointList; N != None; N = N.NextNavigationPoint)
	{
		Dist = VSize(N.Location - Instigator.Location);
		if (Dist < BestDist && Dist > ChosenMonster.default.CollisionRadius * 4)
		{
			BestDest = N;
			BestDist = VSize(N.Location - Instigator.Location);
		}
	}

	if (BestDest != None)
		SpawnLocation = BestDest.Location + (ChosenMonster.default.CollisionHeight - BestDest.CollisionHeight) * vect(0,0,1);
	else
		SpawnLocation = Instigator.Location + ChosenMonster.default.CollisionHeight * vect(0,0,1.5); //is this why monsters spawn on heads?

	return SpawnLocation;	
}

//ComboDamage() used by boss monsters
function ComboDamage(int ComboDamage, bool bComboDamageAll, bool bComboDamageMulti, bool bComboDamageSingle, class<DamageType> ComboDamageType, optional class<xEmitter> EffectEmitter, optional bool bSound)
{
	local Actor A;
	local Controller C, NextC;
	local RPGStatsInv StatsInv;
	local int HighestLevel;
	local Pawn Player1, Player2, Player3;
	
	C = Level.ControllerList;
	HighestLevel = 0;
	Player1 = None;
	Player2 = None;
	Player3 = None;
	
	if (bComboDamageAll)
	{
		while (C != None)
		{
			NextC = C.NextController;
			if (C != None && C.Pawn != None && C.Pawn.Health > 0 && Instigator != None && C.Pawn.GetTeamNum() != Instigator.GetTeamNum() && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow') && !ClassIsChildOf(C.Pawn.Class, class'SMPNaliRabbit'))
			{
				C.Pawn.TakeDamage(ComboDamage, Instigator, C.Pawn.Location, vect(0,0,0), ComboDamageType);
				A = C.Pawn.Spawn(EffectEmitter,,, C.Pawn.Location);
				if (A != None)
					A.RemoteRole = ROLE_SimulatedProxy;
				if (bSound)
					C.Pawn.PlaySound(sound'WeaponSounds.BExplosion3',,2.5*C.Pawn.TransientSoundVolume,,C.Pawn.TransientSoundRadius);
				C.Pawn.ReceiveLocalizedMessage(MessageClass, ComboDamage, None, None, Class);
			}
			C = NextC;
		}
	}
	else if (bComboDamageMulti)
	{
		while (C != None)
		{
			NextC = C.NextController;
			if (C != None && C.Pawn != None && C.Pawn.Health > 0 && !C.Pawn.IsA('Monster') && C.Pawn != Player2 && C.Pawn != Player3 && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow') && !ClassIsChildOf(C.Pawn.Class, class'SMPNaliRabbit'))
			{
				StatsInv = RPGStatsInv(C.Pawn.FindInventoryType(class'RPGStatsInv'));
				if (StatsInv != None)
				{
					if (StatsInv.DataObject.Level > HighestLevel)
					{
						HighestLevel = StatsInv.DataObject.Level;
						Player1 = C.Pawn;
					}
				}
			}
			C = NextC;
		}
		C = Level.ControllerList;
		HighestLevel = 0;
		while (C != None)
		{
			NextC = C.NextController;
			if (C != None && C.Pawn != None && C.Pawn.Health > 0 && !C.Pawn.IsA('Monster') && C.Pawn != Player1 && C.Pawn != Player3 && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow') && !ClassIsChildOf(C.Pawn.Class, class'SMPNaliRabbit'))
			{
				StatsInv = RPGStatsInv(C.Pawn.FindInventoryType(class'RPGStatsInv'));
				if (StatsInv != None)
				{
					if (StatsInv.DataObject.Level > HighestLevel)
					{
						HighestLevel = StatsInv.DataObject.Level;
						Player2 = C.Pawn;
					}
				}
			}
			C = NextC;
		}
		C = Level.ControllerList;
		HighestLevel = 0;
		while (C != None)
		{
			NextC = C.NextController;
			if (C != None && C.Pawn != None && C.Pawn.Health > 0 && !C.Pawn.IsA('Monster') && C.Pawn != Player2 && C.Pawn != Player1 && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow') && !ClassIsChildOf(C.Pawn.Class, class'SMPNaliRabbit'))
			{
				StatsInv = RPGStatsInv(C.Pawn.FindInventoryType(class'RPGStatsInv'));
				if (StatsInv != None)
				{
					if (StatsInv.DataObject.Level > HighestLevel)
					{
						HighestLevel = StatsInv.DataObject.Level;
						Player3 = C.Pawn;
					}
				}
			}
			C = NextC;
		}
		
		if (Player1 != None)
		{
			Player1.TakeDamage(ComboDamage, Instigator, Player1.Location, vect(0,0,0), ComboDamageType);
			A = Player1.Spawn(EffectEmitter,,, Player1.Location);
			if (A != None)
				A.RemoteRole = ROLE_SimulatedProxy;
			if (bSound)
				Player1.PlaySound(sound'WeaponSounds.BExplosion3',,2.5*Player1.TransientSoundVolume,,Player1.TransientSoundRadius);
			Player1.ReceiveLocalizedMessage(MessageClass, ComboDamage, None, None, Class);			
		}
		if (Player2 != None)
		{
			Player2.TakeDamage(ComboDamage, Instigator, Player2.Location, vect(0,0,0), ComboDamageType);
			A = Player2.Spawn(EffectEmitter,,, Player2.Location);
			if (A != None)
				A.RemoteRole = ROLE_SimulatedProxy;
			if (bSound)
				Player2.PlaySound(sound'WeaponSounds.BExplosion3',,2.5*Player2.TransientSoundVolume,,Player2.TransientSoundRadius);
			Player2.ReceiveLocalizedMessage(MessageClass, ComboDamage, None, None, Class);			
		}
		if (Player3 != None)
		{
			Player3.TakeDamage(ComboDamage, Instigator, Player3.Location, vect(0,0,0), ComboDamageType);
			A = Player3.Spawn(EffectEmitter,,, Player3.Location);
			if (A != None)
				A.RemoteRole = ROLE_SimulatedProxy;
			if (bSound)
				Player3.PlaySound(sound'WeaponSounds.BExplosion3',,2.5*Player3.TransientSoundVolume,,Player3.TransientSoundRadius);
			Player3.ReceiveLocalizedMessage(MessageClass, ComboDamage, None, None, Class);			
		}
	}
	else if (bComboDamageSingle)
	{
		Player1 = FindSinglePawn(Instigator);
		if (Player1 != None)
		{
			Player1.TakeDamage(ComboDamage, Instigator, Player1.Location, vect(0,0,0), ComboDamageType);
			A = Player1.Spawn(EffectEmitter,,, Player1.Location);
			if (A != None)
				A.RemoteRole = ROLE_SimulatedProxy;
			if (bSound)
				Player1.PlaySound(sound'WeaponSounds.BExplosion3',,2.5*Player1.TransientSoundVolume,,Player1.TransientSoundRadius);
			Player1.ReceiveLocalizedMessage(MessageClass, ComboDamage, None, None, Class);			
		}
	}
}

function int StealAdrenaline(Pawn Instigator, bool bAll, bool bMulti, bool bSingle, float StealPercentage)
{
	local int AdrenalineStealAmount, TotalAdrenalineStealAmount;
	local Controller C, NextC;
	local RPGStatsInv StatsInv;
	local int HighestLevel;
	local Pawn Player1, Player2, Player3;
	
	C = Level.ControllerList;
	HighestLevel = 0;
	Player1 = None;
	Player2 = None;
	Player3 = None;
	TotalAdrenalineStealAmount = 0;
	
	if (bAll)
	{
	
		while (C != None)
		{
			NextC = C.NextController;
			if (C != None && C.Pawn != None && C.Pawn.Health > 0
			&& ((TeamGame(Level.Game) != None && C.Pawn.GetTeamNum() != Instigator.GetTeamNum())
			|| (TeamGame(Level.Game) == None && C.Pawn != Instigator)))
			{
				AdrenalineStealAmount = C.Adrenaline*StealPercentage;
				TotalAdrenalineStealAmount += AdrenalineStealAmount;
				C.Adrenaline -= AdrenalineStealAmount;
				if (C.Adrenaline < 0)
					C.Adrenaline = 0;
			}
			C = NextC;
		}
	}
	else if (bMulti)
	{
		while (C != None)
		{
			NextC = C.NextController;
			if (C != None && C.Pawn != None && C.Pawn.Health > 0 && !C.Pawn.IsA('Monster') && C.Pawn != Player2 && C.Pawn != Player3)
			{
				StatsInv = RPGStatsInv(C.Pawn.FindInventoryType(class'RPGStatsInv'));
				if (StatsInv != None)
				{
					if (StatsInv.DataObject.Level > HighestLevel)
					{
						HighestLevel = StatsInv.DataObject.Level;
						Player1 = C.Pawn;
					}
				}
			}
			C = NextC;
		}
		C = Level.ControllerList;
		HighestLevel = 0;
		while (C != None)
		{
			NextC = C.NextController;
			if (C != None && C.Pawn != None && C.Pawn.Health > 0 && !C.Pawn.IsA('Monster') && C.Pawn != Player1 && C.Pawn != Player3)
			{
				StatsInv = RPGStatsInv(C.Pawn.FindInventoryType(class'RPGStatsInv'));
				if (StatsInv != None)
				{
					if (StatsInv.DataObject.Level > HighestLevel)
					{
						HighestLevel = StatsInv.DataObject.Level;
						Player2 = C.Pawn;
					}
				}
			}
			C = NextC;
		}
		C = Level.ControllerList;
		HighestLevel = 0;
		while (C != None)
		{
			NextC = C.NextController;
			if (C != None && C.Pawn != None && C.Pawn.Health > 0 && !C.Pawn.IsA('Monster') && C.Pawn != Player2 && C.Pawn != Player1)
			{
				StatsInv = RPGStatsInv(C.Pawn.FindInventoryType(class'RPGStatsInv'));
				if (StatsInv != None)
				{
					if (StatsInv.DataObject.Level > HighestLevel)
					{
						HighestLevel = StatsInv.DataObject.Level;
						Player3 = C.Pawn;
					}
				}
			}
			C = NextC;
		}
		
		if (Player1 != None && Player1.Controller != None)
		{
			AdrenalineStealAmount = Player1.Controller.Adrenaline*StealPercentage;
			Player1.Controller.Adrenaline -= AdrenalineStealAmount;
			if (Player1.Controller.Adrenaline < 0)
				Player1.Controller.Adrenaline = 0;
			TotalAdrenalineStealAmount += AdrenalineStealAmount;
		}
		if (Player2 != None && Player2.Controller != None)
		{
			AdrenalineStealAmount = Player2.Controller.Adrenaline*StealPercentage;
			Player2.Controller.Adrenaline -= AdrenalineStealAmount;
			if (Player2.Controller.Adrenaline < 0)
				Player2.Controller.Adrenaline = 0;
			TotalAdrenalineStealAmount += AdrenalineStealAmount;
		}
		if (Player3 != None && Player3.Controller != None)
		{
			AdrenalineStealAmount = Player3.Controller.Adrenaline*StealPercentage;
			Player3.Controller.Adrenaline -= AdrenalineStealAmount;
			if (Player3.Controller.Adrenaline < 0)
				Player3.Controller.Adrenaline = 0;	
			TotalAdrenalineStealAmount += AdrenalineStealAmount;
		}
	}
	else if (bSingle)
	{
		Player1 = FindSinglePawn(Instigator);
		if (Player1 != None && Player1.Controller != None)
		{
			AdrenalineStealAmount = Player1.Controller.Adrenaline*StealPercentage;
			Player1.Controller.Adrenaline -= AdrenalineStealAmount;
			if (Player1.Controller.Adrenaline < 0)
				Player1.Controller.Adrenaline = 0;
			TotalAdrenalineStealAmount += AdrenalineStealAmount;
		}
	}
	return TotalAdrenalineStealAmount;
}

function Pawn FindSinglePawn(Pawn Instigator)
{
	local Controller C, NextC;
	local Pawn Player1;
	local int HighestLevel;
	local RPGStatsInv StatsInv;
	
	C = Level.ControllerList;
	while (C != None)
	{
		NextC = C.NextController;
		if (C != None && C.Pawn != None && C.Pawn.Health > 0 && C.Pawn.GetTeamNum() != Instigator.GetTeamNum() && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow') && !ClassIsChildOf(C.Pawn.Class, class'SMPNaliRabbit'))
		{
			//If the caster is not a monster, then find the pawn with the highest health and apply the damage
			if (!Instigator.IsA('Monster'))
			{
				if (C.Pawn.Health > HighestLevel)
				{
					Player1 = C.Pawn;
					HighestLevel = C.Pawn.Health;
				}					
			}
			else
			//Otherwise, if the caster is a monster or anything else(the game for example), find the pawn with the highest level and apply the damage
			{
				StatsInv = RPGStatsInv(C.Pawn.FindInventoryType(class'RPGStatsInv'));
				if (StatsInv != None)
				{
					if (StatsInv.DataObject.Level > HighestLevel)
					{
						HighestLevel = StatsInv.DataObject.Level;
						Player1 = C.Pawn;
					}
				}
			}
		}
		C = NextC;
	}
	if (Player1 != None)
		return Player1;
	return None;
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
		return "Receive " $ Switch $ " damage";
}


defaultproperties
{
	 MessageClass=Class'UnrealGame.StringMessagePlus'
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
