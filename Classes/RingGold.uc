class RingGold extends DruidBlock;

var config float TargetRadius;
var RingRed RR;
var RingBlue RB;
var bool Active;
var RingActiveFX FX;
var MutMissionMultiplayer MMPI;

#exec OBJ LOAD FILE=..\StaticMeshes\E_Pickups.usx

replication
{
	reliable if (Role == ROLE_Authority)
		Active;
}

simulated function PostBeginPlay()
{
	local Mutator m;

	if (Level.Game != None)
		for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
			if (MutMissionMultiplayer(m) != None)
			{
				MMPI = MutMissionMultiplayer(m);
				break;
			}
	
	SetTimer(1, True);
	SetCollision(false,false,false);
	bCollideWorld = true;
	Active = False;
	Super.PostBeginPlay();
}

simulated function Timer()
{
	if (!CheckRadius() || !RR.CheckRadius() || !RB.CheckRadius())
		MMPI.MissionCount = 0;

	if (MMPI != None && !MMPI.stopped && MMPI.Countdown <= 0 && MMPI.RingAndHoldActive)
	{
		if (CheckRadius() && RR.CheckRadius() && RB.CheckRadius())	
			MMPI.UpdateCount(1);
	}
	if (MMPI == None || MMPI.Stopped || !MMPI.RingAndHoldActive)
	{
		if (RR != None)
			RR.Destroy();
		if (RB != None)
			RB.Destroy();
		Destroy();
	}
	SpawnEffect();
}

simulated function bool CheckRadius()
{
	local Pawn P;
	local float Dist;
	
	foreach VisibleCollidingActors(class'Pawn', P, TargetRadius, Self.Location)
	{
		if ( P == None)
			return False;
		if (P != None && P.Controller != None && P.Health > 0)
		{
			Dist = VSize(P.Location - Self.Location);
			if (Dist <= TargetRadius && FastTrace(P.Location, Self.Location))
				return True;
			else
				return False;
			P = None;
		}
		else
		{
			return False;
			P = None;
		}
	}
}

simulated function SpawnEffect()
{	
	if (CheckRadius())
	{
		if (FX == None)
		{
			FX = Self.spawn(class'DEKRPG209A.RingActiveFX', Self,,Self.Location);
			if (FX != None)
			{
				FX.SetCollision(False,False,False);
				FX.RemoteRole = ROLE_SimulatedProxy;
			}
		}
		else
			return;
	}
	else
	{
		if (FX != None)
		{
			FX.Destroy();
		}
		else
			return;
	}
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	return;
}

simulated function destroyed()
{
	if (FX != None)
		FX.Destroy();
	super.Destroyed();
}

defaultproperties
{
     TargetRadius=250.000000
     StaticMesh=StaticMesh'E_Pickups.BombBall.BombRing'
     DrawScale=4.250000
     Skins(0)=Shader'XGameShaders.BRShaders.BombIconYS'
     CollisionRadius=40.000000
     CollisionHeight=40.000000
}
