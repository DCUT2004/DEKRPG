class ArtifactSummonSkeleton extends EnhancedRPGArtifact
	config(UT2004RPG);

var Monster M;
var config class<Monster> MonsterClass;
var config float MonsterLifeSpan;
var config bool DestroyOnUse;
var config bool DestroyOnUseForLA;
var config int AdrenRequired;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer(5, True);
}

function Timer()
{
	if (M != None && M.Health <= 0)
		M = None;
}


function Activate()
{
	if (Instigator != None)
	{
		if(Instigator.Controller.Adrenaline < (AdrenalineRequired))
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, AdrenalineRequired, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}
		
		if (LastUsedTime  + (TimeBetweenUses*TimeUsage) > Instigator.Level.TimeSeconds)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 5000, None, None, Class);
			bActive = false;
			GotoState('');
			return;	// cannot use yet
		}


		if (Vehicle(Instigator) != None )
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 3000, None, None, Class);
			bActive = false;
			GotoState('');
			return;	// can't use in a vehicle

		}
		if (M != None)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 2500, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}
		else
			SpawnMonster();
	}
}

function SpawnMonster()
{
	Local Vector SpawnLocation;
	local rotator SpawnRotation;
	local DEKFriendlyMonsterController C;
	local Inventory Inv;
	local FriendlyMonsterInv FriendlyInv;
	local RPGStatsInv StatsInv;
	local int x;
	
	SpawnLocation = getSpawnLocation(MonsterClass);
	SpawnRotation = getSpawnRotator(SpawnLocation);
	
	M = Spawn(MonsterClass,,,SpawnLocation, SpawnRotation);
	if (M != None)
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
			return;
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
		if (StatsInv == None) //fallback, should never happen
			StatsInv = RPGStatsInv(Instigator.FindInventoryType(class'RPGStatsInv'));
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
		if (Instigator.Controller != None)
		{
			Instigator.Controller.Adrenaline -= AdrenRequired;
			if (Instigator.Controller.Adrenaline < 0)
				Instigator.Controller.Adrenaline = 0;
		}
	}
	else
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 4000, None, None, Class);
		bActive = false;
		GotoState('');
		return;
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
		Dist = VSize(N.Location - Instigator.Location);
		if (Dist < BestDist && Dist > ChosenMonster.default.CollisionRadius * 2)
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

function rotator getSpawnRotator(Vector SpawnLocation)
{
	local rotator SpawnRotation;

	SpawnRotation.Yaw = rotator(SpawnLocation - Instigator.Location).Yaw;
	return SpawnRotation;
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 2500)
		return class'ArtifactMonsterSummon'.Default.TooManyMonstersMessage;
	if (Switch == 3000)
		return "Cannot use this artifact in a vehicle";
	if (Switch == 4000)
		return "Could not spawn monster";

	return Super.GetLocalString(Switch, RelatedPRI_1, RelatedPRI_2);
}

defaultproperties
{
	 MonsterClass=Class'SkaarjPack.SkaarjPupae'
     MonsterLifeSpan=240.000000
     AdrenRequired=30
     PickupClass=Class'DEKRPG208AD.ArtifactSummonSkeletonPickup'
     ItemName="Skeleton Summon"
     IconMaterial=Texture'UTRPGTextures.Icons.SummoningCharmIcon'
     TimeBetweenUses=20.000000
}
