class RuneEnergyFusion extends Actor
	config(UT2004RPG);

var Emitter FusionEffect;
var Class<Emitter> FusionEffectClass;
var config float EnergyStealInterval;
var config float EnergyStealRadius;
var config int AdrenAddPerStrike;
var config int StrikeDamage;
var class<xEmitter> StrikeEmitterClass;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetPhysics(PHYS_None);
	SetCollision(False,False,False);
	SetTimer(EnergyStealInterval, True);
	SoundRadius = 150;
	SoundVolume = 150;
	FusionEffect = Spawn(FusionEffectClass,,, Self.Location);
}

simulated function Timer()
{
	local Pawn Victim;
	local xEmitter HitEmitter;
	local AdrenParticle FX;
	
	if (Instigator == None || Instigator.Controller == None)
		return;
	
	foreach VisibleCollidingActors(class'Pawn', Victim, EnergyStealRadius, Self.Location)
	{
		if (Victim != None && Victim.Health > 0 && Victim.GetTeamNum() != Instigator.GetTeamNum())
		{
			Victim.TakeDamage(StrikeDamage, Instigator, Victim.Location, Vect(0,0,0), Class'DamTypeRuneEnergySteal');
			Instigator.Controller.Adrenaline += AdrenAddPerStrike;
			Instigator.PlaySound(Sound'PickupSounds.AdrenelinPickup',, 1.2 * Instigator.TransientSoundVolume,, 1.2 * Instigator.TransientSoundRadius);
			HitEmitter = spawn(StrikeEmitterClass,,, Self.Location, rotator(Victim.Location - Self.Location));
			if (HitEmitter != None)
				HitEmitter.mSpawnVecA = Victim.Location;
			FX = Spawn(Class'AdrenParticle', Self, , Victim.Location);
			if (FX != None)
				FX.Seeking = Self;
		}
	}
}

simulated function Destroyed()
{
	if (FusionEffect != None)
		FusionEffect.Destroy();
	Super.Destroyed();
}

defaultproperties
{
	Lifespan=5.00000000
	AdrenAddPerStrike=4
	StrikeDamage=15
	EnergyStealInterval=0.700000
	EnergyStealRadius=900.00000
	FusionEffectClass=Class'DEKRPG209D.EnergyFusionEffect'
	DrawType=DT_Sprite
	DrawScale=0.010000
	Skins(0)=FinalBlend'D-E-K-HoloGramFX.NonWireframe.FunkyStuff_0'
	bDynamicLight=True
	LightType=LT_Steady
	LightEffect=LE_QuadraticNonIncidence
	LightRadius=10.000000
    LightBrightness=100.000000
    LightHue=20
	CollisionHeight=10.00000
	CollisionRadius=10.00000
    StrikeEmitterClass=Class'DEKRPG209D.BronzeBoltEmitter'
	AmbientSound=Sound'DEKRPG209D.RuneSounds.EnergyStealAmbient'
}
