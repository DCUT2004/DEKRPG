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

const COMBO_LEVEL = 90;

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
	local int RandIndex;	//Array indexing
	local GiveItemsInv Inv;
	local Pawn P;
	
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
			if (P != None)
			{
				StatsInv = RPGStatsInv(P.FindInventoryType(Class'RPGStatsInv'));
				if (StatsInv != None && StatsInv.Data.Level >= COMBO_LEVEL)
				{
					Pawns.Insert(0, 1);	//Insert 1 Pawn element at index 0, or the beginning of array. The array is dynamic and will move other elements around
					Pawns[0] = P;	//Set the new element we just inserted to P
					//Do not break here, as we want to loop through all controllers that are eligible to receive the combo
				}
			}
		}
		C = NextC;
	}
	
	//Now choose a random player
	if (Pawns.Length != 0)
	{
		RandIndex = RandRange(0, Pawns.Length);	//Choose a random number between 0 and Pawns.Length
		P = Pawns[RandIndex];
		if (P != None && P.Controller != None)
		{
			Inv = class'GiveItemsInv'.static.GetGiveItemsInv(P.Controller);
			if (Inv != None)
				GrantPlayerCombo(P.Controller, Inv);
		}
	}
	
	
	
	

	/*foreach DynamicActors(class'Controller', C)	//First, let's try human players
	{
		if (C != None && C.PlayerReplicationInfo != None && C.Pawn != None && C.Pawn.Health > 0 && !C.Pawn.IsA('Monster'))
		{
			if (Vehicle(C.Pawn) != None)
				P = Vehicle(C.Pawn).Driver;
			else
				P = C.Pawn;
			if (!C.PlayerReplicationInfo.bBot)	//first, let's try to get a human player
			{
				StatsInv = RPGStatsInv(P.FindInventoryType(Class'RPGStatsInv'));
				if (StatsInv != None && StatsInv.Data.Level >= COMBO_LEVEL)
				{
					Inv = class'GiveItemsInv'.static.GetGiveItemsInv(P.Controller);
					if (Inv != None && Inv.NumCombos < Inv.MaxNumCombos)
					{
						Controllers.Insert(0, 1);
						Controllers[0] = C;
						break;
					}
				}
			}
		}
	}
	if (Controllers.Length == 0)	//No human players found, lets try bots
	{
		foreach DynamicActors(class'Controller', C)	//First, let's try human players
		{
			if (C != None && C.PlayerReplicationInfo != None && C.Pawn != None && C.Pawn.Health > 0 && !C.Pawn.IsA('Monster'))
			{
				if (Vehicle(C.Pawn) != None)
					P = Vehicle(C.Pawn).Driver;
				else
					P = C.Pawn;
				if (C.PlayerReplicationInfo.bBot)
				{
					StatsInv = RPGStatsInv(P.FindInventoryType(Class'RPGStatsInv'));
					if (StatsInv != None && StatsInv.Data.Level >= COMBO_LEVEL)
					{
						Inv = class'GiveItemsInv'.static.GetGiveItemsInv(P.Controller);
						if (Inv != None && Inv.NumCombos < Inv.MaxNumCombos)
						{
							Controllers.Insert(0, 1);
							Controllers[0] = C;
							break;
						}
					}
				}
			}
		}
	}
	
	if (Controllers.length != 0) //We have some human players we can give combos to
	{
		GrantPlayerCombo(Controllers[0], Inv);
	}*/
}

simulated function GrantPlayerCombo(Controller TargetController, GiveItemsInv Inv)
{
	if (Inv.NumCombos < Inv.MaxNumCombos)
	{
		Inv.NumCombos++;
		Level.Game.BroadCast(Self, "Combo given to " $ TargetController.PlayerReplicationInfo.PlayerName $ "!");
		PlayerTeamAdrenaline = 0.000000;
	}
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
			PlayerController(C).ClientPlaySound(Sound'DEKRPG208AF.MonsterComboSound');
}

simulated function AnnounceCombo(int RandIndex)
{
	Level.Game.BroadCast(Self, ComboClass[RandIndex].default.ComboNameMessage $ ComboData[RandIndex].Multiplier $ " for " $ ComboData[RandIndex].Lifespan $ " seconds");
}

defaultproperties
{
	 NumCombos=3
	 MinimumWave=6
	 MinimumMonsters=10
	 FullAdrenalinePlayer=100.000000000
	 FullAdrenalineMonster=100.00000000
     ComboClass(0)=Class'DEKRPG208AF.ComboAttackInv'
     ComboClass(1)=Class'DEKRPG208AF.ComboAttackInv'
     ComboClass(2)=Class'DEKRPG208AF.ComboDefenseInv'
     ComboClass(3)=Class'DEKRPG208AF.ComboDefenseInv'
     ComboClass(4)=Class'DEKRPG208AF.ComboFreezeInv'
     ComboClass(5)=Class'DEKRPG208AF.ComboHeatInv'
     ComboClass(6)=Class'DEKRPG208AF.ComboRegenerateInv'
     ComboClass(7)=Class'DEKRPG208AF.ComboHealStopInv'
     ComboClass(8)=Class'DEKRPG208AF.ComboHealthMaxInv'
     ComboClass(9)=Class'DEKRPG208AF.ComboInaccuracyInv'
     ComboClass(10)=Class'DEKRPG208AF.ComboMisfortuneInv'
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
