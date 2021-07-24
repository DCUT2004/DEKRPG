class HolographActor extends Pawn
	config(UT2004RPG);

var byte Team;
var Pawn PlayerSpawner;
var config float TargetRadius;

simulated function PostBeginPlay()
{
	SetCollision(False,false,False);
	bCollideWorld = True;
	
	Super.PreBeginPlay();
}

function SetTeamNum(byte T)
{
    Team = T;
}

simulated function int GetTeamNum()
{
	return Team;
}

function Landed(vector hitNormal)
{
	Super.Landed(hitNormal);
	Velocity = vect(0,0,0);
}

function Tick(float DeltaTime)
{
	local Monster M;
	
	foreach VisibleCollidingActors(class'Monster',M,TargetRadius,Self.Location)
	{
		if(M != None && M.Health > 0 && M.MaxFallSpeed != 100000)
		{
			if(M.Controller != None && M.Controller.Enemy != None && FriendlyMonsterInv(M.FindInventoryType(class'FriendlyMonsterInv')) == None && !ClassIsChildOf(M.Class, class'SMPNali') && !M.IsA('MissionCow'))
			{
				M.Controller.Enemy = Self;
				M.Controller.Target = Self;
				M.CanAttack(Self);
				M.RangedAttack(Self);
				M.Controller.Focus = self;
				M.Controller.FireWeaponAt(self);
			}
		}
	}
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	return;
}

defaultproperties
{
     TargetRadius=1000.000000
     bCanBeBaseForPawns=True
     bNoTeamBeacon=True
     ControllerClass=None
     bOrientOnSlope=True
     bAlwaysRelevant=True
     bIgnoreVehicles=True
     LifeSpan=20.000000
     Mesh=SkeletalMesh'XanRobots.EnigmaM'
     DrawScale=1.200000
     Skins(0)=FinalBlend'D-E-K-HoloGramFX.FullFB.HoloMaterial_3'
     Skins(1)=FinalBlend'D-E-K-HoloGramFX.FullFB.HoloMaterial_3'
     AmbientGlow=10
     bShouldBaseAtStartup=False
     CollisionRadius=10.000000
     CollisionHeight=10.000000
     bUseCollisionStaticMesh=True
     Mass=10000.000000
}
