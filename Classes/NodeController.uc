class NodeController extends Controller
	config(UT2004RPG);

var Controller PlayerSpawner;
var RPGStatsInv StatsInv;
var MutUT2004RPG RPGMut;

var config float TimeBetweenChecks;

//Pickup siphoning variables
var int PickupSiphonIntervalCounter;
var config int PickupSiphonInterval;
var config float PickupSiphonRadius, PickupDistributeRadius;

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
	PickupSiphonIntervalCounter = 0;
	SetTimer(TimeBetweenChecks, true);
}

/*  Search for nearby pickups within a radius
	Also search for nearby monsters within a radius
	Distribute pickups that were given to this Node by other Nodes to nearby players
 */
function Timer()
{

	if (Pawn == None || PlayerSpawner == None)
	    return;
	if (PickupSiphonIntervalCounter >= PickupSiphonInterval)
	{
		SiphonPickups();
		PickupSiphonIntervalCounter = 0;
	}
	PickupSiphonIntervalCounter++;
}

/*  Search for nearby pickups within a radius
	Immediately distribute them to all nearby players
	Send the siphoned pickups to the NodeNetwork object, which will handle the distribution of pickups to other Nodes
 */
function SiphonPickups()
{
	local Pickup SiphonedPickup;
	local Controller C, NextC;
	local Pawn Ally;
	local int PickupAmount;
	local Inventory Inv;
	local Weapon W;
	local Array<Pickup> SiphonedPickups;

	foreach DynamicActors(Class'Pickup', SiphonedPickup)
	{
		if (SiphonedPickup != None && VSize(SiphonedPickup.Location - Pawn.Location) <= PickupSiphonRadius && FastTrace(SiphonedPickup.Location, Pawn.Location) && !SiphonedPickup.IsInState('Sleeping')
			&& !SiphonedPickup.IsA('DruidHealthPack') && !SiphonedPickup.IsA('DruidAdrenalinePickup') && !SiphonedPickup.IsA('WeaponPickup') && !SiphonedPickup.IsA('UDamagePack'))
		{
			Log("SiphonedPickup Class: " $ SiphonedPickup.Class);
			C = Level.ControllerList;	//I'm thinking a ControllerList would be smaller to loop through than using DynamicActors to find pawns
			while (C != None)
			{
				NextC = C.NextController;
				if (C != None && C.Pawn != None && C.Pawn.Health > 0 && C.Pawn.GetTeamNum() == PlayerSpawner.GetTeamNum() && !C.Pawn.IsA('DruidBlock') && VSize(C.Pawn.Location - Pawn.Location) <= PickupDistributeRadius && FastTrace(C.Pawn.Location, Pawn.Location))
				{
					if (Vehicle(C.Pawn) != None)
					{
						if (Vehicle(C.Pawn).Driver != None)
							Ally = Vehicle(C.Pawn).Driver;
						else
							Ally = None;	//A sentinel, empty turret, etc.
					}
					else
						Ally = C.Pawn;
					//Found the person. Heal them, resupply them, etc.
					if (TournamentHealth(SiphonedPickup) != None)
					{
						PickupAmount = TournamentHealth(SiphonedPickup).HealingAmount;
						Ally.GiveHealth(PickupAmount, Ally.HealthMax);
					}
					else if (AdrenalinePickup(SiphonedPickup) != None)
					{
						PickupAmount = AdrenalinePickup(SiphonedPickup).AdrenalineAmount;
						Ally.Controller.AwardAdrenaline(PickupAmount);
					}
					else if (ShieldPickup(SiphonedPickup) != None)
					{
						PickupAmount = ShieldPickup(SiphonedPickup).ShieldAmount;
						Ally.AddShieldStrength(PickupAmount);
					}
					else if (Ammo(SiphonedPickup) != None && !Ally.IsA('Monster'))
					{
						PickupAmount = Ammo(SiphonedPickup).AmmoAmount;
						for (Inv = Ally.Inventory; Inv != None; Inv = Inv.Inventory)
						{
							W = Weapon(Inv);
							if (W != None && W.Class == SiphonedPickup.InventoryType)
							{
								if (W.bNoAmmoInstances && W.AmmoClass[0] != None && !class'MutUT2004RPG'.static.IsSuperWeaponAmmo(W.AmmoClass[0]))
									W.AddAmmo(PickupAmount, 0);
								if (W.AmmoClass[0] != W.AmmoClass[1] && W.AmmoClass[1] != None)
									W.AddAmmo(PickupAmount, 1);
								break;
							}
						}
						//End weapon pickup loop
					}
				}
				C = NextC;
			}
			//End player loop
			//Before we search for the next pickup, add this pickup to the SiphonedPickups array so that it can be sent to the NodeNetwork in a package
			SiphonedPickups.Insert(0, 1);
			SiphonedPickups[0] = SiphonedPickup;
		}
	}
	//End nearby pickup loop

	//Send SiphonedPickups array to NodeNetwork for handling
}

//Distribute the received Pickups from the NodeNetwork object to nearby players
function DistributePickups(Array < Pickup > Pickups)
{

}

simulated function Destroyed()
{
	if (PlayerReplicationInfo != None)
		PlayerReplicationInfo.Destroy();

	Super.Destroyed();
}

function LevelUp(int NodeLevel)
{
     // TODO
}

defaultproperties
{
     PickupSiphonRadius=700.000000
	 PickupSiphonInterval=5
	 PickupDistributeRadius=1000.00
     TimeBetweenChecks=1.000000
}
