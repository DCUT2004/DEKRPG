class EngineerPointsInv extends Inventory
	config(UT2004RPG);

//this class is the summoning nexus for all things that can be summoned by Engineers in DruidsRPG

// values set by abilities
var int TotalSentinelPoints;
var int TotalTurretPoints;
var int TotalVehiclePoints;
var int TotalBuildingPoints;
var int TotalNodePoints;

var int MaxSentinels;
var int MaxTurrets;
var int MaxVehicles;
var int MaxBuildings;
var int MaxNodes;

// for keeping track of what we have summoned
var array<Pawn> SummonedSentinels;
var array<int> SummonedSentinelPoints;
var int UsedSentinelPoints;

var array<Pawn> SummonedTurrets;
var array<int> SummonedTurretPoints;
var int UsedTurretPoints;

var array<Pawn> SummonedVehicles;
var array<int> SummonedVehiclePoints;
var int UsedVehiclePoints;

var array<Pawn> SummonedBuildings;
var array<int> SummonedBuildingPoints;
var int UsedBuildingPoints;

var array<Pawn> SummonedNodes;
var array<int> SummonedNodePoints;
var int UsedNodePoints;

var transient DruidsRPGKeysInteraction InteractionOwner;

var localized string NotEnoughPointsMessage;
var localized string UnableToSpawnMessage;
var localized string TooManyToSpawnMessage;
var localized string NotAtLevel;
var localized string TooManyExtra;

var int PlayerLevel;
var float FastBuildPercent;		// the actual percent of the recovery time to use
var bool HasAutoTurrets;

//client side only
var PlayerController PC;
var Player Player;
var int TimerCount;
var float RecoveryTime;

replication
{
	reliable if (bNetOwner && bNetDirty && Role == ROLE_Authority)
		TotalSentinelPoints, UsedSentinelPoints, TotalTurretPoints, UsedTurretPoints, TotalNodePoints, UsedNodePoints, 
		TotalVehiclePoints, UsedVehiclePoints, TotalBuildingPoints, UsedBuildingPoints, PlayerLevel;
	reliable if (Role == ROLE_Authority)
		SetClientRecoveryTime;
	reliable if (Role<ROLE_Authority)
		LockCommand, UnlockCommand, EjectCommand;
}

function PostBeginPlay()
{
	if(Level.NetMode == NM_DedicatedServer || Level.NetMode == NM_ListenServer || Level.NetMode == NM_Standalone)
		setTimer(5, true);
	super.postBeginPlay();

	if (Level.Game != None && !Level.Game.bAllowVehicles)
		Level.Game.bAllowVehicles = true;
		
}

simulated function PostNetBeginPlay()
{
	if(Level.NetMode != NM_DedicatedServer)
		enable('Tick');

	super.PostNetBeginPlay();
}

function SetRecoveryTime(int RecoveryPeriod)
{
	RecoveryTime = Level.TimeSeconds + (RecoveryPeriod*FastBuildPercent);
	SetClientRecoveryTime(RecoveryPeriod*FastBuildPercent);
}

simulated function SetClientRecoveryTime(int RecoveryPeriod)
{
	// set the recoverytime on the client side for the hud display
	if(Level.NetMode != NM_DedicatedServer)
	{
		RecoveryTime = Level.TimeSeconds + RecoveryPeriod;
	}
}

simulated function int GetRecoveryTime()
{
	 return int(RecoveryTime - Level.TimeSeconds);
}

function Vector GetSpawnHeight(Vector BeaconLocation)
{
	// hack to ensure turrets aren't spawned too high in the air.
	local Vector DownEndLocation;
	local vector HitLocation;
	local vector HitNormal;
	local Actor AHit;
	
	DownEndLocation = BeaconLocation + vect(0,0,-300);

	// See if we hit something.
    	AHit = Trace(HitLocation, HitNormal, DownEndLocation, BeaconLocation, true);
	if (AHit == None || !AHit.bWorldGeometry)
		return vect(0,0,0);		// invalid, nothing to spawn on
	else 
		return HitLocation;
}

function Vector FindCeiling(Vector BeaconLocation)
{
	// hack to ensure turrets aren't spawned too high in the air.
	local Vector UpEndLocation;
	local vector HitLocation;
	local vector HitNormal;
	local Actor AHit;
	
	UpEndLocation = BeaconLocation + vect(0,0,300);

	// See if we hit something.
    	AHit = Trace(HitLocation, HitNormal, UpEndLocation, BeaconLocation, true);
	if (AHit == None || !AHit.bWorldGeometry)
		return vect(0,0,0);		// invalid, nothing to spawn on
	else 
		return HitLocation;
}

simulated function bool AllowedAnotherSentinel()
{
    if (SummonedSentinels.length < MaxSentinels)
        return true;

	return false;
}

simulated function bool AllowedAnotherVehicle()
{
    if (SummonedVehicles.length < MaxVehicles)
        return true;

	return false;
}

simulated function bool AllowedAnotherTurret()
{
    if (SummonedTurrets.length < MaxTurrets)
        return true;

	return false;
}

simulated function bool AllowedAnotherBuilding()
{
    if (SummonedBuildings.length < MaxBuildings)
        return true;

	return false;
}

simulated function bool AllowedAnotherNode()
{
    // TODO - check for total number of map nodes
    
    if (SummonedNodes.length < MaxNodes)
        return true;

	return false;
}

simulated function bool AllowedMoreBuildings(int numReqd)
{
    if (SummonedBuildings.length + numReqd < MaxBuildings)    // blocks often get spawned in groups
        return true;

	return false;
}

function ASTurret SummonBaseSentinel(class<Pawn> ChosenSentinel, int SentinelPoints, Pawn P, Vector SpawnLocation)
{
	local rotator SpawnRotation;

	SpawnRotation = getSpawnRotator(SpawnLocation);

	return SummonRotatedSentinel(ChosenSentinel, SentinelPoints, P, SpawnLocation, SpawnRotation);
}

function ASTurret SummonRotatedSentinel(class<Pawn> ChosenSentinel, int SentinelPoints, Pawn P, Vector SpawnLocation, rotator SpawnRotation)
{
	Local ASTurret S;

	if(TotalSentinelPoints - UsedSentinelPoints < SentinelPoints)
	{
		P.ReceiveLocalizedMessage(MessageClass, 2, None, None, Class);
		return None;
	}

	if(!AllowedAnotherSentinel())
	{
		if (SummonedSentinels.length == 0)
			P.ReceiveLocalizedMessage(MessageClass, 5, None, None, Class);
		else
			P.ReceiveLocalizedMessage(MessageClass, 4, None, None, Class);
		return None;
	}

	S = ASTurret(spawn(ChosenSentinel,,, SpawnLocation, SpawnRotation));
	if(S == None)
	{
		P.ReceiveLocalizedMessage(MessageClass, 3, None, None, Class);
		return None;
	}

	S.SetTeamNum(P.GetTeamNum());
	if (S.Controller != None)
		S.Controller.Destroy();
	S.bAutoTurret=true;
	S.bNonHumanControl=true;

	UsedSentinelPoints += SentinelPoints;
	SummonedSentinels[SummonedSentinels.length] = S;
	SummonedSentinelPoints[SummonedSentinelPoints.length] = SentinelPoints;

	return S;
}

function ASTurret SummonBaseNode(class<Pawn> ChosenNode, int NodePoints, Pawn P, Vector SpawnLocation)
{
	local rotator SpawnRotation;

	SpawnRotation = getSpawnRotator(SpawnLocation);

	return SummonRotatedNode(ChosenNode, NodePoints, P, SpawnLocation, SpawnRotation);
}

function ASTurret SummonRotatedNode(class<Pawn> ChosenNode, int NodePoints, Pawn P, Vector SpawnLocation, rotator SpawnRotation)
{
	Local ASTurret node;

	if(TotalNodePoints - UsedNodePoints < NodePoints)
	{
		P.ReceiveLocalizedMessage(MessageClass, 2, None, None, Class);
		return None;
	}

	if(!AllowedAnotherNode())
	{
		if (SummonedNodes.length == 0)
			P.ReceiveLocalizedMessage(MessageClass, 5, None, None, Class);
		else
			P.ReceiveLocalizedMessage(MessageClass, 4, None, None, Class);
		return None;
	}

	node = ASTurret(spawn(ChosenNode,,, SpawnLocation, SpawnRotation));
	if (node == None)
	{
		P.ReceiveLocalizedMessage(MessageClass, 3, None, None, Class);
		return None;
	}

	node.SetTeamNum(P.GetTeamNum());
	if (node.Controller != None)
		node.Controller.Destroy();
	node.bAutoTurret=true;
	node.bNonHumanControl=true;

	UsedNodePoints += NodePoints;
	SummonedNodes[SummonedNodes.length] = node;
	SummonedNodePoints[SummonedNodePoints.length] = NodePoints;

	return node;
}

function DruidEnergyWall SummonEnergyWall(class<DruidEnergyWall> ChosenEWall, int SentinelPoints, Pawn P, vector SpawnLocation, vector P1Loc, vector P2Loc)
{
	Local DruidEnergyWall E;
	local rotator SpawnRotation;
	local DruidEnergyWallPost Post1,Post2;
	//local vector Normalvect, XVect, YVect, ZVect;

	if(TotalSentinelPoints - UsedSentinelPoints < SentinelPoints)
	{
		P.ReceiveLocalizedMessage(MessageClass, 2, None, None, Class);
		return None;
	}

	if(!AllowedAnotherSentinel())
	{
		if (SummonedSentinels.length == 0)
			P.ReceiveLocalizedMessage(MessageClass, 5, None, None, Class);
		else
			P.ReceiveLocalizedMessage(MessageClass, 4, None, None, Class);
		return None;
	}
	
	// lets create the posts
	Post1 = spawn(ChosenEWall.default.DefaultPost,P,, P1Loc, );
	if (Post1 == None)
	{
		// lets retry a bit further away from the edge
		P1Loc = P1Loc + (10 * Normal(P2Loc - P1Loc));
		Post1 = spawn(ChosenEWall.default.DefaultPost,P,, P1Loc, );
		if (Post1 == None)
		{
			P.ReceiveLocalizedMessage(MessageClass, 3, None, None, Class);
			return None;
		}
	}
	Post2 = spawn(ChosenEWall.default.DefaultPost,P,, P2Loc, );
	if (Post2 == None)
	{
		// lets retry a bit further away from the edge
		P2Loc = P2Loc + (10 * Normal(P1Loc - P2Loc));
		Post2 = spawn(ChosenEWall.default.DefaultPost,P,, P2Loc, );
		if (Post2 == None)
		{
			Post1.Destroy();
			P.ReceiveLocalizedMessage(MessageClass, 3, None, None, Class);
			return None;
		}
	}

	
	// ok, got 2 posts so spawn the wall between
	SpawnRotation = getSpawnRotator(SpawnLocation);
	SpawnLocation = (P1Loc+P2Loc)/2;
    SpawnLocation.z -= 22;

	E = spawn(ChosenEWall,P,,SpawnLocation,SpawnRotation);	// position halfway between the posts
	if (E == None)
	{	
		Post1.Destroy();
		Post2.Destroy();
		P.ReceiveLocalizedMessage(MessageClass, 3, None, None, Class);
		return None;
	}

	E.P1Loc = P1Loc;
	E.P2Loc = P2Loc;
	E.SetTeamNum(P.GetTeamNum());
	if (E.Controller != None)
		E.Controller.Destroy();

	UsedSentinelPoints += SentinelPoints;
	SummonedSentinels[SummonedSentinels.length] = E;
	SummonedSentinelPoints[SummonedSentinelPoints.length] = SentinelPoints;

	return E;
}

function Vehicle SummonTurret(class<Pawn> ChosenTurret, int TurretPoints, Pawn P, Vector SpawnLocation)
{
	local rotator SpawnRotation;

	SpawnRotation = getSpawnRotator(SpawnLocation);
	
	return SummonRotatedTurret(ChosenTurret, TurretPoints, P, SpawnLocation, SpawnRotation);

}

function Vehicle SummonRotatedTurret(class<Pawn> ChosenTurret, int TurretPoints, Pawn P, Vector SpawnLocation, rotator SpawnRotation)
{
	Local Vehicle T;

	if(TotalTurretPoints - UsedTurretPoints < TurretPoints)
	{
		P.ReceiveLocalizedMessage(MessageClass, 2, None, None, Class);
		return None;
	}

	if(!AllowedAnotherTurret())
	{
		if (SummonedTurrets.length == 0)
			P.ReceiveLocalizedMessage(MessageClass, 5, None, None, Class);
		else
			P.ReceiveLocalizedMessage(MessageClass, 4, None, None, Class);
		return None;
	}

	T = Vehicle(spawn(ChosenTurret,,, SpawnLocation, SpawnRotation));
	if(T == None)
	{
		P.ReceiveLocalizedMessage(MessageClass, 3, None, None, Class);
		return None;
	}

	T.SetTeamNum(P.GetTeamNum());
	if (T.Controller != None)
		T.Controller.Destroy();

	UsedTurretPoints += TurretPoints;
	SummonedTurrets[SummonedTurrets.length] = T;
	SummonedTurretPoints[SummonedTurretPoints.length] = TurretPoints;

	return T;
}

function Vehicle SummonVehicle(class<Pawn> ChosenVehicle, int VehiclePoints, Pawn P, Vector SpawnLocation)
{
	Local Vehicle V;
	local rotator SpawnRotation;

	if(TotalVehiclePoints - UsedVehiclePoints < VehiclePoints)
	{
		P.ReceiveLocalizedMessage(MessageClass, 2, None, None, Class);
		return None;
	}

	if(!AllowedAnotherVehicle())
	{
		if (SummonedVehicles.length == 0)
			P.ReceiveLocalizedMessage(MessageClass, 5, None, None, Class);
		else
			P.ReceiveLocalizedMessage(MessageClass, 4, None, None, Class);
		return None;
	}

	SpawnRotation = getSpawnRotator(SpawnLocation);

	V = Vehicle(spawn(ChosenVehicle,,, SpawnLocation, SpawnRotation));
	if(V == None)
	{
		P.ReceiveLocalizedMessage(MessageClass, 3, None, None, Class);
		return None;
	}

	V.SetTeamNum(P.GetTeamNum());

	if (V.Controller != None)
		V.Controller.Destroy();

	UsedVehiclePoints += VehiclePoints;
	SummonedVehicles[SummonedVehicles.length] = V;
	SummonedVehiclePoints[SummonedVehiclePoints.length] = VehiclePoints;

	return V;
}

function Vehicle SummonBuilding(class<Pawn> ChosenBuilding, int BuildingPoints, Pawn P, Vector SpawnLocation)
{
	Local Vehicle B;
	local rotator SpawnRotation;

	if(TotalBuildingPoints - UsedBuildingPoints < BuildingPoints)
	{
		P.ReceiveLocalizedMessage(MessageClass, 2, None, None, Class);
		return None;
	}

	if(!AllowedAnotherBuilding())
	{
		if (SummonedBuildings.length == 0)
			P.ReceiveLocalizedMessage(MessageClass, 5, None, None, Class);
		else
			P.ReceiveLocalizedMessage(MessageClass, 4, None, None, Class);
		return None;
	}

	SpawnRotation = getSpawnRotator(SpawnLocation);

	B = Vehicle(spawn(ChosenBuilding,,, SpawnLocation, SpawnRotation));
	if(B == None)
	{
		P.ReceiveLocalizedMessage(MessageClass, 3, None, None, Class);
		return None;
	}

	B.SetTeamNum(P.GetTeamNum());
	if (B.Controller != None)
		B.Controller.Destroy();

	UsedBuildingPoints += BuildingPoints;
	SummonedBuildings[SummonedBuildings.length] = B;
	SummonedBuildingPoints[SummonedBuildingPoints.length] = BuildingPoints;
	
	return B;
}

function DruidBlock SummonBlock(class<Pawn> ChosenBuilding, int BuildingPoints, Pawn P, Vector SpawnLocation, rotator SpawnRotation)
{
	Local DruidBlock B;

	if(TotalBuildingPoints - UsedBuildingPoints < BuildingPoints)
	{
		P.ReceiveLocalizedMessage(MessageClass, 2, None, None, Class);
		return None;
	}

	if(!AllowedAnotherBuilding())
	{
		if (SummonedBuildings.length == 0)
			P.ReceiveLocalizedMessage(MessageClass, 5, None, None, Class);
		else
			P.ReceiveLocalizedMessage(MessageClass, 4, None, None, Class);
		return None;
	}

	B = DruidBlock(spawn(ChosenBuilding,,, SpawnLocation, SpawnRotation));
	if(B == None)
	{
		P.ReceiveLocalizedMessage(MessageClass, 3, None, None, Class);
		return None;
	}

	B.SetTeamNum(P.GetTeamNum());
	if (B.Controller != None)
		B.Controller.Destroy();

	UsedBuildingPoints += BuildingPoints;
	SummonedBuildings[SummonedBuildings.length] = B;
	SummonedBuildingPoints[SummonedBuildingPoints.length] = BuildingPoints;
	
	return B;
}

function bool CheckMultiBlock(int BuildingPoints, int numBlocks, Pawn P)
{

	if(TotalBuildingPoints - UsedBuildingPoints < BuildingPoints)
	{
		P.ReceiveLocalizedMessage(MessageClass, 2, None, None, Class);
		return false;
	}

	if(!AllowedMoreBuildings(numBlocks))
	{
		if (SummonedBuildings.length == 0)
			P.ReceiveLocalizedMessage(MessageClass, 5, None, None, Class);
		else
			P.ReceiveLocalizedMessage(MessageClass, 6, None, None, Class);
		return false;
	}

	return true;
}

function DruidExplosive SummonExplosive(class<Pawn> ChosenExp, int BuildingPoints, Pawn P, Vector SpawnLocation, rotator SpawnRotation)
{
	Local DruidExplosive Expl;

	if(TotalBuildingPoints - UsedBuildingPoints < BuildingPoints)
	{
		P.ReceiveLocalizedMessage(MessageClass, 2, None, None, Class);
		return None;
	}

	if(!AllowedAnotherBuilding())
	{
		if (SummonedBuildings.length == 0)
			P.ReceiveLocalizedMessage(MessageClass, 5, None, None, Class);
		else
			P.ReceiveLocalizedMessage(MessageClass, 4, None, None, Class);
		return None;
	}

	Expl = DruidExplosive(spawn(ChosenExp,,, SpawnLocation, SpawnRotation));
	if(Expl == None)
	{
		P.ReceiveLocalizedMessage(MessageClass, 3, None, None, Class);
		return None;
	}

	Expl.SetTeamNum(P.GetTeamNum());
	if (Expl.Controller != None)
		Expl.Controller.Destroy();

	UsedBuildingPoints += BuildingPoints;
	SummonedBuildings[SummonedBuildings.length] = Expl;
	SummonedBuildingPoints[SummonedBuildingPoints.length] = BuildingPoints;
	
	return Expl;
}

//timer checks for dead minions and resets the cooldown period after summoning.
function Timer()
{
	local int i;
	local RPGStatsInv StatsInv;
	
	for(i = 0; i < SummonedSentinels.length; i++)
	{
		if(SummonedSentinels[i] == None || SummonedSentinels[i].health <= 0)
		{
			UsedSentinelPoints -= SummonedSentinelPoints[i];
			if(UsedSentinelPoints < 0)
			{
				Warn("Sentinel Points less than zero!");
				UsedSentinelPoints = 0; //just an emergency checkertrap in case something interesting happens
			}
			SummonedSentinels.remove(i, 1);
			SummonedSentinelPoints.remove(i, 1);
			i--;
		}
	}
	for(i = 0; i < SummonedTurrets.length; i++)
	{
		if(SummonedTurrets[i] == None || SummonedTurrets[i].health <= 0)
		{
			UsedTurretPoints -= SummonedTurretPoints[i];
			if(UsedTurretPoints < 0)
			{
				Warn("Turret Points less than zero!");
				UsedTurretPoints = 0; //just an emergency checkertrap in case something interesting happens
			}
			SummonedTurrets.remove(i, 1);
			SummonedTurretPoints.remove(i, 1);
			i--;
		}
	}
	for(i = 0; i < SummonedVehicles.length; i++)
	{
		if(SummonedVehicles[i] == None || SummonedVehicles[i].health <= 0)
		{
			UsedVehiclePoints -= SummonedVehiclePoints[i];
			if(UsedVehiclePoints < 0)
			{
				Warn("Vehicle Points less than zero!");
				UsedVehiclePoints = 0; //just an emergency checkertrap in case something interesting happens
			}
			SummonedVehicles.remove(i, 1);
			SummonedVehiclePoints.remove(i, 1);
			i--;
		}
	}
	for(i = 0; i < SummonedBuildings.length; i++)
	{
		if(SummonedBuildings[i] == None || SummonedBuildings[i].health <= 0)
		{
			UsedBuildingPoints -= SummonedBuildingPoints[i];
			if(UsedBuildingPoints < 0)
			{
				Warn("Building Points less than zero!");
				UsedBuildingPoints = 0; //just an emergency checkertrap in case something interesting happens
			}
			SummonedBuildings.remove(i, 1);
			SummonedBuildingPoints.remove(i, 1);
			i--;
		}
	}
	for(i = 0; i < SummonedNodes.length; i++)
	{
		if(SummonedNodes[i] == None || SummonedNodes[i].health <= 0)
		{
			UsedNodePoints -= SummonedNodePoints[i];
			if(UsedNodePoints < 0)
			{
				Warn("Node Points less than zero!");
				UsedNodePoints = 0; //just an emergency checkertrap in case something interesting happens
			}
			SummonedNodes.remove(i, 1);
			SummonedNodePoints.remove(i, 1);
			i--;
		}
	}


	// now also check if player level has changed
	if (Role == ROLE_Authority && Instigator != None)
	{
		StatsInv = RPGStatsInv(Instigator.FindInventoryType(class'RPGStatsInv'));
		if (StatsInv != None && StatsInv.Data.Level>PlayerLevel)
			PlayerLevel = StatsInv.Data.Level;
	}
}

function rotator getSpawnRotator(Vector SpawnLocation)
{
	local rotator SpawnRotation;

	SpawnRotation.Yaw = rotator(SpawnLocation - Instigator.Location).Yaw;
	return SpawnRotation;
}

static function EjectPlayers(Pawn P)
{
	local EngineerPointsInv EPI;
	local Pawn pd;
	local Inventory Inv;
	local int i;

	if (P == None)
		return;

	// ok, lets try it
	if (Vehicle(P) != None)
		pd = Vehicle(P).Driver;
	else
		pd = P;
		
	i = 0;
	for (inv = pd.Inventory; inv != None && i<500; inv = inv.Inventory)		// do manual find as FindInventoryType a bit dodgy here?
	{
		if (ClassIsChildOf(Inv.Class, class'EngineerPointsInv'))
		{
			EPI = EngineerPointsInv(inv);
			i = 500;		// break
		}
		i++;
	}
	if (EPI == None)
	{
		// dont think it will work, but let's try
		EPI = EngineerPointsInv(pd.FindInventoryType(class'EngineerPointsInv'));
	}
	if (EPI != None)
		EPI.EjectCommand();
}


function EjectCommand()
{
	local int i,x;
	local vehicle v;
	local ONSVehicle ov;
	local Pawn OP;
	local PlayerController tpc;
	
	if (Instigator != None)
		OP = Instigator;

	for(i = 0; i < SummonedTurrets.length; i++)
	{
		v = Vehicle(SummonedTurrets[i]);
		if (v != None && v.Driver != None)
		{
			if (OP == None)
				OP = Pawn(Vehicle(SummonedTurrets[i]).Owner);

			tpc = None;
			if(v.Controller != None && PlayerController(v.Controller) != None && OP != None)	
				tpc = PlayerController(v.Controller);
			
			v.EjectDriver();

			if (tpc != None)
				tpc.ReceiveLocalizedMessage(class'EjectMessage', 0, OP.PlayerReplicationInfo);
		}
	}

	for(i = 0; i < SummonedVehicles.length; i++)
	{
		v = Vehicle(SummonedVehicles[i]);
		if (v != None)
		{ 
			if (OP == None)
				OP = Pawn(Vehicle(SummonedVehicles[i]).Owner);

			if (v.Driver != None)
			{
				tpc = None;
				if(v.Controller != None && PlayerController(v.Controller) != None && OP != None)	
					tpc = PlayerController(v.Controller);
			
				v.EjectDriver();

				if (tpc != None)
					tpc.ReceiveLocalizedMessage(class'EjectMessage', 0, OP.PlayerReplicationInfo);
			}
			// if it is a ONSVehicle like a HellBender, then could have multiple players in
			ov = ONSVehicle(SummonedVehicles[i]);
			if (ov != None)
				for (x = 0; x < ov.WeaponPawns.length; x++)
				{
					if (ov.WeaponPawns[x] != None && ov.WeaponPawns[x].Controller != None)
					{
						tpc = None;
						if (PlayerController(ov.WeaponPawns[x].Controller) != None && OP != None)	
							tpc = PlayerController(ov.WeaponPawns[x].Controller);
					
						ov.WeaponPawns[x].EjectDriver();

						if (tpc != None)
							tpc.ReceiveLocalizedMessage(class'EjectMessage', 0, OP.PlayerReplicationInfo);
					}
				}
		}
	}
}

static function LockVehicle(Pawn P)
{
	local EngineerPointsInv EPI;
	local Pawn pd;
	local Inventory Inv;
	local int i;

	if (P == None)
		return;

	// ok, lets try it
	if (Vehicle(P) != None)
		pd = Vehicle(P).Driver;
	else
		pd = P;

	i = 0;
	for (inv = pd.Inventory; inv != None && i<500; inv = inv.Inventory)		// do manual find as FindInventoryType a bit dodgy here?
	{
		if (ClassIsChildOf(Inv.Class, class'EngineerPointsInv'))
		{
			EPI = EngineerPointsInv(inv);
			i = 500;		// break
		}
		i++;
	}
	if (EPI == None)
	{
		// dont think it will work, but let's try
		EPI = EngineerPointsInv(pd.FindInventoryType(class'EngineerPointsInv'));
	}
	if (EPI != None)
		EPI.LockCommand();
}


static function UnlockVehicle(Pawn P)
{
	local EngineerPointsInv EPI;
	local Pawn pd;
	local Inventory Inv;
	local int i;

	if (P == None)
		return;

	// ok, lets try it
	if (Vehicle(P) != None)
		pd = Vehicle(P).Driver;
	else
		pd = P;

	i = 0;
	for (inv = pd.Inventory; inv != None && i<500; inv = inv.Inventory)		// do manual find as FindInventoryType a bit dodgy here?
	{
		if (ClassIsChildOf(Inv.Class, class'EngineerPointsInv'))
		{
			EPI = EngineerPointsInv(inv);
			i = 500;		// break
		}
		i++;
	}
	if (EPI == None)
	{
		// dont think it will work, but let's try
		EPI = EngineerPointsInv(pd.FindInventoryType(class'EngineerPointsInv'));
	}
	if (EPI != None)
		EPI.UnlockCommand();
}

function UnlockThisVehicle(vehicle v)
{
	// set this vehicle to be unlocked
	if (DruidMinigunTurret(v) != None )
	    DruidMinigunTurret(v).EngineerUnlock();
	else if (DruidLinkTurret(v) != None)
	    DruidLinkTurret(v).EngineerUnlock();
	else if (DruidBallTurret(v) != None)
	    DruidBallTurret(v).EngineerUnlock();
	else if (DruidEnergyTurret(v) != None)
	    DruidEnergyTurret(v).EngineerUnlock();
	else if (DEKLynxTurret(v) != None)
	    DEKLynxTurret(v).EngineerUnlock();
	else if (DEKOdinTurret(v) != None)
	    DEKOdinTurret(v).EngineerUnlock();
	else if (DEKSolarTurret(v) != None)
	    DEKSolarTurret(v).EngineerUnlock();
	else if (DruidIonCannon(v) != None)
	    DruidIonCannon(v).EngineerUnlock();
	else if (DruidGoliath(v) != None)
	    DruidGoliath(v).EngineerUnlock();
	else if (DruidHellBender(v) != None)
	    DruidHellBender(v).EngineerUnlock();
	else if (DruidScorpion(v) != None)
	    DruidScorpion(v).EngineerUnlock();
	else if (DruidPaladin(v) != None)
	    DruidPaladin(v).EngineerUnlock();
	else if (DruidManta(v) != None)
	    DruidManta(v).EngineerUnlock();
	else if (DruidIonTank(v) != None)
	    DruidIonTank(v).EngineerUnlock();
	else if (DruidTC(v) != None)
	    DruidTC(v).EngineerUnlock();
	else if (DEKRaptor(v) != None)
	    DEKRaptor(v).EngineerUnlock();
	else if (DEKTank(v) != None)
	    DEKTank(v).EngineerUnlock();
	else if (DEKLynxVehicle(v) != None)
	    DEKLynxVehicle(v).EngineerUnlock();
	else if (DEKLightningTurret(v) != None)
	    DEKLightningTurret(v).EngineerUnlock();
	else if (DEKPlasmaTurret(v) != None)
	    DEKPlasmaTurret(v).EngineerUnlock();
	else if (DEKStingerTurret(v) != None)
	    DEKStingerTurret(v).EngineerUnlock();
	else if (DEKSkyMineTurret(v) != None)
	    DEKSkyMineTurret(v).EngineerUnlock();
	else if (BaseBallTurret(v) != None)
	    BaseBallTurret(v).EngineerUnlock();
}

function LockThisVehicle(vehicle v)
{
	local vehicle loopv;
	local int i;
	
	// first free off any already locked vehicles for this player
	for(i = 0; i < SummonedTurrets.length; i++)
	{
		loopv = Vehicle(SummonedTurrets[i]);
		if (loopv != None && loopv.Health>0 && loopv != v)
		{
		    // unock it
		    UnlockThisVehicle(loopv);
		}
	}
	for(i = 0; i < SummonedVehicles.length; i++)
	{
		loopv = Vehicle(SummonedVehicles[i]);
		if (loopv != None && loopv.Health>0 && loopv != v)
		{
		    // unlock it
		    UnlockThisVehicle(loopv);
		}
	}
	// now set it to locked
	if (DruidMinigunTurret(v) != None)
	    DruidMinigunTurret(v).EngineerLock();
	else if (DruidLinkTurret(v) != None)
	    DruidLinkTurret(v).EngineerLock();
	else if (DruidBallTurret(v) != None)
	    DruidBallTurret(v).EngineerLock();
	else if (DruidEnergyTurret(v) != None)
	    DruidEnergyTurret(v).EngineerLock();
	else if (DEKLynxTurret(v) != None)
	    DEKLynxTurret(v).EngineerLock();
	else if (DEKOdinTurret(v) != None)
	    DEKOdinTurret(v).EngineerLock();
	else if (DEKSolarTurret(v) != None)
	    DEKSolarTurret(v).EngineerLock();
	else if (DruidIonCannon(v) != None)
	    DruidIonCannon(v).EngineerLock();
	else if (DruidGoliath(v) != None)
	    DruidGoliath(v).EngineerLock();
	else if (DruidHellBender(v) != None)
	    DruidHellBender(v).EngineerLock();
	else if (DruidScorpion(v) != None)
	    DruidScorpion(v).EngineerLock();
	else if (DruidPaladin(v) != None)
	    DruidPaladin(v).EngineerLock();
	else if (DruidManta(v) != None)
	    DruidManta(v).EngineerLock();
	else if (DruidIonTank(v) != None)
	    DruidIonTank(v).EngineerLock();
	else if (DruidTC(v) != None)
	    DruidTC(v).EngineerLock();
	else if (DEKRaptor(v) != None)
	    DEKRaptor(v).EngineerLock();
	else if (DEKTank(v) != None)
	    DEKTank(v).EngineerLock();
	else if (DEKLynxVehicle(v) != None)
	    DEKLynxVehicle(v).EngineerLock();
	else if (DEKLightningTurret(v) != None)
	    DEKLightningTurret(v).EngineerLock();
	else if (DEKPlasmaTurret(v) != None)
	    DEKPlasmaTurret(v).EngineerLock();
	else if (DEKStingerTurret(v) != None)
	    DEKStingerTurret(v).EngineerLock();
	else if (DEKSkyMineTurret(v) != None)
	    DEKSkyMineTurret(v).EngineerUnlock();
	else if (BaseBallTurret(v) != None)
	    BaseBallTurret(v).EngineerUnlock();
}

function LockCommand()
{
	local Pawn PawnOwner;
	local Vector FaceDir;
	local Vector EndLocation;
	local vector HitLocation;
	local vector HitNormal;
	local Actor AHit;
	local vehicle v, loopv;
	local Vector StartTrace;
	local int i;

	PawnOwner = Pawn(Owner);
	if (PawnOwner == None || PawnOwner.Controller == None)
		return;

	// now find what looking at
	FaceDir = Vector(PawnOwner.Controller.GetViewRotation());
	StartTrace = PawnOwner.Location + PawnOwner.EyePosition();
	EndLocation = StartTrace + (FaceDir * 5000.0);

	// See if we hit something.
   	AHit = Trace(HitLocation, HitNormal, EndLocation, StartTrace, true);
	if ((AHit == None) || (vehicle(AHit) == None))
		return;	// didn't hit an enemy

	v = Vehicle(AHit);
	if ( v != PawnOwner && v.Health > 0 )
	{
		// hit a vehicle. Now is it one we spawned?
		for(i = 0; i < SummonedTurrets.length; i++)
		{
			loopv = Vehicle(SummonedTurrets[i]);
			if (loopv != None && loopv.Health>0 && loopv == v)
			{
			    // found it so lock it
			    LockThisVehicle(loopv);
			}
		}

		for(i = 0; i < SummonedVehicles.length; i++)
		{
			loopv = Vehicle(SummonedVehicles[i]);
			if (loopv != None && loopv.Health>0 && loopv == v)
			{
			    // found it so lock it
			    LockThisVehicle(loopv);
			}
		}

		// and show it is locked.
	}
}

function UnlockCommand()
{
	local Pawn PawnOwner;
	local Vector FaceDir;
	local Vector EndLocation;
	local vector HitLocation;
	local vector HitNormal;
	local Actor AHit;
	local vehicle v, loopv;
	local Vector StartTrace;
	local int i;


	PawnOwner = Pawn(Owner);
	if (PawnOwner == None || PawnOwner.Controller == None)
		return;

	// now find what looking at
	FaceDir = Vector(PawnOwner.Controller.GetViewRotation());
	StartTrace = PawnOwner.Location + PawnOwner.EyePosition();
	EndLocation = StartTrace + (FaceDir * 5000.0);

	// See if we hit something.
   	AHit = Trace(HitLocation, HitNormal, EndLocation, StartTrace, true);
	if ((AHit == None) || (vehicle(AHit) == None))
		return;	// didn't hit an enemy

	v = Vehicle(AHit);
	if ( v != PawnOwner && v.Health > 0 )
	{
		// hit a vehicle. Now is it one we spawned?
		for(i = 0; i < SummonedTurrets.length; i++)
		{
			loopv = Vehicle(SummonedTurrets[i]);
			if (loopv != None && loopv.Health>0 && loopv == v)
			{
			    // found it so lock it
			    UnlockThisVehicle(loopv);
			}
		}

		for(i = 0; i < SummonedVehicles.length; i++)
		{
			loopv = Vehicle(SummonedVehicles[i]);
			if (loopv != None && loopv.Health>0 && loopv == v)
			{
			    // found it so lock it
			    UnlockThisVehicle(loopv);
			}
		}

		// and show it is unlocked.
	}
}

function KillAllSentinels()
{
	local int i;
	
	for(i = 0; i < SummonedSentinels.length ; i++)
		KillSentinel(i);
	SummonedSentinels.Length = 0;
}

function KillSentinel(int i)
{
	if (i < 0 || i >= SummonedSentinels.Length || SummonedSentinels.length == 0)
		return; //nothing to kill

	if(SummonedSentinels[i] != None)
	{
		if (Vehicle(SummonedSentinels[0]) != None && Vehicle(SummonedSentinels[0]).Driver != None)
			Vehicle(SummonedSentinels[0]).EjectDriver();
		SummonedSentinels[i].Health = 0;
		SummonedSentinels[i].LifeSpan = 0.1 * (i + 1); //so the server will do it in it's own time and not all at once...
		
		UsedSentinelPoints -= SummonedSentinelPoints[i];
		if(UsedSentinelPoints < 0)
		{
			Warn("Sentinel Points less than zero!");
			UsedSentinelPoints = 0; //just an emergency checkertrap in case something interesting happens
		}
	}
}

function KillAllNodes()
{
	local int i;
	
	for(i = 0; i < SummonedNodes.Length; i++)
		KillNode(i);
	SummonedNodes.Length = 0;
}

function KillNode(int i)
{
	if(i < 0 || i >= SummonedNodes.length || SummonedNodes.length == 0)
		return; //nothing to kill
	if(SummonedNodes[i] != None)
	{
		if (Vehicle(SummonedNodes[i]) != None && Vehicle(SummonedNodes[i]).Driver != None)
			Vehicle(SummonedNodes[i]).EjectDriver();
		SummonedNodes[i].Health = 0;
		SummonedNodes[i].LifeSpan = 0.1 * (i + 1); //so the server will do it in it's own time and not all at once...
	}		
		
	UsedNodePoints -= SummonedNodePoints[i];
	if(UsedNodePoints < 0)
	{
		Warn("Node Points less than zero!");
		UsedNodePoints = 0; //just an emergency checkertrap in case something interesting happens
	}
}

function KillAllTurrets()
{
	local int i;
	
	// note that if a turret is occupied we cannot kill it
	for(i = 0; i < SummonedTurrets.Length; i++)
		KillTurret(i);
	SummonedTurrets.Length = 0;
}

function KillTurret(int i)
{
	if(i < 0 || i >= SummonedTurrets.Length || SummonedTurrets.Length == 0)
		return; //nothing to kill
	if(SummonedTurrets[i] != None && Vehicle(SummonedTurrets[i]) != None && Vehicle(SummonedTurrets[i]).Driver == None)
	{
	    // turret not occupied, so delete it
		SummonedTurrets[i].Health = 0;
		SummonedTurrets[i].LifeSpan = 0.1 * (i + 1); //so the server will do it in it's own time and not all at once...
		
		UsedTurretPoints -= SummonedTurretPoints[i];
		if(UsedTurretPoints < 0)
		{
			Warn("Turret Points less than zero!");
			UsedTurretPoints = 0; //just an emergency checkertrap in case something interesting happens
		}
	}
}

function KillAllVehicles()
{
	local int i;
	
	for(i = 0; i < SummonedVehicles.Length; i++)
		KillVehicle(i);
	SummonedVehicles.Length = 0;
}

function KillVehicle(int i)
{
	if(i < 0 || i >= SummonedVehicles.Length || SummonedVehicles.Length == 0)
		return; //nothing to kill
	if(SummonedVehicles[i] != None && Vehicle(SummonedVehicles[i]) != None && Vehicle(SummonedVehicles[i]).Driver == None)
	{
	    // vehicle not occupied (at least not in main driver position), so delete it
		SummonedVehicles[i].Health = 0;
		SummonedVehicles[i].LifeSpan = 0.1 * (i + 1); //so the server will do it in it's own time and not all at once...
		
		UsedVehiclePoints -= SummonedVehiclePoints[i];
		if(UsedVehiclePoints < 0)
		{
			Warn("Vehicle Points less than zero!");
			UsedVehiclePoints = 0; //just an emergency checkertrap in case something interesting happens
		}
	}
}

function KillAllBuildings()
{
	local int i;

	
	for(i = 0; i < SummonedBuildings.Length; i++)
		KillBuilding(i);
	SummonedBuildings.Length = 0;
}

function KillBuilding(int i)
{
	if(i < 0 || i >= SummonedBuildings.Length || SummonedBuildings.Length == 0)
		return; //nothing to kill
	if(SummonedBuildings[i] != None)
	{
		if (Vehicle(SummonedBuildings[i]) != None && Vehicle(SummonedBuildings[i]).Driver != None)
			Vehicle(SummonedBuildings[i]).EjectDriver();
		SummonedBuildings[i].Health = 0;
		SummonedBuildings[i].LifeSpan = 0.1 * (i + 1); //so the server will do it in it's own time and not all at once...
	}		
		
	UsedBuildingPoints -= SummonedBuildingPoints[i];
	if(UsedBuildingPoints < 0)
	{
		Warn("Building Points less than zero!");
		UsedBuildingPoints = 0; //just an emergency checkertrap in case something interesting happens
	}
}

simulated function Destroyed()
{	
	local int i;
	
	if(Level.NetMode == NM_DedicatedServer || Level.NetMode == NM_ListenServer || Level.NetMode == NM_Standalone)
	{
		setTimer(0, false);
		KillAllNodes();
		KillAllSentinels();
		for(i = 0; i < SummonedVehicles.length; i++)
			if(SummonedVehicles[i] != None)
			{
				if (Vehicle(SummonedVehicles[i]) != None && Vehicle(SummonedVehicles[i]).Driver != None)
					Vehicle(SummonedVehicles[i]).EjectDriver();
			}
		KillAllVehicles();
		for(i = 0; i < SummonedTurrets.length; i++)
			if(SummonedTurrets[i] != None)
			{
				if (Vehicle(SummonedTurrets[i]) != None && Vehicle(SummonedTurrets[i]).Driver != None)
					Vehicle(SummonedTurrets[i]).EjectDriver();
			}
		KillAllTurrets();
		KillAllBuildings();
	}
	
 	if( InteractionOwner != None )
 	{
 		InteractionOwner.EInv = None;
 		InteractionOwner = None;
 	}
	
	super.Destroyed();
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 2)
		return Default.NotEnoughPointsMessage;
	if (Switch == 3)
		return Default.UnableToSpawnMessage;
	if (Switch == 4)
		return Default.TooManyToSpawnMessage;
	if (Switch == 5)
		return Default.NotAtLevel;
	if (Switch == 6)
		return Default.TooManyExtra;

	return Super.GetLocalString(Switch, RelatedPRI_1, RelatedPRI_2);
}

defaultproperties
{
     NotEnoughPointsMessage="Insufficent points available to summon this."
     UnableToSpawnMessage="Unable to spawn."
     TooManyToSpawnMessage="You have summoned too many of these. You must kill one before you can summon another one."
     NotAtLevel="You need to be a higher level to spawn one of these"
     TooManyExtra="You cannot spawn this many extra items"
     FastBuildPercent=1.000000
     MessageClass=Class'UnrealGame.StringMessagePlus'
}
