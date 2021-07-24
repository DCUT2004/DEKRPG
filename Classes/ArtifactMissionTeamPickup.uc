class ArtifactMissionTeamPickup extends RPGArtifactPickup;

#exec OBJ LOAD FILE=..\StaticMeshes\cf_staticMushrooms.usx
#exec OBJ LOAD FILE=..\Textures\MissionsTex6.utx

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
     PickupMessage="You picked up a Team Mission!"
     PickupSound=Sound'PickupSounds.SniperRiflePickup'
     PickupForce="SniperRiflePickup"
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=255
     LightBrightness=255.000000
     LightRadius=3.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DEKStaticsMaster208K.Meshes.TeamMushrooms'
     bDynamicLight=True
     DrawScale=0.400000
     Skins(0)=Texture'MissionsTex6.TeamMissions.TeamMushroomRedSkin'
     AmbientGlow=128
}
