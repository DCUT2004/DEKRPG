class MissionPortal extends Actor;

var MutMissionMultiplayer MMPI;
var int XPPerScore;
var RPGRules Rules;
var RPGStatsInv StatsInv;
var MutUT2004RPG RPGMut;
var MissionPortalFX FX;

#exec  AUDIO IMPORT NAME="PortalBallScore" FILE="Sounds\PortalBallScore.WAV" GROUP="MissionSounds"

simulated function PostBeginPlay()
{
	local Mutator m;

	if (Level.Game != None)
		for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
			if (MutUT2004RPG(m) != None)
			{
				RPGMut = MutUT2004RPG(m);
				break;
			}
	CheckRPGRules();
	if (Level.Game != None)
		for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
			if (MutMissionMultiplayer(m) != None)
			{
				MMPI = MutMissionMultiplayer(m);
				break;
			}
	SetTimer(1, True);
	Super.PostBeginPlay();
}

function CheckRPGRules()
{
	Local GameRules G;

	if (Level.Game == None)
		return;		//try again later

	for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
	{
		if(G.isA('RPGRules'))
		{
			Rules = RPGRules(G);
			break;
		}
	}

	if(Rules == None)
		Log("WARNING: Unable to find RPGRules in GameRules. EXP will not be properly awarded");
}

function Touch(Actor Other)
{
    local MissionPortalBall Ball;
	local Controller C, NextC;
	local Pawn P;
	local Actor A;

    if (Other != None)
	{
		if (ClassIsChildOf(Other.Class, class'MissionPortalBall'))
		{
			Ball = MissionPortalBall(Other);
			if (Ball != None && MMPI != None)
			{
				MMPI.UpdateCount(1);	//GGGGGGOOOOOOAAAAAAAAAAAAALLLLLLLLL!!!
				C = Level.ControllerList;
				while (C != None)
				{
					NextC = C.NextController;
					if(C == None)
					{
						C = NextC;
						break;
					}
			
					if (C != None && C.Pawn != None && C.Pawn.Health > 0)
					{
						P = C.Pawn;
						if(P != None && P.isA('Vehicle'))
							P = Vehicle(P).Driver;
						if (P != None && P.Health > 0 && !P.IsA('Monster'))
						{			
							if (Rules != None)
							{
								Rules.ShareExperience(RPGStatsInv(P.FindInventoryType(class'RPGStatsInv')), XPPerScore);
							}
						}
					}
					C = NextC;
				}
				Self.PlaySound(Sound'DEKRPG209C.MissionSounds.PortalBallScore',,100.0);
				A = Spawn(class'MissionPortalBallScoreFX',,,Self.Location);
				if (A != None)
					A.RemoteRole = ROLE_SimulatedProxy;
				Ball.Destroy();
				MMPI.NumBalls--;
			}
		}
	}
}

simulated function Timer()
{
	if (FX == None)
	{
		FX = Spawn(class'MissionPortalFX',,,Self.Location);
		if (FX != None)
		{
			FX.SetBase(Self);
			FX.RemoteRole = ROLE_SimulatedProxy;
		}
	}
	if (MMPI != None)
	{
		if (MMPI.Stopped || !MMPI.PortalBallActive)
			Destroy();
	}
	else
		Destroy();
}

simulated function Destroyed()
{
	if (FX != None)
		FX.Destroy();
	Super.Destroyed();
}

defaultproperties
{
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=135
     LightBrightness=255.000000
     LightRadius=15.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'XGame_StaticMeshes.GameObjects.BombGateCol'
     bDynamicLight=True
     bIgnoreVehicles=True
     Physics=PHYS_Falling
     Skins(0)=FinalBlend'XEffectMat.Shield.BlueShell'
     CollisionRadius=60.000000
     CollisionHeight=60.000000
     bCollideActors=True
     bCollideWorld=True
     Mass=2000.000000
}
