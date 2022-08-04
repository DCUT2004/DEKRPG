class FlowerOrangePickup extends TournamentPickup;

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
		local FlowerAdrenInv Inv;
		local MissionInvBETA MissionInv;

		if (ValidTouch(Other))
		{
			P = Pawn(Other);
			if (P != None && P.Health > 0)
			{
				Inv = FlowerAdrenInv(P.FindInventoryType(class'FlowerAdrenInv'));
				if (Inv == None)
				{
					Inv = P.Spawn(class'FlowerAdrenInv');
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
				if (P.Controller != None)
				{
					MissionInv = class'MissionInvBETA'.static.GetMissionInv(P.Controller);
					if (MissionInv != None)
					{
						if (!MissionInv.IsMissionActive("Herbamancer"))
							return;
						MissionInv.TickMission(MissionInv.GetMissionIndex("Herbamancer"), 1);
					}
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
     HealAmountAdd=3
     MaxDesireability=0.300000
     RespawnTime=30.000000
     PickupMessage="Adrenaline Flower"
     PickupSound=Sound'PlayerSounds.BFootsteps.BFootstepDirt6'
     PickupForce="AdrenelinPickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DEKStaticsMaster209C.Meshes.EarthWeaponFlower'
     Physics=PHYS_Rotating
     DrawScale=0.255000
     Skins(0)=Texture'DEKRPGTexturesMaster209B.EarthFlowers.OrangeFlowerLeaf0'
     Skins(1)=Texture'DEKRPGTexturesMaster209B.EarthFlowers.OrangeFlowerCenter1'
     Skins(2)=Texture'DEKRPGTexturesMaster209B.EarthFlowers.OrangeFlowerBottom2and3'
     Skins(3)=Texture'DEKRPGTexturesMaster209B.EarthFlowers.OrangeFlowerBottom2and3'
     AmbientGlow=255
     ScaleGlow=0.500000
     Style=STY_AlphaZ
     CollisionRadius=32.000000
     CollisionHeight=23.000000
     Mass=10.000000
     RotationRate=(Yaw=24000)
}
