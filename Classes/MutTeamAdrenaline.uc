class MutTeamAdrenaline extends Mutator
	config(UT2004RPG);
	
var Invasion Invasion;

var config float FullAdrenalinePlayer, FullAdrenalineMonster;
var float PlayerTeamAdrenaline, MonsterTeamAdrenaline;
var config int NumCombos;	//The number of buffs and ailments the monster team can apply
var config int MinimumWave;		//The wave number when monsters can start applying buffs and ailments
var config int MinimumMonsters;	//The number of monsters before a monster team combo can be activated

#exec  AUDIO IMPORT NAME="MonsterComboSound" FILE="Sounds\MonsterComboSound.WAV" GROUP="ComboSounds"

struct ComboInfo
{
	var int Lifespan;
	var bool bBuff;
	var float Multiplier;
	var bool bDispellable;
	var bool bAll;
	var bool bMulti;
	var bool bSingle;
};
var config Array <ComboInfo> ComboData;
var config Array < class < ComboEffectInv > > ComboClass;	//The full list of buffs and ailments available to monsters to use

replication
{
	reliable if (Role == ROLE_Authority)
		PlayerTeamAdrenaline, MonsterTeamAdrenaline;
}

simulated function PostBeginPlay()
{
	local TeamAdrenalineGameRules G;
	
	Invasion = Invasion(Level.Game);
	if (Invasion != None)
	{
		G = Spawn(class'TeamAdrenalineGameRules');
		G.TA = Self;
		if ( Level.Game.GameRulesModifiers == None )
			Level.Game.GameRulesModifiers = G;
		else    
			Level.Game.GameRulesModifiers.AddGameRules(G);
		PlayerTeamAdrenaline = 0.000000;
		MonsterTeamAdrenaline = 0.000000;
		SetTimer(10, True);
	}
	Super.PostBeginPlay();
}

simulated function ModifyPlayer(Pawn Other)
{
	local ComboInv Combo;
	
	if (Other != None)
	{
		Combo = ComboInv(Other.FindInventoryType(class'ComboInv'));
		if (Combo == None)
		{
			Combo = Other.Spawn(class'ComboInv');
			Combo.GiveTo(Other);
		}
	}
	Super.ModifyPlayer(Other);
}

simulated function Timer()
{
	//Handle player team and monster team adrenaline
	if (PlayerTeamAdrenaline >= FullAdrenalinePlayer)
	{
		FindPlayer();
	}
	if (MonsterTeamAdrenaline >= FullAdrenalineMonster && Invasion.WaveNum >= MinimumWave && Invasion.bWaveInProgress && Invasion.NumMonsters >= MinimumMonsters)
	{
		GrantMonsterCombo();
	}
}

simulated function FindPlayer()
{
	local RPGStatsInv StatsInv;
	local Controller C, NextC;
	local Array<Pawn> Pawns;
	local int Index, Count, x;
	local GiveItemsInv Inv;
	local Pawn P;
	local bool bComboGiven, bIsAM;
	
	C = Level.ControllerList;
	Pawns.Length = 0;
	
	
	//First, create an Array of player Pawns that are eligible to receive a combo
	while (C != None)
	{
		NextC = C.NextController;
		if (C != None && C.PlayerReplicationInfo != None && C.Pawn != None && C.Pawn.Health > 0 && !C.Pawn.IsA('Monster') && !C.PlayerReplicationInfo.bBot)
		{
			if (Vehicle(C.Pawn) != None)
				P = Vehicle(C.Pawn).Driver;
			else
				P = C.Pawn;

			StatsInv = RPGStatsInv(P.FindInventoryType(Class'RPGStatsInv'));
			if (StatsInv != None)
			{
				//Check if player has bought a combo ability. If no combo ability, don't bother
				bIsAM = false;
				for (x = 0; x < StatsInv.Data.Abilities.Length; x++)
				{
					//Check for AM class
					if ( StatsInv.Data.Abilities[x] == Class'ClassAdrenalineMaster' )
						bIsAM = true;
						
					//If player has a combo ability and is AM, give a combo. Non-AMs, add them to pool of players
					if ( ClassIsChildOf(StatsInv.Data.Abilities[x] , Class'AbilityCombo' ) )
					{
						if (bIsAM)																
							GrantPlayerCombo(C, class'GiveItemsInv'.static.GetGiveItemsInv(C));
						else
						{
							Pawns.Insert(0, 1);	//Insert 1 Pawn element at index 0, or the beginning of array. The array is dynamic and will move other elements around
							Pawns[0] = P;	//Set the new element we just inserted to P
						}
						break;
					}
				}
			}
		}
		C = NextC;
	}
	
	//Now choose a random non-AM player
	if (Pawns.Length != 0)
	{
		Index = Rand(Pawns.Length);	//Choose a random number between 0 and Pawns.Length-1
		bComboGiven = false;
		Count = 0;
		do
		{
			Count++;
			P = Pawns[Index];
			if (P != None && P.Controller != None)
			{
				Inv = class'GiveItemsInv'.static.GetGiveItemsInv(P.Controller);
				bComboGiven = GrantPlayerCombo(P.Controller, Inv);
				if (!bComboGiven)	//This player already has the max allowable combos held. Find another player
				{
					Index++;
					if (Index >= Pawns.Length)
						Index = 0;
				}
			}
		}
		until (bComboGiven || Count >= 20);		//Possible all players have max combos, so break upon a counter

	}
}

simulated function bool GrantPlayerCombo(Controller TargetController, GiveItemsInv Inv)
{
	if (Inv != None && Inv.NumCombos < Inv.MaxNumCombos)
	{
		Inv.NumCombos++;
		Level.Game.BroadCast(Self, "Combo given to " $ TargetController.PlayerReplicationInfo.PlayerName $ "!");
		PlayerTeamAdrenaline = 0.000000;
		return true;
	}
	return false;
}

function GrantMonsterCombo()
{
	local Controller C, NextC;
	local int x;
	local ComboInv Inv;
	local int RandIndex;
	local int IntMultiplier;
	
	Level.Game.BroadCast(Self, "Monster combo!");
	
	for (x = 0; x < NumCombos; x++)
	{
		RandIndex = RandRange(0, ComboClass.Length);
		C = Level.ControllerList;
		while (C != None)
		{
			NextC = C.NextController;
			if (C != None && C.Pawn != None && C.Pawn.Health > 0)
			{
				if (C.Pawn.IsA('Monster') && FriendlyMonsterInv(C.Pawn.FindInventoryType(class'FriendlyMonsterInv')) == None)
				{
					Inv = ComboInv(C.Pawn.FindInventoryType(class'ComboInv'));
					if (Inv != None)
					{
						if (ComboData[RandIndex].bBuff)
							Inv.AddBuff(C.Pawn, ComboData[RandIndex].bAll, ComboData[RandIndex].bMulti, ComboData[RandIndex].bSingle, ComboData[RandIndex].Lifespan, ComboClass[RandIndex], ComboData[RandIndex].Multiplier, ComboData[RandIndex].bDispellable);
						else
						{
							Inv.AddAilment(C.Pawn, ComboData[RandIndex].bAll, ComboData[RandIndex].bMulti, ComboData[RandIndex].bSingle, ComboData[RandIndex].Lifespan, ComboClass[RandIndex], ComboData[RandIndex].Multiplier, ComboData[RandIndex].bDispellable);
							break;	//One monster will give all players the ailment. Break out of the controller loop here once that's finished and go to the next buff/ailment
						}
					}
				}
			}
			C = NextC;
			
		}
		IntMultiplier = ComboData[RandIndex].Multiplier;
		AnnounceCombo(RandIndex);
	}
	PlayMonsterComboSound();
	MonsterTeamAdrenaline = 0.000000;
}

simulated function PlayMonsterComboSound()
{
	local Controller C;
	
	for ( C = Level.ControllerList; C != None; C = C.NextController )
		if (C != None && C.IsA('PlayerController'))
			PlayerController(C).ClientPlaySound(Sound'DEKRPG999X.MonsterComboSound');
}

simulated function AnnounceCombo(int RandIndex)
{
	Level.Game.BroadCast(Self, ComboClass[RandIndex].default.ComboNameMessage $ ComboData[RandIndex].Multiplier $ " for " $ ComboData[RandIndex].Lifespan $ " seconds");
}

defaultproperties
{
	 NumCombos=3
	 MinimumWave=1
	 MinimumMonsters=5
	 FullAdrenalinePlayer=100.000000000
	 FullAdrenalineMonster=100.00000000
     ComboClass(0)=Class'DEKRPG999X.ComboAttackInv'
     ComboClass(1)=Class'DEKRPG999X.ComboAttackInv'
     ComboClass(2)=Class'DEKRPG999X.ComboDefenseInv'
     ComboClass(3)=Class'DEKRPG999X.ComboDefenseInv'
     ComboClass(4)=Class'DEKRPG999X.ComboFreezeInv'
     ComboClass(5)=Class'DEKRPG999X.ComboHeatInv'
     ComboClass(6)=Class'DEKRPG999X.ComboRegenerateInv'
     ComboClass(7)=Class'DEKRPG999X.ComboHealStopInv'
     ComboClass(8)=Class'DEKRPG999X.ComboHealthMaxInv'
     ComboClass(9)=Class'DEKRPG999X.ComboInaccuracyInv'
     ComboClass(10)=Class'DEKRPG999X.ComboMisfortuneInv'
     ComboData(0)=(LifeSpan=25,Multiplier=1.200000,bDispellable=True,bSingle=True,bBuff=True)
     ComboData(1)=(LifeSpan=25,Multiplier=0.800000,bDispellable=True,bAll=True,bBuff=False)
     ComboData(2)=(LifeSpan=25,Multiplier=0.800000,bDispellable=True,bSingle=True,bBuff=True)
     ComboData(3)=(LifeSpan=25,Multiplier=1.200000,bDispellable=True,bAll=True,bBuff=False)
     ComboData(4)=(LifeSpan=25,Multiplier=4.000000,bDispellable=True,bAll=True,bBuff=False)
     ComboData(5)=(LifeSpan=10,Multiplier=2.000000,bDispellable=True,bAll=True,bBuff=False)
     ComboData(6)=(LifeSpan=25,Multiplier=10.000000,bDispellable=True,bSingle=True,bBuff=True)
     ComboData(7)=(LifeSpan=25,Multiplier=1.000000,bDispellable=True,bAll=True,bBuff=False)
     ComboData(8)=(LifeSpan=25,Multiplier=0.800000,bDispellable=True,bAll=True,bBuff=False)
     ComboData(9)=(LifeSpan=25,Multiplier=30.000000,bDispellable=True,bAll=True,bBuff=False)
     ComboData(10)=(LifeSpan=25,Multiplier=300.000000,bDispellable=True,bAll=True,bBuff=False)
     bAddToServerPackages=True
     GroupName="TeamAdrenaline"
     FriendlyName="Team Combos"
     Description="Team combos provides combos for the player team and monster team in Invasion. When team adrenaline is full, players and monsters can perform combos."
     bAlwaysRelevant=True
}
