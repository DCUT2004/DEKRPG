class FlowerRedPickup extends TournamentPickup;

var config float LifespanAdd;
var config int HealAmountAdd;

event float BotDesireability(Pawn Bot)
{
	return 0;
}

function inventory SpawnCopy( pawn Other )
{
	return None;
}

auto state Pickup
{
	function Touch(Actor Other)
	{
		local Pawn P;
		local FlowerResupplyInv Inv;
		local Mission1Inv M1Inv;
		local Mission2Inv M2Inv;
		local Mission3Inv M3Inv;
		local MissionInv MInv;

		if (ValidTouch(Other))
		{
			P = Pawn(Other);
			if (P != None && P.Health > 0)
			{
				Inv = FlowerResupplyInv(P.FindInventoryType(class'FlowerResupplyInv'));
				if (Inv == None)
				{
					Inv = P.Spawn(class'FlowerResupplyInv');
					Inv.GiveTo(P);
					AnnouncePickup(P);
					Destroy();
				}
				else
				{
					Inv.Lifespan += LifespanAdd;
					Inv.HealAmount += HealAmountAdd;
					AnnouncePickup(P);
					Destroy();
				}
				MInv = MissionInv(P.FindInventoryType(class'MissionInv'));
				M1Inv = Mission1Inv(P.FindInventoryType(class'Mission1Inv'));
				M2Inv = Mission2Inv(P.FindInventoryType(class'Mission2Inv'));
				M3Inv = Mission3Inv(P.FindInventoryType(class'Mission3Inv'));
				
				if (MInv != None)
				{
					if (M1Inv != None && !M1Inv.Stopped && M1Inv.HerbamancerActive)
						M1Inv.MissionCount++;
					if (M2Inv != None && !M2Inv.Stopped && M2Inv.HerbamancerActive)
						M2Inv.MissionCount++;
					if (M3Inv != None && !M3Inv.Stopped && M3Inv.HerbamancerActive)
						M3Inv.MissionCount++;
				}
			}
			else
				return;
		}
	}
}

defaultproperties
{
     LifespanAdd=7.000000
     HealAmountAdd=2
     MaxDesireability=0.300000
     RespawnTime=30.000000
     PickupMessage="Resupply Flower"
     PickupSound=Sound'PlayerSounds.BFootsteps.BFootstepDirt6'
     PickupForce="AdrenelinPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DEKStaticsMaster208K.Meshes.EarthWeaponFlower'
     Physics=PHYS_Rotating
     DrawScale=0.255000
     Skins(0)=Texture'DEKRPGTexturesMaster208K.EarthFlowers.RedFlowerLeaf0'
     Skins(1)=Texture'DEKRPGTexturesMaster208K.EarthFlowers.RedFlowerCenter1'
     Skins(2)=Texture'DEKRPGTexturesMaster208K.EarthFlowers.RedFlowerBottom2and3'
     Skins(3)=Texture'DEKRPGTexturesMaster208K.EarthFlowers.RedFlowerBottom2and3'
     AmbientGlow=255
     ScaleGlow=0.600000
     Style=STY_AlphaZ
     CollisionRadius=32.000000
     CollisionHeight=23.000000
     Mass=10.000000
     RotationRate=(Yaw=24000)
}
