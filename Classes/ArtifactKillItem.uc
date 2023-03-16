class ArtifactKillItem extends RPGArtifact;

var config float MaxRange;

var class<xEmitter> HitEmitterClass;

function PostBeginPlay()
{
	super.PostBeginPlay();
	disable('Tick');
}

/*  Aim at an engineer construction and activate artifact
	Determine whether the item belongs to the Instigator
	If it belongs to the instigator, determine the construction type (Node, Sentinel, Turret, or Block)
	Search through Instigator's EngineerPointsInv summoned items, and get the index of the construction
	Call the appropriate Kill function in EngineerPointsInv, passing in that index
 */
function Activate()
{
	local Vector FaceDir;
	local Vector BeamEndLocation;
	local vector HitLocation;
	local vector HitNormal;
	local Actor AHit;
	local Pawn  HitPawn;
	local Vector StartTrace;

	if (Instigator == None || Instigator.Controller == None)
	{
		bActive = false;
		GotoState('');
		return;	// didn't hit an enemy
	}

	FaceDir = Vector(Instigator.Controller.GetViewRotation());
	StartTrace = Instigator.Location + Instigator.EyePosition();
	BeamEndLocation = StartTrace + (FaceDir * MaxRange);

	// See if we hit something.
	AHit = Trace(HitLocation, HitNormal, BeamEndLocation, StartTrace, true);
	if ((AHit == None) || (Pawn(AHit) == None))
	{
		bActive = false;
		GotoState('');
		return;	// didn't hit an enemy
	}
	HitPawn = Pawn(AHit);

	if (HitPawn != None)
	{
		//Check if it is a block
		if (DruidBlock(HitPawn) != None && DruidBlock(HitPawn).PlayerSpawner != None && DruidBlock(HitPawn).PlayerSpawner == Instigator.Controller)
		{
			KillItem(HitPawn, "BLOCK");
		}
		//Check if it is a turret
		else if (DruidEnergyTurret(HitPawn) != None && DruidEnergyTurret(HitPawn).PlayerSpawner != None && DruidEnergyTurret(HitPawn).PlayerSpawner == Instigator.Controller
		|| DruidMinigunTurret(HitPawn) != None && DruidMinigunTurret(HitPawn).PlayerSpawner != None && DruidMinigunTurret(HitPawn).PlayerSpawner == Instigator.Controller
		|| BaseBallTurret(HitPawn) != None && BaseBallTurret(HitPawn).PlayerSpawner != None && BaseBallTurret(HitPawn).PlayerSpawner == Instigator.Controller
		|| BaseLinkTurret(HitPawn) != None && BaseLinkTurret(HitPawn).PlayerSpawner != None && BaseLinkTurret(HitPawn).PlayerSpawner == Instigator.Controller)
		{
			KillItem(HitPawn, "TURRET");
		}
		//Check if it is a sentinel
		else if (HitPawn.Controller != None)
		{
			if (NodeController(HitPawn.Controller) != None && NodeController(HitPawn.Controller).PlayerSpawner != None && NodeController(HitPawn.Controller).PlayerSpawner == Instigator.Controller)
			{
				KillItem(HitPawn, "NODE");
			}
			else if (DruidSentinelController(HitPawn.Controller) != None && DruidSentinelController(HitPawn.Controller).PlayerSpawner != None && DruidSentinelController(HitPawn.Controller).PlayerSpawner == Instigator.Controller
			|| DruidDefenseSentinelController(HitPawn.Controller) != None && DruidDefenseSentinelController(HitPawn.Controller).PlayerSpawner != None && DruidDefenseSentinelController(HitPawn.Controller).PlayerSpawner == Instigator.Controller
			|| DruidLightningSentinelController(HitPawn.Controller) != None && DruidLightningSentinelController(HitPawn.Controller).PlayerSpawner != None && DruidLightningSentinelController(HitPawn.Controller).PlayerSpawner == Instigator.Controller
			|| DruidEnergyWallController(HitPawn.Controller) != None && DruidEnergyWallController(HitPawn.Controller).PlayerSpawner != None && DruidEnergyWallController(HitPawn.Controller).PlayerSpawner == Instigator.Controller
			|| AutoGunController(HitPawn.Controller) != None && AutoGunController(HitPawn.Controller).PlayerSpawner != None && AutoGunController(HitPawn.Controller).PlayerSpawner == Instigator.Controller)
			{
				KillItem(HitPawn, "SENTINEL");
			}
		}
	}

	bActive = false;
	GotoState('');
	return;
}

function KillItem(Pawn Item, String ItemType)
{
	local EngineerPointsInv EPI;
	local int i;
	local xEmitter HitEmitter;

	if (Item == None)
		return;

	EPI = class'AbilityLoadedEngineer'.static.GetEngInv(Instigator);

	if (EPI == None)
		return;

	if (ItemType == "BLOCK")
	{
		for (i = 0; i < EPI.SummonedBuildings.Length; i++)
			if (EPI.SummonedBuildings[i] == Item)
			{
				EPI.KillBuilding(i);
				break;
			}
	}
	else if (ItemType == "TURRET")
	{
		for (i = 0; i < EPI.SummonedTurrets.Length; i++)
			if (EPI.SummonedTurrets[i] == Item)
			{
				EPI.KillTurret(i);
				break;
			}
	}
	else if (ItemType == "SENTINEL")
	{
		for (i = 0; i < EPI.SummonedSentinels.Length; i++)
			if (EPI.SummonedSentinels[i] == Item)
			{
				EPI.KillSentinel(i);
				break;
			}
	}
	else if (ItemType == "NODE")
	{
		for (i = 0; i < EPI.SummonedNodes.Length; i++)
			if (EPI.SummonedNodes[i] == Item)
			{
				EPI.KillNode(i);
				break;
			}
	}

	HitEmitter = spawn(HitEmitterClass,,, Instigator.Location, rotator(Instigator.Location - Item.Location));
	if (HitEmitter != None)
		HitEmitter.mSpawnVecA = Item.Location;
}

exec function TossArtifact()
{
	//do nothing. This artifact cant be thrown
}

function DropFrom(vector StartLocation)
{
	if (bActive)
		GotoState('');
	bActive = false;

	Destroy();
	Instigator.NextItem();
}

function BotConsider()
{
	return;		// bots do not kill things they have summoned
}

defaultproperties
{
	 HitEmitterClass=Class'DEKRPG999X.RedBoltEmitter'
     MinActivationTime=0.000000
     MaxRange=3000.000000
     IconMaterial=Texture'DEKRPGTexturesMaster209B.Artifacts.KillSummonSentinelIcon'
     ItemName="Kill Item"
}
