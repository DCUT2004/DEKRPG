class MissionCowCareInv extends MissionInv
	config(UT2004RPG);

var RPGRules Rules;
var bool stopped;	//signifies whether a mission is paused or active.
var config float CheckInterval;
var int MissionXP;		//set by artifact.
var ArtifactMissionCowCare MissionArtifact;
var MissionCow Cow;
var MissionCowMarker Marker;
var MissionCowHealMarker HealMarker;
var HealerNaliHealthFX HealFX;
var config float HealRadius;
var config int HealAmount;
var config int MaterialChance, LowMaterialChance, MediumMaterialChance;
var config Array < Class < AbilityMaterial > > LowMaterials, MediumMaterials, HighMaterials;

#exec  AUDIO IMPORT NAME="MissionComplete1" FILE="Sounds\MissionComplete1.WAV" GROUP="MissionSounds"

replication
{
	reliable if (Role == ROLE_Authority)
		stopped, MissionXP;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	
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
		Log("WARNING: Unable to find RPGRules in GameRules. EXP will not be properly awarded");
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	local Pawn OldInstigator;

	if(Other == None)
	{
		destroy();
		return;
	}

	stopped = true;

	//want Instigator to be the one that caused the freeze
	OldInstigator = Instigator;
	Super.GiveTo(Other);
	PawnOwner = Other;

	Instigator = OldInstigator;
}

simulated function SpawnCow()
{
	Local Vector SpawnLocation;
	local rotator SpawnRotation;
	
	MissionArtifact = ArtifactMissionCowCare(PawnOwner.FindInventoryType(class'ArtifactMissionCowCare'));
	
	SpawnLocation = getSpawnLocation(class'MissionCow');
	SpawnRotation = getSpawnRotator(SpawnLocation);
	
	Cow = Spawn(class'MissionCow',PawnOwner,,SpawnLocation, SpawnRotation);
	
	if (Cow != None)
	{
		Cow.Master = PawnOwner;
		stopped = False;
		PawnOwner.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
		PawnOwner.PlaySound(Sound'AssaultSounds.HumanShip.HnShipFireReadyl01', SLOT_None, 300.0);
		SetTimer(CheckInterval, True);
		if (MissionArtifact != None)
		{
			MissionArtifact.Destroy();
			PawnOwner.NextItem();
		}
	}
	else
	{
		stopped = True;
		Instigator.ReceiveLocalizedMessage(MessageClass, 1000, None, None, Class);
	}
}

function vector getSpawnLocation(Class<Monster> ChosenMonster)
{
	local float Dist, BestDist;
	local vector SpawnLocation;
	local NavigationPoint N, BestDest;

	BestDist = 50000.f;
	for (N = Level.NavigationPointList; N != None; N = N.NextNavigationPoint)
	{
		Dist = VSize(N.Location - PawnOwner.Location);
		if (Dist < BestDist && Dist > ChosenMonster.default.CollisionRadius * 2)
		{
			BestDest = N;
			BestDist = VSize(N.Location - PawnOwner.Location);
		}
	}

	if (BestDest != None)
		SpawnLocation = BestDest.Location + (ChosenMonster.default.CollisionHeight - BestDest.CollisionHeight) * vect(0,0,1);
	else
		SpawnLocation = PawnOwner.Location + ChosenMonster.default.CollisionHeight * vect(0,0,1.5); //is this why monsters spawn on heads?

	return SpawnLocation;	
}

function rotator getSpawnRotator(Vector SpawnLocation)
{
	local rotator SpawnRotation;

	SpawnRotation.Yaw = rotator(SpawnLocation - Instigator.Location).Yaw;
	return SpawnRotation;
}

function Timer()
{
	local Controller C;
	
	if(!stopped)
	{
		if (PawnOwner == None || PawnOwner.Health <= 0)
		{
			Destroy();
			return;
		}
		if (Cow == None || Cow.Health <= 0)
		{
			stopEffect();
		}
		if (PawnOwner != None && PawnOwner.Health > 0 && Cow != None && Cow.Health > 0)
		{
			//Have the Cow follow the player.
			C = Cow.Controller;
			if (C != None)
			{
				if (FastTrace(Cow.Location, PawnOwner.Location))
						MonsterController(C).ChangeEnemy(PawnOwner, C.CanSee(PawnOwner));
			}
			//Heal the Cow when standing near it.
			if (VSize(PawnOwner.Location - Cow.Location) < HealRadius && FastTrace(PawnOwner.Location, Cow.Location))
			{
				if (Cow.Health < Cow.default.HealthMax)
				{
					Cow.GiveHealth(HealAmount, Cow.default.HealthMax);
					Cow.PlaySound(Sound'PickupSounds.HealthPack', SLOT_None, Cow.TransientSoundVolume*0.75);
					if (Marker != None)
						Marker.Destroy();
					if (HealMarker == None)
					{
						HealMarker = PawnOwner.Spawn(class'MissionCowHealMarker',PawnOwner,,Cow.Location,rotator(PawnOwner.Location - Cow.Location));
						HealMarker.SetBase(Cow);
					}
						HealFX = Cow.Spawn(class'HealerNaliHealthFX',Cow,,Cow.Location);
				}
				else
				{
					if (HealMarker != None)
						HealMarker.Destroy();
					if (Marker == None)
					{
						Marker = PawnOwner.Spawn(class'MissionCowMarker',PawnOwner,,Cow.Location,rotator(PawnOwner.Location - Cow.Location));
						Marker.SetBase(Cow);
					}
				}
			}
			else if (VSize(PawnOwner.Location - Cow.Location) > HealRadius || !FastTrace(PawnOwner.Location, Cow.Location))
			{
				if (HealMarker != None)
					HealMarker.Destroy();
				if (Marker != None)
					Marker.Destroy();
			}
			//Give the Cow invulnerability if player is invulnerable.
			if (!Cow.Controller.bGodMode && PawnOwner.Controller.bGodMode)
			{
				Cow.Controller.bGodMode = True;
			}
			else if (Cow.Controller.bGodMode && !PawnOwner.Controller.bGodMode)
			{
				Cow.Controller.bGodMode = False;
			}
			if (Invasion(Level.Game) != None)
			{
				if (!Invasion(Level.Game).bWaveInProgress && Invasion(Level.Game).WaveCountDown <= 2)
				{
					if ((MissionXP > 0) && (Rules != None))
					{
						Rules.ShareExperience(RPGStatsInv(PawnOwner.FindInventoryType(class'RPGStatsInv')), MissionXP);
					}
					PawnOwner.ReceiveLocalizedMessage(MessageClass, MissionXP, None, None, Class);
					GiveMaterial();
				}
			}
			else
			{
				return;
				StopEffect();
			}
		}
	}
}

function GiveMaterial()
{
	local int RankChance;
	local GiveItemsInv GInv;
	
	if (Rand(100) <= MaterialChance)
	{
		if (PawnOwner.Controller != None)
			GInv = class'GiveItemsInv'.static.GetGiveItemsInv(PawnOwner.Controller);
		if (GInv != None)
		{
			RankChance = Rand(100);
			if (RankChance <= LowMaterialChance)
			{
				GInv.AddMaterial(LowMaterials[RandRange(0, LowMaterials.Length)]);
			}
			else if (RankChance <= MediumMaterialChance)
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

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 1000)
		return "Could not spawn cow.";
	else if (Switch == 2000)
		return "Protect your pet cow! Stand next to it to heal it.";
	else
		return "Your cow survived! +" @ switch @ "XP.";
}

function stopEffect()
{	
	if(stopped)
		return;
	else
	{
		stopped = true;
		SetTimer(0, False);
		if (HealMarker != None)
			HealMarker.Destroy();
		if (Marker != None)
			Marker.Destroy();
		if (Cow != None)
			Cow.Destroy();
	}
}

simulated function destroyed()
{
	stopEffect();
	super.destroyed();
}

defaultproperties
{
	LowMaterialChance=80
	MediumMaterialChance=95
	MaterialChance=3
	CheckInterval=1.000000
	HealRadius=120.000000
	HealAmount=10
	ItemName="Cow Care"
	LowMaterials(0)=Class'DEKRPG208AE.AbilityMaterialLumber'
	LowMaterials(1)=Class'DEKRPG208AE.AbilityMaterialCombatBoots'
	LowMaterials(2)=Class'DEKRPG208AE.AbilityMaterialTarydiumShards'
	LowMaterials(3)=Class'DEKRPG208AE.AbilityMaterialSteel'
	LowMaterials(4)=Class'DEKRPG208AE.AbilityMaterialNaliFruit'
	LowMaterials(5)=Class'DEKRPG208AE.AbilityMaterialGloves'
	MediumMaterials(0)=Class'DEKRPG208AE.AbilityMaterialLeather'
	MediumMaterials(1)=Class'DEKRPG208AE.AbilityMaterialPlatedArmor'
	MediumMaterials(2)=Class'DEKRPG208AE.AbilityMaterialHoneysuckleVine'
	MediumMaterials(3)=Class'DEKRPG208AE.AbilityMaterialEmbers'
	MediumMaterials(4)=Class'DEKRPG208AE.AbilityMaterialArcticSuit'
	HighMaterials(0)=Class'DEKRPG208AE.AbilityMaterialMoss'
	HighMaterials(1)=Class'DEKRPG208AE.AbilityMaterialDust'
	HighMaterials(2)=Class'DEKRPG208AE.AbilityMaterialNanite'
	HighMaterials(3)=Class'DEKRPG208AE.AbilityMaterialPumice'
	HighMaterials(4)=Class'DEKRPG208AE.AbilityMaterialIcicle'
}
