class DruidNodeSummon extends Summonifact
	config(UT2004RPG);

function bool SpawnIt(TranslocatorBeacon Beacon, Pawn P, EngineerPointsInv epi)
{
	Local Node NewNode;
	local NodeController NC;
	local Vector SpawnLoc,SpawnLocCeiling;
	local bool bGotSpace;
	local class<Pawn> RealSummonItem;
	local rotator SpawnRotation;
	local bool bOnCeiling;

	RealSummonItem = SummonItem;
	SpawnLoc = epi.GetSpawnHeight(Beacon.Location);	// look at the floor
	bOnCeiling = false;

	bGotSpace = CheckSpace(SpawnLoc,150,180);
	if (ClassIsChildOf(SummonItem,class'Node'))
	{
		// need to check if ceiling variant is required
		SpawnLocCeiling = epi.FindCeiling(Beacon.Location);	// its a ceiling sentinel - special case.
		if (SpawnLocCeiling != vect(0,0,0) 
			&& (SpawnLoc == vect(0,0,0) || VSize(SpawnLocCeiling - Beacon.Location) < VSize(SpawnLoc - Beacon.Location)))
		{
			// its the ceiling one we want
			bOnCeiling = true;
            
            // TODO set RealSummonItem to ceiling version

			SpawnLoc = SpawnLocCeiling;
			bGotSpace = CheckSpace(SpawnLoc,120,-160);
		}
	}
	if (SpawnLoc == vect(0,0,0))
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 4000, None, None, Class);
		bActive = false;
		GotoState('');
		return false;
	}
	if (!bGotSpace)
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 6000, None, None, Class);
		bActive = false;
		GotoState('');
		return false;
	}

	if (RealSummonItem == class'Node')
	{	// its a node

		if (!class'NodeNetwork'.static.CanSpawnNode(SpawnLoc))
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 7000, None, None, Class);
			bActive = false;
			GotoState('');
			return false;
		}
		if (bOnCeiling)
		{
			SpawnLoc.z -= 70;		// leave on ceiling
			SpawnRotation.Yaw = 0;
			SpawnRotation.Roll = 32768;          // upside down
			NewNode = Node(epi.SummonRotatedNode(SummonItem, Points, P, SpawnLoc,SpawnRotation));
		}
		else
		{
			SpawnLoc.z += 67;		// lift just off ground, and then base steps back a bit
			SpawnRotation.Yaw = 32768;
			NewNode =  Node(epi.SummonRotatedNode(SummonItem, Points, P, SpawnLoc,SpawnRotation));
		}
		if (NewNode == None)
			return false;
		SetStartHealth(NewNode);

		// let's add the Node controller
		if ( Role == Role_Authority )
		{
			NC = spawn(class'NodeController');
			if ( NC != None )
			{
				NC.SetPlayerSpawner(Instigator.Controller);
				NC.Possess(NewNode);

				// now allow player to get xp bonus
				ApplyStatsToConstruction(NewNode,Instigator);
			}
		}
		Class'NodeNetwork'.static.InsertNode(NewNode);
	}

	return true;
}

function BotConsider()
{
	return;		// bots do not summon nodes
}

defaultproperties
{
     IconMaterial=Texture'DEKRPGTexturesMaster209B.Artifacts.SummonBlockIcon'
     ItemName=""
}
