class FreezeBombCharger extends Actor;

var xEmitter ChargeEmitter;
var AvoidMarker Fear;
var Controller InstigatorController;

var float ChargeTime;
var float MaxFreezeTime;
var float FreezeRadius;
var config bool bDispellable, bStackable;

function Freeze(float Radius)
{
	local float damageScale, dist;
	local vector dir;
	local Controller C, NextC;
	local StatusEffectManager StatusManager;
	local int FreezeModifier;
	local int FreezeLifespan;

	if (Instigator == None && InstigatorController != None)
		Instigator = InstigatorController.Pawn;

	if (Instigator == None || Instigator.Health <= 0 || Instigator.Controller == None)
		return;

	C = Level.ControllerList;
	while (C != None)
	{
		// get next controller here because C may be destroyed if it's a nonplayer and C.Pawn is killed
		NextC = C.NextController;
		if ( C.Pawn != None && C.Pawn != Instigator && C.Pawn.Health > 0 && !C.SameTeamAs(Instigator.Controller)
		     && VSize(C.Pawn.Location - Location) < Radius && FastTrace(C.Pawn.Location, Location) )
		{
			dir = C.Pawn.Location - Location;
			dist = FMax(1,VSize(dir));
			damageScale = 1 - FMax(0,dist/Radius);

			if(!C.Pawn.isA('Vehicle') && class'DEKRPGWeapon'.static.NullCanTriggerPhysics(C.Pawn))
			{
				StatusManager = Class'StatusEffectManager'.static.GetStatusEffectManager(C.Pawn);
				if (StatusManager != None)
				{
					FreezeModifier = damageScale * MaxFreezeTime;
					FreezeLifespan = damageScale * MaxFreezeTime;
					StatusManager.AddStatusEffect(Class'StatusEffect_Speed', -(abs(FreezeModifier)), True, -(abs(FreezeLifespan)), bDispellable, bStackable);
				}
			}
		}

		C = NextC;
	}
}

simulated function PostBeginPlay()
{
	if (Level.NetMode != NM_DedicatedServer)
		ChargeEmitter = spawn(class'FreezeBombChargeEmitter');

	if (Role == ROLE_Authority)
		InstigatorController = Controller(Owner);

	Super.PostBeginPlay();
}

simulated function Destroyed()
{
	if (ChargeEmitter != None)
		ChargeEmitter.Destroy();

	Super.Destroyed();
}

auto state Charging
{
Begin:
	if (Instigator != None)
	{

		Fear = spawn(class'AvoidMarker');
		Fear.SetCollisionSize(FreezeRadius, 200);
		Fear.StartleBots();

		Sleep(ChargeTime);
		if (Instigator != None && Instigator.Health > 0)
			spawn(class'FreezeBombExplosion');
		bHidden = true; //for netplay - makes it irrelevant
		if (ChargeEmitter != None)
			ChargeEmitter.Destroy();
		if (Instigator != None && Instigator.Health > 0)
		{
			MakeNoise(1.0);
			PlaySound(sound'WeaponSounds.redeemer_explosionsound');

			Freeze(FreezeRadius);
		}
	}
	else if (ChargeEmitter != None)
		ChargeEmitter.Destroy();

	if (Fear != None)
		Fear.Destroy();
	Destroy();
}

defaultproperties
{
	 bDispellable=False
	 bStackable=False
     ChargeTime=2.000000
     MaxFreezeTime=15.000000
     FreezeRadius=2000.000000
     DrawType=DT_None
     TransientSoundVolume=1.000000
     TransientSoundRadius=5000.000000
}
