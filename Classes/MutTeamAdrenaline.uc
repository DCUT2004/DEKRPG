class MutTeamAdrenaline extends Mutator
	config(UT2004RPG);
	
var Invasion Invasion;
var MutWaveRandomizer WaveRandomizer;
var config float PlayerTeamAdrenMax, MonsterTeamAdrenMax;
var float PlayerTeamAdrenaline, MonsterTeamAdrenaline;
var config int NumMonsterCombos;		//The number of buffs and ailments the monster team can apply
var config byte MinimumWave;			//The wave number when monsters can start applying buffs and ailments
var config byte MinimumMonsters;		//The number of monsters alive before a monster team combo can be activated
var bool bComboAddedForBossWave;

var config byte MaxCombosNonAM;			//Max number of combos allowed to be held for Non-AMs
var config byte MaxCombosAM;			//Max number of combos allowed to be held for AMs

var config int MinAdrenAmount;			//Minimum adrenaline amount to award on an event
var config float MonsterAdrenPerHit;	//How much adren monster team should receive per hit to a player

var bool bMaterialsRewarded;
const LOW_MATERIALS_LENGTH = 6;
const MED_MATERIALS_LENGTH = 5;
const HIGH_MATERIALS_LENGTH = 5;
var Class<AbilityMaterial> LowMaterials [LOW_MATERIALS_LENGTH];
var Class<AbilityMaterial> MediumMaterials [MED_MATERIALS_LENGTH];
var Class<AbilityMaterial> HighMaterials [HIGH_MATERIALS_LENGTH];
var config int MaterialOnGameWonChance, LowMaterialChance, MediumMaterialChance;

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

static function MutTeamAdrenaline GetMutTeamAdrenaline(GameInfo G)
{
	local Mutator M;
	local MutTeamAdrenaline MutTeamAdren;

	for (M = G.BaseMutator; M != None && MutTeamAdren == None; M = M.NextMutator)
		MutTeamAdren = MutTeamAdrenaline(M);

	return MutTeamAdren;
}

simulated function PostBeginPlay()
{
	local TeamAdrenalineGameRules G;
	local Mutator M;
	
	if (Level.Game != None)
	{
		for (M = Level.Game.BaseMutator; M != None; M = M.NextMutator)
			if (MutWaveRandomizer(M) != None)
			{
				WaveRandomizer = MutWaveRandomizer(M);
				break;
			}
			
		Invasion = Invasion(Level.Game);
		if (Invasion != None)
		{
			G = Spawn(class'TeamAdrenalineGameRules');
			if ( Level.Game.GameRulesModifiers == None )
				Level.Game.GameRulesModifiers = G;
			else    
				Level.Game.GameRulesModifiers.AddGameRules(G);
			default.PlayerTeamAdrenaline = 0.000000;
			default.MonsterTeamAdrenaline = 0.000000;
			SetTimer(10, True);
		}
	}
	bComboAddedForBossWave = false;
	bMaterialsRewarded = false;
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
	if (default.PlayerTeamAdrenaline >= PlayerTeamAdrenMax)
	{
		FindPlayer();
	}
	if (default.MonsterTeamAdrenaline >= MonsterTeamAdrenMax && Invasion.WaveNum >= MinimumWave && Invasion.bWaveInProgress && Invasion.NumMonsters >= MinimumMonsters)
	{
		GrantMonsterCombo();
	}
	//If boss wave, give a combo to everyone
	if (WaveRandomizer != None && WaveRandomizer.BossWaveInitialized && !bComboAddedForBossWave)
	{
		GrantAllPlayersCombo();
		bComboAddedForBossWave = true;
	}
	if (Level.Game.bGameEnded && !bMaterialsRewarded)
		RewardMaterials();
}

static function AddPlayerTeamAdren(float AdrenAmount)
{
	if (AdrenAmount < default.MinAdrenAmount)
		AdrenAmount = default.MinAdrenAmount;
	default.PlayerTeamAdrenaline += FMin(AdrenAmount, default.PlayerTeamAdrenMax - default.PlayerTeamAdrenaline);
}

static function AddMonsterTeamAdren()
{
	default.MonsterTeamAdrenaline += FMin(default.MonsterAdrenPerHit, default.MonsterTeamAdrenMax - default.MonsterTeamAdrenaline);
}

function bool IsAdrenalineMaster(RPGStatsInv StatsInv)
{
	local int x;
	
	if (StatsInv == None)
		return false;
	
	for (x = 0; x < StatsInv.Data.Abilities.Length; x++)
	{
		if (StatsInv.Data.Abilities[x] == Class'ClassAdrenalineMaster')
			return true;
	}
	return false;
}

//Search for a random player to give combo
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
				//Check whether this player is AM or not
				bIsAM = IsAdrenalineMaster(StatsInv);
				
				//Check if player has bought a combo ability. If no combo ability, don't bother
				for (x = 0; x < StatsInv.Data.Abilities.Length; x++)
				{
					//If player has a combo ability and is AM, give a combo. Non-AMs, add them to pool of players
					if ( ClassIsChildOf(StatsInv.Data.Abilities[x] , Class'AbilityCombo' ) )
					{
						if (bIsAM)
							GrantPlayerCombo(C, class'GiveItemsInv'.static.GetGiveItemsInv(C), true, false);
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
				bComboGiven = GrantPlayerCombo(P.Controller, Inv, false, false);
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

//Give a combo to all players
simulated function GrantAllPlayersCombo()
{
	local Controller C, NextC;
	local GiveItemsInv GiveInv;
	local RPGStatsInv StatsInv;
	
	C = Level.ControllerList;
	while (C != None)
	{
		NextC = C.NextController;
		if (C != None && C.PlayerReplicationInfo != None && C.Pawn != None && C.Pawn.Health > 0 && !C.Pawn.IsA('Monster') && !C.PlayerReplicationInfo.bBot)
		{
			GiveInv = class'GiveItemsInv'.static.GetGiveItemsInv(C);
			StatsInv = RPGStatsInv(C.Pawn.FindInventoryType(Class'RPGStatsInv'));
			GrantPlayerCombo(C, GiveInv, IsAdrenalineMaster(StatsInv), true);
		}
		C = NextC;
	}
}

//Adds the actual combo to player
simulated function bool GrantPlayerCombo(Controller TargetController, GiveItemsInv Inv, bool bIsAM, bool bReward)
{
	if (Inv == None)
		return false;
	if (!bIsAM && Inv.NumCombos >= MaxCombosNonAM || bIsAM && Inv.NumCombos >= MaxCombosAM)
		return false;

	Inv.NumCombos++;
	if (!bIsAM)		//Don't want to announce combos for all AMs
		Level.Game.BroadCast(Self, "Combo given to " $ TargetController.PlayerReplicationInfo.PlayerName $ "!");
	if (!bReward)	//If granting combo to player as a reward or as boss wave, don't take off team adren
		default.PlayerTeamAdrenaline = 0.00;
	return true;
}

//Select random buffs and ailments and execute them for monster team
function GrantMonsterCombo()
{
	local Controller C, NextC;
	local int x;
	local ComboInv Inv;
	local int RandIndex;
	
	Level.Game.BroadCast(Self, "Monster combo!");
	
	for (x = 0; x < NumMonsterCombos; x++)
	{
		RandIndex = Rand(ComboClass.Length);
		C = Level.ControllerList;
		while (C != None)
		{
			NextC = C.NextController;
			if (C != None && C.Pawn != None && C.Pawn.Health > 0)
			{
				if (C.Pawn.IsA('Monster') && FriendlyMonsterInv(C.Pawn.FindInventoryType(class'FriendlyMonsterInv')) == None && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow'))
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
		AnnounceCombo(RandIndex);
	}
	PlayMonsterComboSound();
	default.MonsterTeamAdrenaline = 0.00;
}

function RewardMaterials()
{
	local Controller C, NextC;
	local GiveItemsInv GInv;
	local int MaterialRank;
	
	C = Level.ControllerList;
	
	while (C != None)
	{
		NextC = C.NextController;
		
		if (C.PlayerReplicationInfo != None && C.PlayerReplicationInfo.Team == Level.Game.GameReplicationInfo.Winner && Rand(100) <= MaterialOnGameWonChance)
		{
			GInv = class'GiveItemsInv'.static.GetGiveItemsInv(C);
			if (GInv != None)
			{
				MaterialRank = Rand(100);
				if (MaterialRank <= LowMaterialChance)
					GInv.AddMaterial(LowMaterials[Rand(LOW_MATERIALS_LENGTH)]);
				else if (MaterialRank <= MediumMaterialChance)
					GInv.AddMaterial(MediumMaterials[Rand(MED_MATERIALS_LENGTH)]);
				else
					GInv.AddMaterial(HighMaterials[Rand(HIGH_MATERIALS_LENGTH)]);
			}
		}
		C = NextC;
	}
	bMaterialsRewarded = true;
	Level.Game.Broadcast(self, "Take the time now to purchase any materials before stats are permanently saved.");
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
	MinAdrenAmount=1
	MonsterAdrenPerHit=0.20000000
	MaxCombosNonAM=1
	MaxCombosAM=2
	NumMonsterCombos=3
	MinimumWave=1
	MinimumMonsters=5
	PlayerTeamAdrenMax=100.000000000
	MonsterTeamAdrenMax=100.00000000
	MaterialOnGameWonChance=70
	LowMaterialChance=80
	MediumMaterialChance=95
	ComboClass(0)=Class'DEKRPG999X.ComboAttackInv'
	ComboClass(1)=Class'DEKRPG999X.ComboAttackInv'
	ComboClass(2)=Class'DEKRPG999X.ComboDefenseInv'
	ComboClass(3)=Class'DEKRPG999X.ComboDefenseInv'
	ComboClass(4)=Class'DEKRPG999X.ComboFreezeInv'
	ComboClass(5)=Class'DEKRPG999X.ComboHeatInv'
	ComboClass(6)=Class'DEKRPG999X.ComboRegenerateInv'
	ComboClass(7)=Class'DEKRPG999X.ComboHealStopInv'
	ComboClass(8)=Class'DEKRPG999X.ComboInaccuracyInv'
	ComboClass(9)=Class'DEKRPG999X.ComboMisfortuneInv'
	ComboData(0)=(LifeSpan=25,Multiplier=1.200000,bDispellable=True,bSingle=True,bBuff=True)
	ComboData(1)=(LifeSpan=25,Multiplier=0.800000,bDispellable=True,bAll=True,bBuff=False)
	ComboData(2)=(LifeSpan=25,Multiplier=0.800000,bDispellable=True,bSingle=True,bBuff=True)
	ComboData(3)=(LifeSpan=25,Multiplier=1.200000,bDispellable=True,bAll=True,bBuff=False)
	ComboData(4)=(LifeSpan=25,Multiplier=4.000000,bDispellable=True,bAll=True,bBuff=False)
	ComboData(5)=(LifeSpan=10,Multiplier=2.000000,bDispellable=True,bAll=True,bBuff=False)
	ComboData(6)=(LifeSpan=25,Multiplier=10.000000,bDispellable=True,bSingle=True,bBuff=True)
	ComboData(7)=(LifeSpan=25,Multiplier=1.000000,bDispellable=True,bAll=True,bBuff=False)
	ComboData(8)=(LifeSpan=25,Multiplier=30.000000,bDispellable=True,bAll=True,bBuff=False)
	ComboData(9)=(LifeSpan=25,Multiplier=300.000000,bDispellable=True,bAll=True,bBuff=False)
	LowMaterials(0)=Class'DEKRPG999X.AbilityMaterialLumber'
	LowMaterials(1)=Class'DEKRPG999X.AbilityMaterialCombatBoots'
	LowMaterials(2)=Class'DEKRPG999X.AbilityMaterialTarydiumShards'
	LowMaterials(3)=Class'DEKRPG999X.AbilityMaterialSteel'
	LowMaterials(4)=Class'DEKRPG999X.AbilityMaterialNaliFruit'
	LowMaterials(5)=Class'DEKRPG999X.AbilityMaterialGloves'
	MediumMaterials(0)=Class'DEKRPG999X.AbilityMaterialLeather'
	MediumMaterials(1)=Class'DEKRPG999X.AbilityMaterialPlatedArmor'
	MediumMaterials(2)=Class'DEKRPG999X.AbilityMaterialHoneysuckleVine'
	MediumMaterials(3)=Class'DEKRPG999X.AbilityMaterialEmbers'
	MediumMaterials(4)=Class'DEKRPG999X.AbilityMaterialArcticSuit'
	HighMaterials(0)=Class'DEKRPG999X.AbilityMaterialMoss'
	HighMaterials(1)=Class'DEKRPG999X.AbilityMaterialDust'
	HighMaterials(2)=Class'DEKRPG999X.AbilityMaterialNanite'
	HighMaterials(3)=Class'DEKRPG999X.AbilityMaterialPumice'
	HighMaterials(4)=Class'DEKRPG999X.AbilityMaterialIcicle'
	bAddToServerPackages=True
	GroupName="TeamAdrenaline"
	FriendlyName="Team Combos"
	Description="Team combos provides combos for the player team and monster team in Invasion. When team adrenaline is full, players and monsters can perform combos."
	bAlwaysRelevant=True
}