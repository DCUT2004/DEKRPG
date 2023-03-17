class ForceBlockController extends Controller
	config(UT2004RPG);

var Controller PlayerSpawner;
var RPGStatsInv StatsInv;
var MutUT2004RPG RPGMut;

var config float DamageRadius;
var config float Damage;
var class<Emitter> PulseEmitterClass;  
var config float TimeBetweenChecks;

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
		PlayerReplicationInfo.PlayerName = "";
		PlayerReplicationInfo.bIsSpectator = true;
		PlayerReplicationInfo.bBot = true;
		PlayerReplicationInfo.Team = PlayerSpawner.PlayerReplicationInfo.Team;
		PlayerReplicationInfo.RemoteRole = ROLE_None;
		StatsInv = RPGStatsInv(PlayerSpawner.Pawn.FindInventoryType(class'RPGStatsInv'));
	}
   
	SetTimer(TimeBetweenChecks, true);
}

function Timer()
{
 	local Controller C, NextC;
    local float MaxDistance;

	if (Pawn == None || PlayerSpawner == None)
	    return;

	// spawn(PulseEmitterClass,,,Pawn.Location, rot(0,0,0));
    
    MaxDistance = Pawn.CollisionRadius + DamageRadius;
    
	C = Level.ControllerList;
	while (C != None)
	{
		// loop round finding all enemies hit
		NextC = C.NextController;
		if ( C.Pawn != None && C.Pawn != Pawn && C.Pawn.Health > 0 && !C.SameTeamAs(self)
		     && VSize(C.Pawn.Location - Pawn.Location) - C.Pawn.CollisionRadius < MaxDistance && FastTrace(C.Pawn.Location, Pawn.Location)
              && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow') && !C.Pawn.IsA('MissionBalloon'))
		{
            // Log("++++++ ForceBlockController doing" @ Damage @ "to" @ C.Pawn @ "with Health" @ C.Pawn.Health);	
			C.Pawn.TakeDamage(Damage, PlayerSpawner.Pawn, C.Pawn.Location, vect(0,0,0), class'DamTypeForceBlock');
		}
		C = NextC;
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
     TimeBetweenChecks=1.000000
     DamageRadius=80.000000
     Damage=5.000000
     PulseEmitterClass=class'DEKRPG999X.PulseNodeEmitter'
}
