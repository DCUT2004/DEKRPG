class MutTeamAdrenaline extends Mutator
	config(UT2004RPG);
	
var Invasion Invasion;
var MutWaveRandomizer WaveRandomizer;
var TeamAdrenalineGameRules TeamAdrenGameRule;
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

var Altar IceAltar, FireAltar, EarthAltar;
var config byte MaxGeodes;				//Max number of Geodes held by all Altars

#exec  AUDIO IMPORT NAME="MonsterComboSound" FILE="Sounds\MonsterComboSound.WAV" GROUP="ComboSounds"

struct ComboInfo
{
	var class<StatusEffectData> StatusEffectClass;
	var int StatusLifespan;
	var bool bDispellable;
	var bool bStackable;
};

var config Array < ComboInfo > Combos;

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
			TeamAdrenGameRule = G;
			default.PlayerTeamAdrenaline = 0.000000;
			default.MonsterTeamAdrenaline = 0.000000;
			SpawnAltars();
			SetTimer(10, True);
		}
	}
	bComboAddedForBossWave = false;
	bMaterialsRewarded = false;

	Super.PostBeginPlay();
}

function SpawnAltars()
{
	local int NumNavPoints, NavIndex, Counter;
	local NavigationPoint N;
	
	Counter = 0;
	NumNavPoints = 0;
	
	for (N = Level.NavigationPointList; N != None; N = N.NextNavigationPoint)
		NumNavPoints++;
	
	while ( (IceAltar == None || FireAltar == None || EarthAltar == None) && Counter < 100)
	{
		NavIndex = Rand(NumNavPoints) + 1;
		for ( N=Level.NavigationPointList; N!=None; N=N.NextNavigationPoint )
		{
			NavIndex--;
			if (NavIndex == 0)
			{
				if (IceAltar == None)
					IceAltar = Spawn(Class'Altar_Ice',,, N.Location);
				else if (FireAltar == None)
				{
					if (VSize(N.Location - IceAltar.Location) < IceAltar.CollisionRadius*2 + 35.0)
					{
						Counter++;
						break;
					}
					FireAltar = Spawn(Class'Altar_Fire',,, N.Location);
				}
				else if (EarthAltar == None)
				{
					if (VSize(N.Location - IceAltar.Location) < IceAltar.CollisionRadius*2 + 35.0 || VSize(N.Location - FireAltar.Location) < FireAltar.CollisionRadius*2 + 35.0)
					{
						Counter++;
						break;
					}
					EarthAltar = Spawn(Class'Altar_Earth',,, N.Location);
				}
			}
		}
		if (EarthAltar != None)
			break;
		Counter++;	//Safety measure
	}
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

	if (TeamAdrenGameRule != None && TeamAdrenGameRule.GeodeChance > 0)
		if (IceAltar != None && FireAltar != None && EarthAltar != None && IceAltar.NumGeodes + FireAltar.NumGeodes + EarthAltar.NumGeodes >= MaxGeodes)
			TeamAdrenGameRule.GeodeChance = -1;
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
	local int x;
	local int RandIndex;
	local int Modifier, MaxModifier;
	
	Level.Game.BroadCast(Self, "Monster combo!");
	
	for (x = 0; x < NumMonsterCombos; x++)
	{
		//First, randomly select a StatusEffect to apply
		RandIndex = Rand(Combos.Length);
		
		//Next, determine what the Modifier of the StatusEffect will be
		MaxModifier = Combos[RandIndex].StatusEffectClass.default.MaxModifier;
		Modifier = Rand(MaxModifier) + 1;
		
		//Will this be a buff to monsters (positive modifier) or an ailment to players (negative modifier)
		if (Combos[RandIndex].StatusEffectClass.default.bOnlyNegativeModifier || Combos[RandIndex].StatusEffectClass == Class'StatusEffect_AdrenRegen' || Combos[RandIndex].StatusEffectClass == Class'StatusEffect_AmmoRegen')
			Modifier = -(Modifier);
		else if (Combos[RandIndex].StatusEffectClass.default.bOnlyPositiveModifier){}
		else	//Can be positive or negative - decide which
		{
			if ( Rand(100) <= 49)
				Modifier = -(Modifier);
		}
			
		if (Modifier > 0)	//A buff - apply to monsters
			ApplyMonsterBuff(RandIndex, Modifier);
		else if (Modifier < 0) 	//An ailment - apply to players
			ApplyPlayerAilment(RandIndex, Modifier);
		AnnounceCombo(RandIndex, Modifier);
	}
	PlayMonsterComboSound();
	default.MonsterTeamAdrenaline = 0.00;
}

function ApplyMonsterBuff(int RandIndex, int Modifier)
{
	local Controller C, NextC;
	local StatusEffectManager StatusInv;
	
	C = Level.ControllerList;
	
	while (C != None)
	{
		NextC = C.NextController;
		
		if (C != None && C.Pawn != None && C.Pawn.Health > 0 && C.Pawn.IsA('Monster') && FriendlyMonsterInv(C.Pawn.FindInventoryType(Class'FriendlyMonsterInv')) == None && !C.Pawn.IsA('HealerNali'))
		{
			StatusInv = StatusEffectManager(C.Pawn.FindInventoryType(Class'StatusEffectManager'));
			if (StatusInv != None)
				StatusInv.AddStatusEffect(Combos[RandIndex].StatusEffectClass, Modifier, True, Combos[RandIndex].StatusLifespan, Combos[RandIndex].bDispellable, Combos[RandIndex].bStackable);
		}
		
		C = NextC;
	}
}

function ApplyPlayerAilment(int RandIndex, int Modifier)
{
	local Controller C, NextC;
	local Pawn RealP;
	local StatusEffectManager StatusInv;

	C = Level.ControllerList;
	
	while (C != None)
	{
		NextC = C.NextController;
		
		if (C != None && C.Pawn != None && C.Pawn.Health > 0 &&
			( !C.Pawn.IsA('Monster') || C.Pawn.IsA('Monster') && FriendlyMonsterInv(C.Pawn.FindInventoryType(Class'FriendlyMonsterInv')) != None) )
		{
			if (C.Pawn.IsA('Vehicle'))
				RealP = Vehicle(C.Pawn).Driver;
			else
				RealP = C.Pawn;
			StatusInv = StatusEffectManager(RealP.FindInventoryType(Class'StatusEffectManager'));
			if (StatusInv != None)
				StatusInv.AddStatusEffect(Combos[RandIndex].StatusEffectClass, Modifier, True, Combos[RandIndex].StatusLifespan, Combos[RandIndex].bDispellable, Combos[RandIndex].bStackable);
		}
		
		C = NextC;
	}
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

simulated function AnnounceCombo(int RandIndex, int Modifier)
{
	Level.Game.BroadCast(Self, Combos[RandIndex].StatusEffectClass.static.GetFriendlyName() $ " " $ Modifier $ " for " $ Combos[RandIndex].StatusLifespan $ " seconds");
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
	Combos(0)=(StatusEffectClass=Class'StatusEffect_DamageBonus',StatusLifespan=30,bDispellable=True,bStackable=True)
	Combos(1)=(StatusEffectClass=Class'StatusEffect_DamageReduction',StatusLifespan=30,bDispellable=True,bStackable=True)
	Combos(2)=(StatusEffectClass=Class'StatusEffect_Burn',StatusLifespan=5,bDispellable=True,bStackable=False)
	Combos(3)=(StatusEffectClass=Class'StatusEffect_Speed',StatusLifespan=15,bDispellable=True,bStackable=False)
	Combos(4)=(StatusEffectClass=Class'StatusEffect_ChanceHit',StatusLifespan=20,bDispellable=True,bStackable=True)
	Combos(5)=(StatusEffectClass=Class'StatusEffect_Parasite',StatusLifespan=0,bDispellable=False,bStackable=True)
	Combos(6)=(StatusEffectClass=Class'StatusEffect_Momentum',StatusLifespan=30,bDispellable=True,bStackable=False)
	Combos(7)=(StatusEffectClass=Class'StatusEffect_Misfortune',StatusLifespan=20,bDispellable=True,bStackable=True)
	Combos(8)=(StatusEffectClass=Class'StatusEffect_Regeneration',StatusLifespan=20,bDispellable=True,bStackable=True)
	Combos(9)=(StatusEffectClass=Class'StatusEffect_AdrenRegen',StatusLifespan=10,bDispellable=True,bStackable=False)
	Combos(10)=(StatusEffectClass=Class'StatusEffect_AmmoRegen',StatusLifespan=10,bDispellable=True,bStackable=False)
	Combos(11)=(StatusEffectClass=Class'StatusEffect_MagicalWard',StatusLifespan=25,bDispellable=True,bStackable=True)
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
	MaxGeodes=6
	bAddToServerPackages=True
	GroupName="TeamAdrenaline"
	FriendlyName="Team Combos"
	Description="Team combos provides combos for the player team and monster team in Invasion. When team adrenaline is full, players and monsters can perform combos."
	bAlwaysRelevant=True
}