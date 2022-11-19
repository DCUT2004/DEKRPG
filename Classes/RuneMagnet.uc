class RuneMagnet extends Actor
	config(UT2004RPG);
	
var float AttractionRadius;
var float AttractionStrength;
var Emitter MagnetEffect;
var Class<Emitter> MagnetEffectClass;
var config float DamageInterval;
var config int Damage, DamageRadius;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetPhysics(PHYS_None);
	SetCollision(False,False,False);
	SoundRadius = 150;
	SoundVolume = 150;
	MagnetEffect = Spawn(MagnetEffectClass,,, Self.Location);
	SetTimer(DamageInterval, True);
}

simulated function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);
	Attract(DeltaTime);
}

simulated function Attract(float DeltaTime)
{
	local Controller C;
	local float dist;
	local vector dir, attraction;
	
	if (Instigator == None || Instigator.Controller == None)
		Destroy();
	
	for ( C = Level.ControllerList; C != None; C = C.NextController )
		if ( C != None && C.Pawn != None && Instigator != None && Instigator.Controller != None && C.Pawn.Health > 0 && !C.SameTeamAs(Instigator.Controller) && !ClassIsChildOf(C.Pawn.Class, Class'Vehicle'))
		{
			dir = Location - C.Pawn.Location;
			dist = VSize(dir);
			dir /= dist;

			if (dist <= AttractionRadius)
			{
				attraction = dir * (AttractionStrength * Square(1 - dist / AttractionRadius));
				if (Instigator != None && Instigator.Controller != None && C != None && C.Pawn != None && C.Pawn.Health > 0 && !C.SameTeamAs(Instigator.Controller) && (!ClassIsChildOf(C.Pawn.Class,Class'Vehicle') || C.Pawn != Class'ONSWeaponPawn' || !ClassIsChildOf(C.Pawn.Class,Class'ONSWeaponPawn') || C.Pawn != Class'ASTurret' || !ClassIsChildOf(C.Pawn.Class,Class'ASTurret')))
				{
					if (C.Pawn.Physics == PHYS_Ladder && C.Pawn.OnLadder != None)
					{
						if (vector(C.Pawn.OnLadder.WallDir) dot attraction < -100)
							C.Pawn.SetPhysics(PHYS_Falling);
					}
					else if (C.Pawn.Physics == PHYS_Walking)
					{
						if (C.Pawn.PhysicsVolume.Gravity dot attraction < -100)
							C.Pawn.SetPhysics(PHYS_Falling);
					}
					else if (C.Pawn.Physics == PHYS_Spider)
					{
						// probably not a good idea as I have no idea what people use spider physics for
						if (C.Pawn.Floor dot attraction > 1000)
							C.Pawn.SetPhysics(PHYS_Falling);
					}
				}
				if (C != None && C.Pawn != None && C.Pawn != Class'Vehicle')
				{
					C.Pawn.Velocity += DeltaTime * attraction / Sqrt(C.Pawn.Mass);
					//C.Pawn.Velocity.Z=50;
				}
			}
		}
}

simulated function Timer()
{
	if (Instigator == None || Instigator.Controller == None)
		Destroy();
	Instigator.HurtRadius(Damage, DamageRadius, class'DamTypeRuneMagnet', 0, Location);
}

simulated function Destroyed()
{
	if (MagnetEffect != None)
		MagnetEffect.Destroy();
	Super.Destroyed();
}

defaultproperties
{
	Damage=4
	DamageInterval=0.15000
	DamageRadius=100
	MagnetEffectClass=Class'DEKWeapons999X.UpgradeShockRifleBlackHoleEffect'
    AttractionRadius=800.000000
    AttractionStrength=150000.000000
	Lifespan=0.00000
	DrawType=DT_None
	bDynamicLight=True
	LightType=LT_Steady
	LightEffect=LE_QuadraticNonIncidence
	LightHue=195
	LightSaturation=85
	LightBrightness=200.000000
	LightRadius=10.000000
}
