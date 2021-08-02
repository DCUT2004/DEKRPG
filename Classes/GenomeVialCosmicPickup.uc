class GenomeVialCosmicPickup extends TournamentPickup;

var MutUT2004RPG RPGMut;
var MutMissionMultiplayer MMPI;

#EXEC OBJ LOAD FILE=..\Sounds\SkaarjPack_rc.uax

function PostBeginPlay()
{
	local Mutator M;
	
	Super.PostBeginPlay();

	RPGMut = class'MutUT2004RPG'.static.GetRPGMutator(Level.Game);
	
	if (Level.Game != None)
		for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
			if (MutMissionMultiplayer(m) != None)
			{
				MMPI = MutMissionMultiplayer(m);
				break;
			}
}

function float DetourWeight(Pawn Other, float PathWeight)
{
	return MaxDesireability;
}

event float BotDesireability(Pawn Bot)
{
	if (Bot.Controller.bHuntPlayer)
		return 0;
	return MaxDesireability;
}

auto state Pickup
{
	function bool ValidTouch(Actor Other)
	{
		local GenomeVialCosmic GVC;
		local GenomeVialTech GVT;
		local GenomeVialFire GVF;
		local GenomeVialIce GVI;
		local GenomeVialGhost GVG;
		
		if (!Super.ValidTouch(Other))
			return false;
					
		if (MMPI == None)
			return false;
		
		if (Pawn(Other) != None && Pawn(Other).PlayerReplicationInfo != None && Pawn(Other).PlayerReplicationInfo.bBot)
			return false;
			
		GVC = GenomeVialCosmic(Pawn(Other).FindInventoryType(class'GenomeVialCosmic'));
		GVT = GenomeVialTech(Pawn(Other).FindInventoryType(class'GenomeVialTech'));
		GVF = GenomeVialFire(Pawn(Other).FindInventoryType(class'GenomeVialFire'));
		GVI = GenomeVialIce(Pawn(Other).FindInventoryType(class'GenomeVialIce'));
		GVG = GenomeVialGhost(Pawn(Other).FindInventoryType(class'GenomeVialGhost'));
		if (GVC != None || GVT != None || GVF != None || GVI != None || GVG != None)
			return false;
		else
		{
			return True;
			MMPI.NumVials--;
		}
	}
	function Touch(Actor Other)
	{
		local Inventory Copy;
		local Pawn P;
		local GenomeVialCosmicPickup GVC;
		local GenomeVialTechPickup GVT;
		local GenomeVialFirePickup GVF;
		local GenomeVialIcePickup GVI;
		local GenomeVialGhostPickup GVG;
		local NavigationPoint Dest;
		
		P = Pawn(Other);

		// If touched by a player pawn, let him pick this up.
		if( ValidTouch(Other) )
		{
			if (P != None)
			{
				Dest = P.Controller.FindRandomDest();
				if (MMPI != None)
				{
					if (MMPI.GenomeProjectActive)
					{
						Copy = SpawnCopy(P);
						AnnouncePickup(P);
						if ( Copy != None )
							Copy.PickupFunction(P);
						if (Rand(99) <= 20)
						{
							GVT = Spawn(class'GenomeVialTechPickup',,,Dest.Location + (vect(0,0,20)),);
							if (GVT != None)
								Destroy();
						}
						else if (Rand(99) <= 40)
						{
							GVC = Spawn(class'GenomeVialCosmicPickup',,,Dest.Location + (vect(0,0,20)),);
							if (GVC != None)
								Destroy();
						}
						else if (Rand(99) <= 60)
						{
							GVF = Spawn(class'GenomeVialFirePickup',,,Dest.Location + (vect(0,0,20)),);
							if (GVF != None)
								Destroy();
						}
						else if (Rand(99) <= 80)
						{
							GVI = Spawn(class'GenomeVialIcePickup',,,Dest.Location + (vect(0,0,20)),);
							if (GVI != None)
								Destroy();
						}
						else if (Rand(99) <= 100)
						{
							GVG = Spawn(class'GenomeVialGhostPickup',,,Dest.Location + (vect(0,0,20)),);
							if (GVG != None)
								Destroy();
						}					
					}
					else
						Destroy();
				}
				else
					return;
			}
		}
	}
}

defaultproperties
{
     MaxDesireability=0.000000
     InventoryType=Class'DEKRPG208AE.GenomeVialCosmic'
     RespawnTime=10.000000
     PickupMessage="You picked up a cosmic vial."
     PickupSound=Sound'SkaarjPack_rc.Skaarj.roam11s'
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=210
     LightSaturation=30
     LightBrightness=255.000000
     LightRadius=6.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'XPickups_rc.MiniHealthPack'
     bDynamicLight=True
     Physics=PHYS_Rotating
     DrawScale=0.120000
     Skins(0)=Texture'XGameTextures.SuperPickups.MHPickup'
     Skins(1)=Shader'DEKMonstersTexturesMaster208.CosmicMonsters.CosmicGibs'
     Style=STY_AlphaZ
     CollisionRadius=24.000000
     CollisionHeight=10.000000
}
