//The combo that the player has purchased
class ComboAbilitySwarmInv extends ComboAbilityInv
	config(UT2004RPG);
	
var Monster Gnat1, Gnat2, Gnat3, Gnat4, Gnat5;
	
#exec  AUDIO IMPORT NAME="Swarm" FILE="Sounds\Swarm.WAV" GROUP="ComboSounds"
	
function DoEffect()
{
	Local Vector V1, V2, V3, V4, V5;
	local rotator R1, R2, R3, R4, R5;
	
	if (Owner != None && Pawn(Owner) != None && Pawn(Owner).Controller != None)
	{
		//Spawn locations and spawn rotations
		V1 = Pawn(Owner).Location + Vect(60,0,0);
		R1 = getSpawnRotator(V1);
		V2 = Pawn(Owner).Location + Vect(-60,0,0);
		R2 = getSpawnRotator(V2);
		V3 = Pawn(Owner).Location + Vect(0,60,0);
		R3 = getSpawnRotator(V3);
		V4 = Pawn(Owner).Location + Vect(0,-60,0);
		R4 = getSpawnRotator(V4);
		V5 = Pawn(Owner).Location + Vect(0,0,60);
		R5 = getSpawnRotator(V5);
		
		//Spawn the gnats
		if (Gnat1 == None)
			Gnat1 = spawnGnat(V1, R1);
		else
		{
			Gnat1.Lifespan = ComboLifespan;
			Gnat1.Health = Gnat1.Default.HealthMax;
		}
		if (Gnat2 == None)
			Gnat2 = spawnGnat(V2, R2);
		else
		{
			Gnat2.Lifespan = ComboLifespan;
			Gnat2.Health = Gnat1.Default.HealthMax;		
		}
		if (Gnat3 == None)
			Gnat3 = spawnGnat(V3, R3);
		else
		{
			Gnat3.Lifespan = ComboLifespan;
			Gnat3.Health = Gnat1.Default.HealthMax;
		}
		if (Gnat4 == None)
			Gnat4 = spawnGnat(V4, R4);
		else
		{
			Gnat4.Lifespan = ComboLifespan;
			Gnat4.Health = Gnat1.Default.HealthMax;
		}
		if (Gnat5 == None)
			Gnat5 = spawnGnat(V5, R5);
		else
		{
			Gnat5.Lifespan = ComboLifespan;
			Gnat5.Health = Gnat1.Default.HealthMax;
		}
		if (Pawn(Owner).PlayerReplicationInfo != None)
			Level.Game.Broadcast(self, Pawn(Owner).PlayerReplicationInfo.PlayerName $ " casted Swarm!");
		//Pawn(Owner).PlayOwnedSound(Sound'Swarm', SLOT_None, 1300.0, , 800.00);
	}
}

function Monster spawnGnat(Vector SpawnLocation, Rotator SpawnRotation)
{
	local LeechGnat M;
	local FriendlyMonsterInv FriendlyInv;
	local Controller C;
	local DEKFriendlyMonsterController FMC;
	local Inventory Inv;
	local RPGStatsInv StatsInv;
	local int x;
	
	M = spawn(Class'DEKRPG209D.LeechGnat',,, SpawnLocation, SpawnRotation);

	if (M != None)
	{
		if (M.Controller != None)
			M.Controller.Destroy();

		FriendlyInv = M.spawn(class'FriendlyMonsterInv');

		if(FriendlyInv == None)
			M.Destroy();
		FriendlyInv.MasterPRI = Pawn(Owner).Controller.PlayerReplicationInfo;
		FriendlyInv.Skill = 7.000;
		FriendlyInv.giveTO(M);
		
		FMC = spawn(class'DEKFriendlyMonsterController',,, SpawnLocation, SpawnRotation);
		if(FMC == None)
		{
			FriendlyInv.Destroy();
			M.Destroy();
		}
		FMC.Possess(M); //do not call InitializeSkill before this line.
		FMC.SetMaster(Pawn(Owner).Controller);
		FMC.InitializeSkill(7);
		
		M.Master = Pawn(Owner);
		M.HealthMultiplier = EffectMultiplier;
		M.Lifespan = ComboLifespan;
		
		//allow Instigator's abilities to affect the monster
		for (Inv = Pawn(Owner).Controller.Inventory; Inv != None; Inv = Inv.Inventory)
		{
			StatsInv = RPGStatsInv(Inv);
			if (StatsInv != None)
				break;
		}
		if (StatsInv == None) //fallback, should never happen
			StatsInv = RPGStatsInv(Pawn(Owner).FindInventoryType(class'RPGStatsInv'));
		if (StatsInv != None) //this should always be the case
		{
			for (x = 0; x < StatsInv.Data.Abilities.length; x++)
			{
				if(ClassIsChildOf(StatsInv.Data.Abilities[x], class'MonsterAbility'))
					class<MonsterAbility>(StatsInv.Data.Abilities[x]).static.ModifyMonster(M, StatsInv.Data.AbilityLevels[x]);
				else
					StatsInv.Data.Abilities[x].static.ModifyPawn(M, StatsInv.Data.AbilityLevels[x]);
			}

			if (FMC.Inventory == None) //should never be the case.
				FMC.Inventory = StatsInv;
			else
			{
				for (Inv = FMC.Inventory; Inv.Inventory != None; Inv = Inv.Inventory)
				{}
				Inv.Inventory = StatsInv;
			}
		}
		for ( C = Level.ControllerList; C != None; C = C.NextController )
			if (C != None && C.Pawn != None && C.IsA('PlayerController') && Pawn(Owner) != None && Pawn(Owner).Controller != None && C.SameTeamAs(Pawn(Owner).Controller))
				PlayerController(C).ClientPlaySound(Sound'DEKRPG209D.ComboSounds.Swarm');
		return M;
	}
	return None;
}

function vector getSpawnLocation(Class<Monster> ChosenMonster)
{
	local float Dist, BestDist;
	local NavigationPoint N, BestDest;

	BestDist = 50000.f;
	for (N = Level.NavigationPointList; N != None; N = N.NextNavigationPoint)
	{
		Dist = VSize(N.Location - Pawn(Owner).Location);
		if (Dist < BestDist && Dist > ChosenMonster.default.CollisionRadius * 2)
		{
			BestDest = N;
			BestDist = VSize(N.Location - Pawn(Owner).Location);
		}
	}

	if (BestDest != None)
		return BestDest.Location + (ChosenMonster.default.CollisionHeight - BestDest.CollisionHeight) * vect(0,0,1);
	else
		return Pawn(Owner).Location + ChosenMonster.default.CollisionHeight * vect(0,0,1.5); //is this why monsters spawn on heads?
}

function rotator getSpawnRotator(Vector SpawnLocation)
{
	local rotator SpawnRotation;
	
	SpawnRotation.Yaw = rotator(SpawnLocation - Pawn(Owner).Location).Yaw;
	return SpawnRotation;
}

defaultproperties
{
}
