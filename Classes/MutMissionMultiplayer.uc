class MutMissionMultiplayer extends Mutator
	config(UT2004RPG);


//Baseline variables to simply check for the RPG mutator, Rules, and InteractionOwner that handles the HUD
var MutUT2004RPG RPGMut;
var RPGRules Rules;
var transient DruidsRPGKeysInteraction InteractionOwner;

//Mission variables
var bool stopped;	//signifies whether a mission is paused or active.
var int MissionCount;		//The mission's current progress. This is updated by various events, such as making kills or standing in a specific location
var int MissionGoal;	//The mission's goal
var int MissionXP;		//The amount of experience rewarded to players after completing a mission
var localized string MissionName;
var config float CheckInterval;
var int MissionClock;		//internal system for tracking time. Used in conjunction with TimeLimit.
var int TimeRemaining;
var config int Countdown;		//the time for players to prepare before the mission actually starts.
var int TimeLimit;	//time that mission must be completed by. Used in conjunction with MissionClock.
var bool RewardGranted;	//A condition to check if the XP reward has already been granted for completing the mission

//Boolean values for which mission is currently active
//Only one mission should be active at any given time
var bool PowerPartyActive;
var bool TarydiumKeepActive;
var bool BalloonPopActive;
var bool RingAndHoldActive;
var bool GenomeProjectActive;
var bool MusicalWeaponsActive;
var bool PortalBallActive;

//Material variables
var config int MaterialChance;
var config int LowMaterialChance;
var config int MediumMaterialChance;
var config Array < class < AbilityMaterial > > LowMaterial, MediumMaterial, HighMaterial;

//BalloonPop Variables
var config Array <class < MissionBalloon > > BalloonClass;

//Tarydium Keep Variables
var TarydiumCrystal TC;
var int TCHealth;

//Ring and Hold Variables
var RingRed RR;
var RingBlue RB;
var RingGold RG;
var bool RRActive, RBActive, RGActive;

//Genome Project Variables
var GenomeProjectNode GPN;
var config int GenomeXPPerVial;
var int NumVials;
var config int NumMaxVials;
var config Array < class < Pickup > > VialPickupClass;

//Musical Weapons Variables
var config Array < class <Weapon> > MusicalWeaponsList;	//The list of available weapons allowed for the Musical Weapons mission
var class<Weapon> ActiveWeapon;	//The current, active weapon that players must use for Musical Weapons
var config float MusicalChangeChance;	// % chance per CheckInterval the required weapon changes
var config int MusicalMinimumTime;	//how long in seconds a weapon should remain once changed. Prevents constant switching
var int MusicalCounter;	//A counter to be used with MusicalMinimumTime

//Portal Ball Variables
var config Array <class < MissionPortalBall > > PortalBallClass;
var int NumBalls;
var config int NumMaxBalls;

//Import audio files
#exec  AUDIO IMPORT NAME="MP3VoiceDraw" FILE="Sounds\MP3VoiceDraw.WAV" GROUP="MissionSounds"
#exec  AUDIO IMPORT NAME="MP3VoiceFinish" FILE="Sounds\MP3VoiceFinish.WAV" GROUP="MissionSounds"
#exec  AUDIO IMPORT NAME="MP3VoiceStart" FILE="Sounds\MP3VoiceStart.WAV" GROUP="MissionSounds"
#exec  AUDIO IMPORT NAME="MP3VoiceTimeUp" FILE="Sounds\MP3VoiceTimeUp.WAV" GROUP="MissionSounds"

replication
{
	reliable if (Role == ROLE_Authority)
		Stopped, MissionName, MissionCount, MissionGoal, MissionXP, MissionClock, TimeRemaining, Countdown, TimeLimit, RewardGranted, PowerPartyActive, TarydiumKeepActive, TC, TCHealth, BalloonPopActive, RingAndHoldActive, RRActive, RBActive, RGActive, GenomeProjectActive, MusicalWeaponsActive, PortalBallActive, ActiveWeapon;
}

//PostBeginPlay() initializes variables shortly before the game starts
simulated function PostBeginPlay()
{
	local Mutator M;

	Super.PostBeginPlay();

	if (Level.Game != None)
	{
		for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
		{
			if (MutUT2004RPG(m) != None)
			{
				RPGMut = MutUT2004RPG(m);
				break;
			}
		}
	}
	CheckRPGRules();
	
	stopped = true;
	SetTimer(0, False);
	MissionCount = 0;
	MissionGoal = 0;
	MissionXP = 0;
	MissionClock = 0;
	TimeRemaining = 0;
	Countdown = default.Countdown;
	RewardGranted = False;
	PowerPartyActive = False;
	TarydiumKeepActive = False;
	BalloonPopActive = False;
	RingAndHoldActive = False;
	GenomeProjectActive = False;
	MusicalWeaponsActive = False;
	PortalBallActive = False;
	ActiveWeapon = None;
	MusicalCounter = 0;
	NumBalls = 0;
	NumVials = 0;
}

//Make sure RPGRules is instantiated so we can reward EXP to players
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
		Log("WARNING: Unable to find RPGRules in GameRules. EXP will not be properly awarded");
}

//Timer is called by the team mission artifact.
//Timer will loop through all controllers and update everyone's mission variables
simulated function Timer()
{
	local Controller C;
	
	if(!stopped)
	{
		Countdown--;	//start the countdown to commence mission/minigame. This gives players time to prepare and read the objective.
		if (Countdown == 0)
		{
			//Mission has started. Play a sound and read a message to all players
			for ( C = Level.ControllerList; C != None; C = C.NextController )
				if (C != None && C.Pawn != None && C.Pawn.Health > 0 && C.IsA('PlayerController'))
					PlayerController(C).ClientPlaySound(Sound'DEKRPG999X.MissionSounds.MP3VoiceStart');
			Level.Game.Broadcast(self, "Start!");
		}
		else if (Countdown > 0)	//still counting down to start minigame/mission.
		{
			//While in countdown, don't let anyone complete objectives or let objectives get destroyed
			if (MissionCount > 0)
				MissionCount = 0;
			if (TC != None)
			{
				TC.Health = TC.default.HealthMax;
				TCHealth = TC.default.HealthMax;
			}
		}
		else if (MissionClock >= TimeLimit && MissionClock != 0)		//When the time limit to complete the mission has been reached
		{
			//Play the "Time Up!" sound to all players
			for ( C = Level.ControllerList; C != None; C = C.NextController )
				if (C != None && C.Pawn != None && C.Pawn.Health > 0 && C.IsA('PlayerController') )
					PlayerController(C).ClientPlaySound(Sound'DEKRPG999X.MissionSounds.MP3VoiceTimeUp');
					
			//Certain missions do not have a mission goal, and we don't want to penalize players by not reaching a goal that hasn't been set
			//StopMission() will end the mission in a Mission Failed state for those missions that indeed have a goal
			if (GenomeProjectActive)
			{
				if (MissionCount > 0)
					MissionComplete();
				else
					StopMission();
			}
			else
				StopMission();
		}
		else
		{
			//Mission has started. Start the time limit and allow mission counts to accrue.
			
			MissionClock++;
			TimeRemaining = (TimeLimit - MissionClock);
		}
		
		//Throughout the duration of the mission, certain missions need special care when certain objectives are triggered
		
		//If the Tarydium crystals are destroyed, stop the mission
		if (TarydiumKeepActive)
		{
			if (TC != None)
				TCHealth = TC.Health;
			if (TC == None || TC.Health <= 0)
			{
				StopMission();
			}
		}
		
		//If any Red, Blue, or Gold rings are not held, reset the mission counter
		if (RingAndHoldActive)
		{
			if (RR != None)
			{
				if (RR.CheckRadius())
					RRActive = True;
				else
					RRActive = False;
			}
			if (RB != None)
			{
				if (RB.CheckRadius())
					RBActive = True;
				else
					RBActive = False;
			}
			if (RG != None)
			{
				if (RG.CheckRadius())
					RGActive = True;
				else
					RGActive = False;
			}
		}
		
		if (BalloonPopActive)
		{
			SpawnBalloons();
		}
		
		if (PortalBallActive)
		{
			SpawnPortalBalls();
		}
		
		if (GenomeProjectActive && GPN != None)
		{
			SpawnGenomeVial();
		}
		
		//Constantly randomize the weapons in Musical Weapons
		if (MusicalWeaponsActive)
		{
			MusicalCounter++;	//Increment the counter each second
			if (MusicalCounter >= MusicalMinimumTime)	//Once the counter reaches the minimum time, then we can swap a new weapon. This prevents constant weapon switching
			{
				if ( Rand(100) <= MusicalChangeChance)
				{
					ActiveWeapon = MusicalWeaponsList[Rand(MusicalWeaponsList.Length)];	//Randomly select a weapon from the list
					MusicalCounter = 0;
				}
			}
		}
		
		//Now let's check to see if MissionCount has reached MissionGoal
		//If so, stop the timer and reward players.
		if ( MissionCount != 0 && MissionGoal != 0 && MissionCount >= MissionGoal)
		{
			if (!RewardGranted)		//This condition is checked to ensure that MissionComlete does not get repeatedly called
				MissionComplete();
			else	//Player must be ghosting and this function is getting repeatedly called
				StopMission();
		}
	}
	else
		return;
}

simulated function UpdateCount(int Count)
{
	MissionCount += Count;
}

simulated function StopMission()
{
	
	//Display a Mission Failed message. Womp Womp
	if (!RewardGranted)
	{
		if (TarydiumKeepActive)
			Level.Game.Broadcast(self, "Tarydium destroyed! Team mission failed.");
		else
			Level.Game.Broadcast(self, "Team mission failed.");
	}
	
	StopEffect();
}

//MissionComplete() is called when a mission goal has been reached
//MissionComplete() rewards XP to everyone on the team
//Also handles the destruction of any mission-related objectives
simulated function MissionComplete()
{
	local Controller C, NextC;
	local Pawn P;
	local GiveItemsInv GInv;
	local int RandChance;
	local int MaterialRankChance;
	
	//An important boolean to set here so that MissionComplete() does not get called repeatedly
	RewardGranted = True;
	
	//Broadcast a Mission Completed message to everyone
	if (GenomeProjectActive)
		Level.Game.Broadcast(self, "" $ MissionName $ ": +" $ (MissionCount*GenomeXPPerVial) $ " XP.");
	else
		Level.Game.Broadcast(self, "" $ MissionName $ " complete! +" $ MissionXP $ " XP.");
	
	//Loop through all controllers and reward XP
	//Certain missions will have their own way of rewarding XP rather than using a flat amount
	C = Level.ControllerList;
	while (C != None)
	{
		NextC = C.NextController;
		
		if (C != None && C.Pawn != None && C.Pawn.Health > 0 && !C.Pawn.IsA('Monster'))
		{
			P = C.Pawn;
			if(P != None && P.isA('Vehicle'))
				P = Vehicle(P).Driver;
			if (P != None)
			{
				if ((MissionXP > 0) && (Rules != None))
				{
					if (GenomeProjectActive)
						Rules.ShareExperience(RPGStatsInv(P.FindInventoryType(class'RPGStatsInv')), (MissionCount*GenomeXPPerVial));
					else
						Rules.ShareExperience(RPGStatsInv(P.FindInventoryType(class'RPGStatsInv')), MissionXP);
				}

				//Only play the "Finished!" sound for missions with end goals
				if (!GenomeProjectActive)
				{
					if (PlayerController(C) != None)
						PlayerController(C).ClientPlaySound(Sound'DEKRPG999X.MissionSounds.MP3VoiceFinish');
				}
			}
		}
		//Add material
		RandChance = Rand(100);
		if (C != None && C.bIsPlayer && RandChance <= MaterialChance)
		{
			GInv = class'GiveItemsInv'.static.GetGiveItemsInv(C);
			if (GInv != None)
			{
				MaterialRankChance = Rand(100);
				if (MaterialRankChance <= LowMaterialChance)
				{
					GInv.AddMaterial(LowMaterial[RandRange(0, LowMaterial.Length)]);
				}
				else if (MaterialRankChance <= MediumMaterialChance)
				{
					GInv.AddMaterial(MediumMaterial[RandRange(0, MediumMaterial.Length)]);
				}
				else
				{
					GInv.AddMaterial(HighMaterial[RandRange(0, HighMaterial.Length)]);
				}
			}
		}
		C = NextC;
	}
	//Call StopEffect() and stop the timer
	StopEffect();
	SetTimer(0, False);
	
	//Destroy mission actors and objectives
	if (TC != None)
		TC.Destroy();
	if (RR != None)
		RR.Destroy();
	if (RB != None)
		RB.Destroy();
	if (RG != None)
		RG.Destroy();
	if (GPN != None)
		GPN.Destroy();
}

simulated function SpawnGenomeVial()
{
	local NavigationPoint Dest;
	local Pickup VialPickup;
	
	Dest = Level.Game.FindPlayerStart(None, 1);
	
	if (NumVials < NumMaxVials)
		VialPickup = Spawn(VialPickupClass[RandRange(0, VialPickupClass.Length)],,,Dest.Location);
	if (VialPickup != None)
		NumVials++;
}

simulated function SpawnBalloons()
{
	local NavigationPoint Dest;
	local MissionBalloon Balloon;
	
	Dest = Level.Game.FindPlayerStart(None, 1);
	
	Balloon = Spawn(BalloonClass[RandRange(0, BalloonClass.Length)],,,Dest.Location);
	if (Balloon != None)
		Balloon.Controller.Destroy();
}

simulated function SpawnPortalBalls()
{
	local NavigationPoint Dest;
	local MissionPortalBall PortalBall;
	
	Dest = Level.Game.FindPlayerStart(None, 1);
	
	if (NumBalls < NumMaxBalls)
		PortalBall = Spawn(PortalBallClass[RandRange(0, PortalBallClass.Length)],,,Dest.Location + vect(0,0,20));
	if (PortalBall != None)
	{
		NumBalls++;
		if (PortalBall.Controller != None)
			PortalBall.Controller.Destroy();
	}
}

//StopEffect() stops the timer by setting the check interval to 0 and the loop to false
//All mission variables are re-initialized to their starting values so a new mission can start
//As a safety-measure, all mission objectives are destroyed here as well
function stopEffect()
{
	stopped = true;
	SetTimer(0, False);
	MissionCount = 0;
	MissionGoal = 0;
	MissionXP = 0;
	MissionClock = 0;
	TimeRemaining = 0;
	Countdown = default.Countdown;
	RewardGranted = False;
	PowerPartyActive = False;
	TarydiumKeepActive = False;
	BalloonPopActive = False;
	RingAndHoldActive = False;
	GenomeProjectActive = False;
	MusicalWeaponsActive = False;
	PortalBallActive = False;
	ActiveWeapon = None;
	NumBalls = 0;
	NumVials = 0;
	if (TC != None)
		TC.Destroy();
	if (RR != None)
		RR.Destroy();
	if (RB != None)
		RB.Destroy();
	if (RG != None)
		RG.Destroy();
	if (GPN != None)
		GPN.Destroy();
}

defaultproperties
{
	CheckInterval=1.000000
	CountDown=10
	BalloonClass(0)=Class'DEKRPG999X.MissionBalloon'
	BalloonClass(1)=Class'DEKRPG999X.MissionBalloonBlue'
	BalloonClass(2)=Class'DEKRPG999X.MissionBalloonGreen'
	BalloonClass(3)=Class'DEKRPG999X.MissionBalloonOrange'
	BalloonClass(4)=Class'DEKRPG999X.MissionBalloonYellow'
	BalloonClass(5)=Class'DEKRPG999X.MissionBalloonPurple'
	GenomeXPPerVial=5
	NumMaxVials=2
	VialPickupClass(0)=Class'DEKRPG999X.GenomeVialCosmicPickup'
	VialPickupClass(1)=Class'DEKRPG999X.GenomeVialFirePickup'
	VialPickupClass(2)=Class'DEKRPG999X.GenomeVialIcePickup'
	VialPickupClass(3)=Class'DEKRPG999X.GenomeVialGhostPickup'
	VialPickupClass(4)=Class'DEKRPG999X.GenomeVialTechPickup'
	MusicalWeaponsList(0)=Class'DEKWeapons999X.INAVRiL'
	MusicalWeaponsList(1)=Class'XWeapons.BioRifle'
	MusicalWeaponsList(2)=Class'XWeapons.ShockRifle'
	MusicalWeaponsList(3)=Class'UT2004RPG.RPGLinkGun'
	MusicalWeaponsList(4)=Class'XWeapons.Minigun'
	MusicalWeaponsList(5)=Class'XWeapons.FlakCannon'
	MusicalWeaponsList(6)=Class'XWeapons.RocketLauncher'
	MusicalWeaponsList(7)=Class'XWeapons.SniperRifle'
	MusicalChangeChance=10.000000
	MusicalMinimumTime=5
	PortalBallClass(0)=Class'DEKRPG999X.MissionPortalBallBlue'
	PortalBallClass(1)=Class'DEKRPG999X.MissionPortalBallGreen'
	PortalBallClass(2)=Class'DEKRPG999X.MissionPortalBallOrange'
	PortalBallClass(3)=Class'DEKRPG999X.MissionPortalBallPink'
	PortalBallClass(4)=Class'DEKRPG999X.MissionPortalBallPurple'
	PortalBallClass(5)=Class'DEKRPG999X.MissionPortalBallRed'
	MaterialChance=5
	LowMaterialChance=80
	MediumMaterialChance=95
	LowMaterial(0)=Class'DEKRPG999X.AbilityMaterialLumber'
	LowMaterial(1)=Class'DEKRPG999X.AbilityMaterialCombatBoots'
	LowMaterial(2)=Class'DEKRPG999X.AbilityMaterialTarydiumShards'
	LowMaterial(3)=Class'DEKRPG999X.AbilityMaterialSteel'
	LowMaterial(4)=Class'DEKRPG999X.AbilityMaterialNaliFruit'
	LowMaterial(5)=Class'DEKRPG999X.AbilityMaterialGloves'
	MediumMaterial(0)=Class'DEKRPG999X.AbilityMaterialLeather'
	MediumMaterial(1)=Class'DEKRPG999X.AbilityMaterialPlatedArmor'
	MediumMaterial(2)=Class'DEKRPG999X.AbilityMaterialHoneysuckleVine'
	MediumMaterial(3)=Class'DEKRPG999X.AbilityMaterialEmbers'
	MediumMaterial(4)=Class'DEKRPG999X.AbilityMaterialArcticSuit'
	HighMaterial(0)=Class'DEKRPG999X.AbilityMaterialMoss'
	HighMaterial(1)=Class'DEKRPG999X.AbilityMaterialDust'
	HighMaterial(2)=Class'DEKRPG999X.AbilityMaterialNanite'
	HighMaterial(3)=Class'DEKRPG999X.AbilityMaterialPumice'
	HighMaterial(4)=Class'DEKRPG999X.AbilityMaterialIcicle'
	NumMaxBalls=2
	bAddToServerPackages=True
	GroupName="TeamMission"
	FriendlyName="Team Missions"
	Description="Enables team missions. UT2004RPG must be enabled."
	bAlwaysRelevant=True
	MessageClass=Class'UnrealGame.StringMessagePlus'
}
