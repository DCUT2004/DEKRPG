class EnhancedRPGArtifact extends RPGArtifact
		abstract;

var config int AdrenalineRequired;      // is the Adrenaline required to run an instant effect artifact 
var config float TimeBetweenUses;		// the time required between uses of this artifact
var float LastUsedTime;					// time this artifact was last used
var float RecoveryTime;					// time this artifact can be used again. Clientside only.
var float PerformanceIncrease;          // used to increase the performance of an artifact

replication
{
	reliable if (Role == ROLE_Authority)
		SetClientRecoveryTime;
}

function SetRecoveryTime(float RecoveryPeriod)
{
	LastUsedTime = Level.TimeSeconds;
	SetClientRecoveryTime(RecoveryPeriod);
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
	if (RecoveryTime > 0 && RecoveryTime > Level.TimeSeconds)
		return max(int(RecoveryTime - Level.TimeSeconds),1);
	else
		return 0;
}

function EnhanceAdrenalineRequired(float AdRequired)
{
	AdrenalineRequired = AdRequired;               // by default set the instant effect cost. Timed artifacts may want to overwrite CostPerSec
}

function EnhancePerformance(float PerfIncrease)
{
	PerformanceIncrease = PerfIncrease;
}

simulated function Tick(float deltaTime)
{
	if (bActive)
	{
		if (Instigator != None && Instigator.Controller != None)	// not ghosting
		{
			Instigator.Controller.Adrenaline -= deltaTime * CostPerSec;
			if (Instigator.Controller.Adrenaline <= 0.0)
			{
				Instigator.Controller.Adrenaline = 0.0;
				UsedUp();
			}
		}
	}
}

static function AddArtifactKill(Pawn P,class<Weapon> W)
{
	local int i;
	local TeamPlayerReplicationInfo TPPI;
	local TeamPlayerReplicationInfo.WeaponStats NewWeaponStats;

	// When you kill someone, it calls AddWeaponKill. Unfortunately this checks the damage type is from a weapon.
	// so lightning rod/beam/bolt etc do not get kills logged. So bodge in as weapon kills so show on stats
	if (P == None || W == None)
		return;

  // not sure if I need the next two lines. I don't think so. Assault seems to also give a list of weapon kills
  //      if (!P.Level.Game.IsA('Invasion'))
  //		return;

	TPPI = TeamPlayerReplicationInfo(P.PlayerReplicationInfo);
	if (TPPI == None)
		return;

	for ( i=0; i<TPPI.WeaponStatsArray.Length && i<200; i++ )
	{
		if ( TPPI.WeaponStatsArray[i].WeaponClass == W )
		{
			TPPI.WeaponStatsArray[i].Kills++;
			return;
		}
	}

	NewWeaponStats.WeaponClass = W;
	NewWeaponStats.Kills = 1;
	TPPI.WeaponStatsArray[TPPI.WeaponStatsArray.Length] = NewWeaponStats;
}

static function bool HasTripleRunning(Pawn P)
{
	Local DruidArtifactTripleDamage trip;
	
	if (P == None)
	    return false;

	trip = DruidArtifactTripleDamage(P.FindInventoryType(class'DruidArtifactTripleDamage'));
	if(trip != None && trip.bActive)
		return true;

	return false;
}

static function bool HasRodRunning(Pawn P)
{
	Local DruidArtifactLightningRod rod;

	if (P == None)
	    return false;

	rod = DruidArtifactLightningRod(P.FindInventoryType(class'DruidArtifactLightningRod'));
	if(rod != None && rod.bActive)
		return true;

	return false;
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 1000)
		return "Cannot use this artifact inside a vehicle";
	else if (Switch == 2000)
		return "Cannot use this artifact again yet";
	else
		return switch @ "Adrenaline is required to use this artifact";
}

defaultproperties
{
	PerformanceIncrease=1.0
}
