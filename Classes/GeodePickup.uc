class GeodePickup extends TournamentPickup;

var ArtifactLetterGlow Glow;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	Glow = spawn(class'ArtifactLetterGlow',self,,Location,Rotation);
	if (Glow != None)
		Glow.RemoteRole = ROLE_SimulatedProxy;
}

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
		local StatusEffectInventory_Player StatusManager;

		if (ValidTouch(Other))
		{
			P = Pawn(Other);
			if (P != None && P.Health > 0 && !P.IsA('Monster'))
			{
				StatusManager = StatusEffectInventory_Player(class'StatusEffectInventory_Player'.static.GetStatusEffectManager(P));
				if (StatusManager != None)
				{
					StatusManager.HasGeode = True;
					AnnouncePickup(P);
					SetRespawn();
					if (Glow != None)
						Glow.Destroy();
				}
			}
		}
	}
}

defaultproperties
{
     MaxDesireability=0.000000
     PickupMessage="You picked up a Geode. Deposit it at an Altar."
     PickupSound=Sound'DEKRPG999X.ArtifactSounds.ExpPickup'
	 DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'2009Dragonv2.EarthRock'
	 Texture=Shader'2009Dragonv2Tex.SFX.EarthRockTex'
	 bAmbientGlow=True
}
