class ArtifactLetterUPickup extends TournamentPickup;

var ArtifactLetterGlow GemXPGlow;

#exec  AUDIO IMPORT NAME="ExpPickup" FILE="Sounds\ExpPickup.WAV" GROUP="ArtifactSounds"

function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	GemXPGlow = spawn(class'ArtifactLetterGlow',self,,Location,Rotation);
	if (GemXPGlow != None)
		GemXPGlow.RemoteRole = ROLE_SimulatedProxy;
}

auto state Pickup
{
	function Touch(Actor Other)
	{
		local Pawn PawnOwner;
		local Controller C;

		if (ValidTouch(Other))
		{
			PawnOwner = Pawn(Other);
			if (PawnOwner != None && PawnOwner.Health > 0 && !PawnOwner.IsA('Monster'))
			{
				if (class'MutBONUSLetters'.static.UnlockLetterU())
				{
					if (PawnOwner.PlayerReplicationInfo != None)
						BroadcastLocalizedMessage(class'LetterUMessage', 0, PawnOwner.PlayerReplicationInfo);
					if (class'MutWaveRandomizer'.static.IsBONUSUnlocked())
					{
						BroadcastLocalizedMessage(Class'BonusWaveMessage');
						
						for ( C = Level.ControllerList; C != None; C = C.NextController )
							if (C != None && C.Pawn != None && C.Pawn.Health > 0 && C.IsA('PlayerController') && C.SameTeamAs(PawnOwner.Controller) )
								PlayerController(C).ClientPlaySound(Sound'GameSounds.Fanfares.UT2k3Fanfare03');
					}
					else
					{
						for ( C = Level.ControllerList; C != None; C = C.NextController )
							if (C != None && C.Pawn != None && C.Pawn.Health > 0 && C.IsA('PlayerController') && C.SameTeamAs(PawnOwner.Controller) )
								PlayerController(C).ClientPlaySound(Sound'GameSounds.Fanfares.UT2k3Fanfare01');
					}
				}
			}
		}
		Super.Touch(Other);
	}
}

function float DetourWeight(Pawn Other, float PathWeight)
{
	return MaxDesireability;
}

defaultproperties
{
     MaxDesireability=1.500000
     PickupMessage="You got letter U! Spell BONUS!"
     PickupSound=Sound'DEKRPG999X.ArtifactSounds.ExpPickup'
     PickupForce="SniperRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DEKStaticsMaster209C.Artifacts.BONUSlettersU'
     LifeSpan=30.000000
     DrawScale=0.900000
     Skins(0)=FinalBlend'D-E-K-HoloGramFX.NonWireframe.SBlend_1'
     AmbientGlow=128
}
