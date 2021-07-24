class MissionMultiplayerHUDInv extends Inventory;

var MutMissionMultiplayer MMPI;

var bool stopped;	//signifies whether a mission is paused or active.
var int MissionCount;		//The mission's current progress. This is updated by various events, such as making kills or standing in a specific location
var int MissionGoal;	//The mission's goal
var localized string MissionName;
var int TimeRemaining;

var bool PowerPartyActive;
var bool TarydiumKeepActive;
var bool BalloonPopActive;
var bool RingAndHoldActive;
var bool GenomeProjectActive;
var bool MusicalWeaponsActive;
var bool PortalBallActive;

//Tarydium Keep Variables
var TarydiumCrystal TC;

var bool RRActive, RBActive, RGActive;

var class<Weapon> ActiveWeapon;	//The current, active weapon that players must use for Musical Weapons

var transient DruidsRPGKeysInteraction InteractionOwner;

replication
{
	reliable if (Role == ROLE_Authority)
		Stopped, MissionName, MissionCount, MissionGoal, TimeRemaining, PowerPartyActive, TarydiumKeepActive, TC, BalloonPopActive, RingAndHoldActive, RRActive, RBActive, RGActive, GenomeProjectActive, MusicalWeaponsActive, PortalBallActive, ActiveWeapon;
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	local Mutator m;
	
	Super.GiveTo(Other);

	if (Level.Game != None)
		for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
			if (MutMissionMultiplayer(m) != None)
			{
				MMPI = MutMissionMultiplayer(m);
				break;
			}
			
	SetTimer(1, True);
}

simulated function Timer()
{
	if (MMPI != None)
	{
		Stopped = MMPI.Stopped;
		if (!MMPI.Stopped)
		{
			MissionCount = MMPI.MissionCount;
			MissionGoal = MMPI.MissionGoal;
			MissionName = MMPI.MissionName;
			TimeRemaining = MMPI.TimeRemaining;
			
			PowerPartyActive = MMPI.PowerPartyActive;
			TarydiumKeepActive = MMPI.TarydiumKeepActive;
			BalloonPopActive = MMPI.BalloonPopActive;
			RingAndHoldActive = MMPI.RingAndHoldActive;
			GenomeProjectActive = MMPI.GenomeProjectActive;
			MusicalWeaponsActive = MMPI.MusicalWeaponsActive;
			PortalBallActive = MMPI.PortalBallActive;
			
			TC = MMPI.TC;
			
			RRActive = MMPI.RRActive;
			RBActive = MMPI.RBActive;
			RGActive = MMPI.RGActive;
			
			ActiveWeapon = MMPI.ActiveWeapon;
		}
	}
}

simulated function UpdateCount(int Count)
{
	MMPI.MissionCount += Count;
}

simulated function Destroyed()
{
 	if( InteractionOwner != None )
 	{
 		InteractionOwner.MMPI = None;
 		InteractionOwner = None;
 	}
	Super.Destroyed();
}

defaultproperties
{
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
