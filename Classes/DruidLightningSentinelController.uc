class DruidLightningSentinelController extends Controller
	config(UT2004RPG);

var Controller PlayerSpawner;
var class<xEmitter> HitEmitterClass;
var RPGStatsInv StatsInv;
var float TimeBetweenShots;

var config float MaxHealthMultiplier;
var config float MinHealthMultiplier;
var config int MaxDamagePerHit;
var config int MinDamagePerHit;
var config float TargetRadius;

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

		// adjust the fire rate according to weapon speed
		StatsInv = RPGStatsInv(PlayerSpawner.Pawn.FindInventoryType(class'RPGStatsInv'));
		if (StatsInv != None)
			TimeBetweenShots = (default.TimeBetweenShots * 100)/(100 + StatsInv.Data.WeaponSpeed);
	}
	SetTimer(TimeBetweenShots, true);
}

function Timer()
{
	// lets target some enemies
	local Controller C, NextC;
	local int DamageDealt;
	local xEmitter HitEmitter;
	local float damageScale, dist;
	local vector dir;

	if (PlayerSpawner == None || PlayerSpawner.Pawn == None)
		return;

	C = Level.ControllerList;
	while (C != None)
	{
		// get next controller here because C may be destroyed if it's a nonplayer and C.Pawn is killed
		NextC = C.NextController;
			
		if (C != None && C.Pawn != None && Pawn != None && C.Pawn != Pawn && C.Pawn != PlayerSpawner.Pawn && C.Pawn.Health > 0
		  && VSize(C.Pawn.Location - Pawn.Location) < TargetRadius && FastTrace(C.Pawn.Location, Pawn.Location) && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow') && !C.Pawn.IsA('MissionBalloon') && PhantomDeathGhostInv(C.Pawn.FindInventoryType(class'PhantomDeathGhostInv')) == None
		   && ((TeamGame(Level.Game) != None && !C.SameTeamAs(PlayerSpawner)) 	// on a different team
			|| (TeamGame(Level.Game) == None && C.Pawn.Owner != PlayerSpawner)))		// or just not me
		{
			// scale damage done according to distnace from sentinel
			dir = C.Pawn.Location - Pawn.Location;
			dist = FMax(1,VSize(dir));
			damageScale = 1 - FMax(0,dist/TargetRadius);

			DamageDealt = C.Pawn.HealthMax * ((damageScale * (MaxHealthMultiplier-MinHealthMultiplier)) + MinHealthMultiplier);
			DamageDealt = max(MinDamagePerHit, DamageDealt);
			DamageDealt = min(MaxDamagePerHit, DamageDealt);
            DamageDealt = class'BaseInstantFire'.static.UpdateDamageDueToLevel(Pawn, DamageDealt);
			C.Pawn.TakeDamage(DamageDealt, Pawn, C.Pawn.Location, vect(0,0,0), class'DamTypeLightningSent');

			if (C != None && C.Pawn != None && Pawn != None)
			{
				HitEmitter = spawn(HitEmitterClass,,, Pawn.Location, rotator(C.Pawn.Location - Pawn.Location));
				if (HitEmitter != None)
					HitEmitter.mSpawnVecA = C.Pawn.Location;
			}

			//hack for invasion monsters so they'll fight back
			if (C != None && C.Pawn != None && MonsterController(C) != None && DEKFriendlyMonsterController(C) == None && Pawn != None 
		     	  && C.Enemy != Pawn && FastTrace(Pawn.Location,C.Pawn.Location) && !ClassIsChildOf(C.Pawn.Class, class'SMPNali'))
		    {
		    	if (C.Enemy == None || FRand() < 0.15 )
					MonsterController(C).ChangeEnemy(Pawn, C.CanSee(Pawn));
			}
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

function LevelUp(float PercentDamageIncreasePerLevel, float PercentFireRateIncreasePerLevel, float PercentRangeIncreasePerLevel, float PercentHealthIncreasePerLevel)
{
     TargetRadius *= (1 + PercentRangeIncreasePerLevel);
     TimeBetweenShots *= (1-PercentFireRateIncreasePerLevel);    
     SetTimer(TimeBetweenShots, true);
     // Log("+++++ DruidlightningSentinelController LevelUp changing TargetRadius to" @ TargetRadius @ "default:" @ default.TargetRadius @ "and TimebetweenShots to" @ TimeBetweenShots @ "default:" @ default.TimeBetweenShots);
}

defaultproperties
{
     HitEmitterClass=Class'XEffects.LightningBolt'
     MaxHealthMultiplier=0.100000
     MinHealthMultiplier=0.020000
     MaxDamagePerHit=30
     MinDamagePerHit=3
     TargetRadius=1200.000000
     TimeBetweenShots=1.0
}
