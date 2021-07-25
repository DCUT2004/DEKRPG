class BossInv extends Inventory
	config(DEKBossMonsters);

var config int AdrenDripAmount;
var int AdrenCounter;
var config int AdrenDripCooldown;
var class<Monster> MinionClass;
var int MinionCounter;
var config int MinionSpawnInterval;
var int NumMinions;
var config int MaxMinions;

function PostBeginPlay()
{
	SetTimer(1, True);
	Super.PostBeginPlay();
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	Instigator = Other;
	MinionCounter = 0;
	AdrenCounter = 100;
	NumMinions = 0;
	Super.GiveTo(Other);
}

simulated function Timer()
{
	MinionCounter++;
	AdrenCounter++;
	
	if (NumMinions < 0)
		NumMinions = 0;
		
	if (Instigator != None && Instigator.Controller != None)
	{
		if (MinionCounter >= MinionSpawnInterval && NumMinions < MaxMinions)
		{
			SpawnMinion();
			MinionCounter = 0;
		}
		//Adrenaline Drip
		if (AdrenCounter >= AdrenDripCooldown)
			Instigator.Controller.AwardAdrenaline(AdrenDripAmount);
	}
}

function SpawnMinion()
{
	local Monster M;

	if(NumMinions >= MaxMinions)
		return;
		
	M = Instigator.spawn(MinionClass, Instigator,, getSpawnLocation(MinionClass));
	
	if(M != None)
	{
		NumMinions++;
	}
}

function vector getSpawnLocation(Class<Monster> ChosenMonster)
{
	local float Dist, BestDist;
	local vector SpawnLocation;
	local NavigationPoint N, BestDest;

	BestDist = 100000.f;
	for (N = Level.NavigationPointList; N != None; N = N.NextNavigationPoint)
	{
		Dist = VSize(N.Location - Instigator.Location);
		if (Dist < BestDist && Dist > ChosenMonster.default.CollisionRadius * 8)
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

defaultproperties
{
     AdrenDripCooldown=25
     MinionSpawnInterval=10
     MaxMinions=5
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
