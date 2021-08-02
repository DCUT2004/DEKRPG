class ArtifactMissionPickup extends RPGArtifactPickup;

#exec OBJ LOAD FILE=..\StaticMeshes\CaveDecoMeshes.usx

function float BotDesireability(Pawn Bot)
{
		return 0;
}

auto state Pickup
{
	function bool ValidTouch(Actor Other)
	{
		local Pawn P;
		
		P = Pawn(Other);
		if (P != None && P.Health > 0)
		{
			if (P.PlayerReplicationInfo != None && P.PlayerReplicationInfo.bBot)
				return false;
		}
		if (Other != None)
		{
			if (!Super.ValidTouch(Other))
				return false;
		}
		return CanPickupArtifact(Pawn(Other));
	}
}

defaultproperties
{
     MaxDesireability=0.000000
     InventoryType=Class'DEKRPG208AE.ArtifactMission'
     PickupMessage="You picked up a Mission!"
     PickupSound=Sound'PickupSounds.SniperRiflePickup'
     PickupForce="SniperRiflePickup"
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=135
     LightSaturation=60
     LightBrightness=255.000000
     LightRadius=3.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'CaveDecoMeshes.Mushrooms.N_mushroom03_M_JM'
     bDynamicLight=True
     DrawScale=0.600000
     AmbientGlow=128
}
