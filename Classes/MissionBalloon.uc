class MissionBalloon extends DruidBlock;

var config bool PopOnTimer;
var config float PopTimer;
var MutMissionMultiplayer MMPI;

#exec OBJ LOAD FILE=..\Sounds\ONSVehicleSounds-S.uax
#exec OBJ LOAD FILE=..\Textures\VMParticleTextures.utx

simulated function PostBeginPlay()
{
	local Mutator m;
	
    Super.PostBeginPlay();
	
	if (Level.Game != None)
		for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
			if (MutMissionMultiplayer(m) != None)
			{
				MMPI = MutMissionMultiplayer(m);
				break;
			}
			
	Velocity = Vector(Rotation) * AirSpeed;  
	Velocity.z += 225; 
	
	if (PopOnTimer)
		SetTimer(PopTimer, True);
}

simulated function Timer()
{
	Destroy();
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	local Actor A;
	local Pawn P;
	
	P = instigatedBy;
	
	if ( damagetype == None )
	{
		if ( InstigatedBy != None )
			warn("No damagetype for damage by "$instigatedby$" with weapon "$InstigatedBy.Weapon);
		DamageType = class'DamageType';
	}

	if ( Role < ROLE_Authority )
		return;

	if ( Health <= 0 )
		return;
		
	if (DamageType == class'DamTypeLightningRod' || DamageType == class'DamTypeEnhLightningRod' || DamageType == class'DamTypeLightningBolt' || DamageType == class'DamTypeLightningSent')
		return;
		
	if (instigatedBy.IsA('Monster'))
		return;
	
	if (P != None && P.IsA('Vehicle'))
		P = Vehicle(P).Driver;
	if (P != None && P.Health > 0 && MMPI != None && !MMPI.stopped && MMPI.BalloonPopActive)
	{
		MMPI.UpdateCount(1);
	}

	A = spawn(class'MissionBalloonRedPopEffect',,, Self.Location + vect(0,0,60));
	if (A != None)
	{
		A.RemoteRole = ROLE_SimulatedProxy;
		A.PlaySound(sound'ONSVehicleSounds-S.VehicleTakeFire.VehicleHitBullet03',,5.5*TransientSoundVolume,,TransientSoundRadius);
	}
	
    gibbedBy(instigatedBy);
}

defaultproperties
{
     PopOnTimer=True
     PopTimer=30.000000
     AirSpeed=540.000000
     HealthMax=1.000000
     Health=1
     StaticMesh=StaticMesh'DEKStaticsMaster209C.Meshes.Balloon1'
     Physics=PHYS_Flying
     DrawScale=0.350000
     Skins(0)=Texture'MissionsTex6.Colors.Red'
     Skins(1)=Texture'MissionsTex6.Colors.Black'
     CollisionRadius=15.500000
     Mass=10.000000
}
