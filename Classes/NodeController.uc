class NodeController extends Controller
	config(UT2004RPG);

var Controller PlayerSpawner;
var RPGStatsInv StatsInv;
var MutUT2004RPG RPGMut;

var config float TimeBetweenChecks;

//Charge variables
var float AccumulatedChargeForNetwork;			//How much charge has been accumulated for other Nodes since the last transmission
var config float ChargeDrainPerSecond;

//Pickup siphoning variables
var int TransmitCounter;
var config int TransmitInterval;
var config float PickupSiphonRadius, PickupDistributeRadius;
var config float PickupSiphonMultiplier;		//How much of the original pickup value to siphon
var config float PickupValueDecreasePerSecond;	//How much of the pickup's value is lost per second as it travels through the Network
var config float MinimumPickupValue;			//The largest amount of a pickup's value that can be lost (i.e. the smallest amount of a pickup that is preserved) as it travels through the Network

var int DistributeCounter;
var config int DistributeInterval;

var int AttackCounter;
var config int AttackInterval;

// upgrade variables
var float PercentPickupRangeIncreasePerLevel;
var float PercentPickupMultiplierIncreasePerLevel;

//A Packet is a struct containing pickups and charge that get transmitted out by a Node to the Network
struct Packet
{
	var Array < Pickup > Pickups;
	var float ReceivedCharge;
	var float DeliveryTime;						//For determining when this Packet can be received by this Node, in seconds
	var float DeliveryDistance;
};

//An array of Packets that are added to by other Nodes
var Array < Packet > IncomingPackets;

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
    local float MinCharge;
    
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
	TransmitCounter = 0;
	DistributeCounter = 0;
	AttackCounter = 0;
	Class'NodeNetwork'.default.TotalDrainPerSecond += ChargeDrainPerSecond;
    
    // set the initial charge to be the same as the lowest on the network
    if (Node(Pawn) != None)         // Possess should have been called before SetPlayerSpawner
    {
        MinCharge = Class'NodeNetwork'.static.GetLowestChargeValue();
        Node(Pawn).Charge = FMin(Node(Pawn).MaxCharge, FMax(0, MinCharge * ChargeDrainPerSecond));
    }
    
	SetTimer(TimeBetweenChecks, true);
}

/*  Search for nearby pickups within a radius
	Distribute the siphoned pickups to other Nodes
	Also search for nearby monsters within a radius
	Distribute pickups that were given to this Node by other Nodes to nearby players
 */
function Timer()
{
	local Array<Pickup> Pickups;
    local Node node;

	if (Pawn == None || PlayerSpawner == None)
	    return;

    node = Node(Pawn);        
	TransmitCounter++;
	DistributeCounter++;
	AttackCounter++;
	if (node.Charge >= ChargeDrainPerSecond)
	{
		if (TransmitCounter >= TransmitInterval)
		{
			Pickups = SiphonPickups();	//O(n^3)
			TransmitCounter = 0;
			TransmitPacket(Pickups);	//O(n)
		}
		if (AttackCounter >= AttackInterval)
		{
			Attack();
			AttackCounter = 0;
		}
	}
	if (DistributeCounter >= DistributeInterval)
	{
		DistributePacket();			//O(n^4)
		DistributeCounter = 0;
	}
	node.Charge = Max(0, node.Charge - ChargeDrainPerSecond);
}

/*  Called by Node.HealDamage(), when an Engineer is linking to this Node
	The amount of Charge will be divided among the number of Nodes in the network
	Charge this Node instantly
	Then add to AccumulatedChargeForNetwork, to be distributed to other Nodes on the next call to TransmitPacket()
 */
function DirectCharge(int Amount)
{
	local float ChargeToAdd;

	ChargeToAdd = Amount * (ChargeDrainPerSecond / Class'NodeNetwork'.default.TotalDrainPerSecond);
	Node(Pawn).Charge = Min(Node(Pawn).Charge + ChargeToAdd, Node(Pawn).MaxCharge);
	AccumulatedChargeForNetwork += FMax(0, Amount - ChargeToAdd);
}

//Overrideable method for different Node types
function Attack();

/*  Search for nearby pickups within a radius
	Immediately distribute them to all nearby players
	Return an array of the siphoned pickups to prepare it for transmission to other Nodes
 */
function Array<Pickup> SiphonPickups()
{
	local Pickup SiphonedPickup;
	local Array<Pickup> SiphonedPickups;

	foreach DynamicActors(Class'Pickup', SiphonedPickup)
	{
		if (SiphonedPickup != None && VSize(SiphonedPickup.Location - Pawn.Location) <= PickupSiphonRadius && FastTrace(SiphonedPickup.Location, Pawn.Location) && !SiphonedPickup.IsInState('Sleeping')
			&& !SiphonedPickup.IsA('DruidHealthPack') && !SiphonedPickup.IsA('DruidAdrenalinePickup') && !SiphonedPickup.IsA('WeaponPickup') && !SiphonedPickup.IsA('UDamagePack'))
		{
			DistributePickup(SiphonedPickup, 0.0);
			SiphonedPickups.Insert(0, 1);
			SiphonedPickups[0] = SiphonedPickup;
		}
	}

	return SiphonedPickups;
}

//Transmits a Packet out to other Nodes
//Calculates the time at which a Packet should be scheduled to arrive for each Node
//And places the Packet in that Node's IncomingPackets array with the DeliveryTime
function TransmitPacket(Array<Pickup> Pickups)
{
	local int i;
	local Node OtherNode;
	local float DeliveryDistance;
	local float DeliveryTime;
	local NodeController OtherNodeController;

	for (i = 0; i < Class'NodeNetwork'.default.Nodes.Length; i++)
	{
		if (Pawn != None && Pawn != Class'NodeNetwork'.default.Nodes[i])
		{
			OtherNode = Class'NodeNetwork'.default.Nodes[i];
			if (OtherNode != None)
			{
				DeliveryDistance = VSize(OtherNode.Location - Pawn.Location);
				DeliveryTime = DeliveryDistance / Class'NodeNetwork'.default.PacketDistancePerSecond;
				if (OtherNode.Controller != None && NodeController(OtherNode.Controller) != None)
				{
					//We may want to be careful here
					//If DeliveryTime is large, then the IncomingPackets array can also be large
					//Size of IncomingPackets from one Node can grow to DeliveryTime / TransmitInterval
					//Decreasing TransmitInterval or decreasing PacketDistancePerSecond can cause IncomingPackets array to be large
					OtherNodeController = NodeController(OtherNode.Controller);
					OtherNodeController.IncomingPackets.Insert(0, 1);
					OtherNodeController.IncomingPackets[0].Pickups = Pickups;
					OtherNodeController.IncomingPackets[0].ReceivedCharge = AccumulatedChargeForNetwork * (OtherNodeController.ChargeDrainPerSecond / Class'NodeNetwork'.default.TotalDrainPerSecond);
					OtherNodeController.IncomingPackets[0].DeliveryTime = DeliveryTime;
					OtherNodeController.IncomingPackets[0].DeliveryDistance = DeliveryDistance;
				}
			}
		}
	}
	AccumulatedChargeForNetwork = 0;
}

//Distribute the received Packet from IncomingPackets if DeliveryTime is within 1 second
//If the packet contains Pickups, distribute to nearby Players
//If the packet contains Charge, then Charge this Node
//Otherwise if DeliveryTime is a second or longer, just decrement the DeliveryTime and do nothing
function DistributePacket()
{
	local int i, j;

	for (i = 0; i < IncomingPackets.Length; i++)
	{
		if (IncomingPackets[i].DeliveryTime < DistributeInterval)
		{
			for (j = 0; j < IncomingPackets[i].Pickups.Length; j++)
				DistributePickup(IncomingPackets[i].Pickups[j], IncomingPackets[i].DeliveryDistance / Class'NodeNetwork'.default.PacketDistancePerSecond);
			if (IncomingPackets[i].ReceivedCharge > 0.0)
				Node(Pawn).Charge = Min(Node(Pawn).Charge + IncomingPackets[i].ReceivedCharge, Node(Pawn).MaxCharge);
			IncomingPackets.Remove(i, 1);
		}
		else
			IncomingPackets[i].DeliveryTime -= DistributeInterval;
	}
}

//Distribute the SiphonedPickup to all nearby players
//This is called directly by SiphonPickups() (a pickup from this Node) and DistributePacket() (a pickup from another Node)
function DistributePickup(Pickup SiphonedPickup, float DeliveryTime)
{
	local Controller C, NextC;
	local Pawn Ally;
	local float PickupAmount;
	local Inventory Inv;
	local Weapon W;
	local float DecreasedDeliveryValue, NewDeliveryValue;

	if (SiphonedPickup == None)
		return;

	C = Level.ControllerList;
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
			if (Ally != None)
			{
				DecreasedDeliveryValue = DeliveryTime * PickupValueDecreasePerSecond;
				NewDeliveryValue = FMax(PickupSiphonMultiplier - DecreasedDeliveryValue, MinimumPickupValue);
				if (TournamentHealth(SiphonedPickup) != None)
				{
					PickupAmount = TournamentHealth(SiphonedPickup).HealingAmount * NewDeliveryValue;
					Ally.GiveHealth(PickupAmount, Ally.HealthMax);
				}
				else if (AdrenalinePickup(SiphonedPickup) != None)
				{
					PickupAmount = AdrenalinePickup(SiphonedPickup).AdrenalineAmount * NewDeliveryValue;
                    if (Ally.Controller != None)
						Ally.Controller.Adrenaline = FMin(Ally.Controller.AdrenalineMax, Ally.Controller.Adrenaline + PickupAmount);
					else if (Ally.DrivenVehicle != None && Ally.DrivenVehicle.Controller != None)
						Ally.DrivenVehicle.Controller.Adrenaline = FMin(Ally.DrivenVehicle.Controller.AdrenalineMax, Ally.DrivenVehicle.Controller.Adrenaline + PickupAmount);
				}
				else if (ShieldPickup(SiphonedPickup) != None)
				{
					PickupAmount = ShieldPickup(SiphonedPickup).ShieldAmount * NewDeliveryValue;
					Ally.AddShieldStrength(PickupAmount);
				}
				else if (Ammo(SiphonedPickup) != None && !Ally.IsA('Monster'))
				{
					PickupAmount = Ammo(SiphonedPickup).AmmoAmount * NewDeliveryValue;
					for (Inv = Ally.Inventory; Inv != None; Inv = Inv.Inventory)
					{
						W = Weapon(Inv);
						if (W != None)
						{
							if (W.IsA('RPGWeapon'))
								W = RPGWeapon(W).ModifiedWeapon;
							if (W.FireModeClass[0] != None && W.FireModeClass[0].default.AmmoClass == SiphonedPickup.InventoryType)
							{
								W.AddAmmo(PickupAmount, 0);
								break;
							}
							else if (W.FireModeClass[1] != None && W.FireModeClass[1].default.AmmoClass == SiphonedPickup.InventoryType)
							{
								W.AddAmmo(PickupAmount, 1);
								break;
							}
						}
					}
				}
			}
		}
		C = NextC;
	}
}

simulated function Destroyed()
{
	if (PlayerReplicationInfo != None)
		PlayerReplicationInfo.Destroy();
	
	IncomingPackets.Length = 0;

	Class'NodeNetwork'.default.TotalDrainPerSecond -= ChargeDrainPerSecond;

	Super.Destroyed();
}

function LevelUp(int NodeLevel)
{
     PickupSiphonRadius += default.PickupSiphonRadius * PercentPickupRangeIncreasePerLevel;
     PickupDistributeRadius += default.PickupDistributeRadius * PercentPickupRangeIncreasePerLevel;
     PickupSiphonMultiplier += default.PickupSiphonMultiplier * PercentPickupMultiplierIncreasePerLevel;
}

defaultproperties
{
	 ChargeDrainPerSecond=1
     PickupSiphonRadius=700.000000
	 PickupDistributeRadius=1000.00
	 PickupSiphonMultiplier=0.30000			//30% of the pickup's value is siphoned and given to nearby players
	 PickupValueDecreasePerSecond=0.0200	//Pickup's value decreases by 2% per second as it travels over the Network
	 MinimumPickupValue=0.0500				//Pickup's value can decrease to as little as 5% over the Network
	 TransmitInterval=5						//Transmit packets out every this many seconds
	 DistributeInterval=1					//Distribute received packets out every this many seconds
     TimeBetweenChecks=1.000000
     PercentPickupRangeIncreasePerLevel=0.1
     PercentPickupMultiplierIncreasePerLevel=0.1
}
