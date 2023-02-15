class NodeController extends Controller
	config(UT2004RPG);

var Controller PlayerSpawner;
var RPGStatsInv StatsInv;
var MutUT2004RPG RPGMut;

var config float TimeBetweenChecks;
var config float CheckRadius;

var int SecondCount;
var int EnemyCount;
var int NumberIdleSpawns;
var int innerloop;

simulated event PostBeginPlay()
{
	local Mutator m;

	super.PostBeginPlay();

	if (Level.Game != None)
		for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
			if (MutUT2004RPG(m) != None)
			{
				RPGMut = MutUT2004RPG(m);
				break;
			}
}

function SetPlayerSpawner(Controller PlayerC)
{
	PlayerSpawner = PlayerC;
	if (PlayerSpawner.PlayerReplicationInfo != None && PlayerSpawner.PlayerReplicationInfo.Team != None )
	{
		if (PlayerReplicationInfo == None)
			PlayerReplicationInfo = spawn(class'PlayerReplicationInfo', self);
		PlayerReplicationInfo.PlayerName = PlayerSpawner.PlayerReplicationInfo.PlayerName$"'s Sentinel";
		PlayerReplicationInfo.bIsSpectator = true;
		PlayerReplicationInfo.bBot = true;
		PlayerReplicationInfo.Team = PlayerSpawner.PlayerReplicationInfo.Team;
		PlayerReplicationInfo.RemoteRole = ROLE_None;
		StatsInv = RPGStatsInv(PlayerSpawner.Pawn.FindInventoryType(class'RPGStatsInv'));

	}
	SetTimer(TimeBetweenChecks, true);
    SecondCount = 0;
    EnemyCount = 0;
    NumberIdleSpawns = 0;
    innerloop = 0;
}

function Timer()
{
	// lets see if we can link to anything
	Local Pawn LoopP;
    Local HealthCharger LoopHC;
    Local HealthPack LoopHP;
    Local HealthCharger LoopHCR;
	Local Controller C;
    local int NumberOfHealthSpawns;
    local xPickupBase LoopPB;

	if (Pawn == None || PlayerSpawner == None)
	    return;
	    
    NumberOfHealthSpawns = 0;

    innerloop++;
    if (innerloop >= 3)
    {   // every 3 secs check for how many enemies we see
    	foreach DynamicActors(class'Pawn', LoopP)
    	{
    		// first check if the pawn is anywhere near
    	    if (LoopP != None &&  LoopP.Health > 0 && Pawn != None && VSize(LoopP.Location - Pawn.Location) < CheckRadius && FastTrace(LoopP.Location, Pawn.Location) && LoopP != Pawn)
    	    {
    			// ok, let's go for it
    			C = LoopP.Controller;
    			// must be either not controlled, or not on same team
    			if (C == None || C.SameTeamAs(self) == false )
    			{
    				EnemyCount++;
    			}
    		}
    	}
    }
    
    // then every second see if we have health we can siphon
	foreach DynamicActors(class'HealthCharger', LoopHC)
	{
		// first check if the pawn is anywhere near
	    if (LoopHC != None && Pawn != None && VSize(LoopHC.Location - Pawn.Location) < CheckRadius && FastTrace(LoopHC.Location, Pawn.Location))
	    {     
			NumberOfHealthSpawns++;
            if (LoopHC.myPickUp != None)
                NumberIdleSpawns++;    
		}
	}


    SecondCount++;
    if (SecondCount >= 60)
    {
    	foreach RadiusActors(class'xPickupBase', LoopPB, CheckRadius)
    	{
    		// first check if the pawn is anywhere near
    	    if (LoopPB != None)
    	    {     
    			Log("+++ PickupBase" @ LoopPB @ "pickup" @ LoopPB.myPickUp @ LoopPB.myPickUp.Class );    
    		}
    	}
    	foreach DynamicActors(class'HealthCharger', LoopHCR)
    	{
    		// first check if the pawn is anywhere near
    	    if (LoopHCR != None && Pawn != None && VSize(LoopHCR.Location - Pawn.Location) < CheckRadius && FastTrace(LoopHCR.Location, Pawn.Location))
    	    {     
    			Log("+++ HealthCharger" @ LoopHCR @ "pickup" @ LoopHCR.myPickUp @ LoopHCR.myPickUp.Class );    
    		}
    	}
    	foreach DynamicActors(class'HealthPack', LoopHP)
    	{
    		// first check if the pawn is anywhere near
    	    if (LoopHP != None && Pawn != None && VSize(LoopHP.Location - Pawn.Location) < CheckRadius && FastTrace(LoopHP.Location, Pawn.Location))
    	    {     
    			Log("+++ Pawn" @ Pawn @ "PlayerSpawner" @ PlayerSpawner @ "HealthPickup" @ LoopHP @ "base" @ LoopHP.PickUpBase @ LoopHP.PickUpBase.Class );    
    		}
    	}
        
        Log("++++ Node enemies in range = " @ EnemyCount @ "Idle health Spawn Points:" @ NumberIdleSpawns @ "(" @ NumberOfHealthSpawns @ "Pickups)");
        SecondCount = 0;
        EnemyCount = 0;
        NumberIdleSpawns = 0;
    }
}

simulated function Destroyed()
{
	if (PlayerReplicationInfo != None)
		PlayerReplicationInfo.Destroy();

	Super.Destroyed();
}

defaultproperties
{
     CheckRadius=700.000000
     TimeBetweenChecks=1.000000
}
