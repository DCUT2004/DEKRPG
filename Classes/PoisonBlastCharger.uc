class PoisonBlastCharger extends Actor;

var xEmitter ChargeEmitter;
var PoisonBlastExplosion Explosion;
var AvoidMarker Fear;
var Controller InstigatorController;

var float ChargeTime;
var float MaxDrain;
var float MinDrain;
var float DrainTime;
var float DamageRadius;
var RPGRules RPGRules;

var float ChargeLoad;

function DoDamage(float Radius)
{
	local float damageScale, dist;
	local vector dir;
	local Controller C, NextC;
	Local PoisonBlastInv Inv;

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

			if(!C.Pawn.isA('Vehicle') && (C.Pawn.FindInventoryType(class'PoisonBlastInv') == None))
			{
				Inv = spawn(class'PoisonBlastInv', C.Pawn,,, rot(0,0,0));
				if(Inv != None)
				{
					Inv.Instigator = Instigator;
					Inv.LifeSpan = DrainTime;
					Inv.DrainAmount = MinDrain+(damageScale * (MaxDrain - MinDrain));
					Inv.RPGRules = RPGRules;
					Inv.GiveTo(C.Pawn);
				}
			}
		}

		C = NextC;
	}
}

simulated function PostBeginPlay()
{
	Local GameRules G;
	if (Level.NetMode != NM_DedicatedServer)
		ChargeEmitter = spawn(class'PoisonBlastChargeEmitter');

	if (Role == ROLE_Authority)
		InstigatorController = Controller(Owner);

	super.PostBeginPlay();
	if (Level.Game != None)
	{
		for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
		{
			if(G.isA('RPGRules'))
			{
				RPGRules = RPGRules(G);
				break;
			}
		}
	}

	if(RPGRules == None)
		Log("WARNING: Unable to find RPGRules in GameRules. EXP will not be properly awarded");
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
		Fear.SetCollisionSize(DamageRadius, 200);
		Fear.StartleBots();

		Sleep(ChargeTime);
		if (Instigator != None && Instigator.Health > 0)
			Explosion = spawn(class'PoisonBlastExplosion');
		if (Explosion != None)
		{
			Explosion.Emitters[0].StartSizeRange.X.Min *= ChargeLoad/5.0;
			Explosion.Emitters[0].StartSizeRange.X.Max *= ChargeLoad/5.0;
			Explosion.Emitters[0].StartSizeRange.Y.Min *= ChargeLoad/5.0;
			Explosion.Emitters[0].StartSizeRange.Y.Max *= ChargeLoad/5.0;
			Explosion.Emitters[0].StartSizeRange.Z.Min *= ChargeLoad/5.0;
			Explosion.Emitters[0].StartSizeRange.Z.Max *= ChargeLoad/5.0;
			Explosion.Emitters[1].StartSizeRange.X.Min *= ChargeLoad/5.0;
			Explosion.Emitters[1].StartSizeRange.X.Max *= ChargeLoad/5.0;
			Explosion.Emitters[1].StartSizeRange.Y.Min *= ChargeLoad/5.0;
			Explosion.Emitters[1].StartSizeRange.Y.Max *= ChargeLoad/5.0;
			Explosion.Emitters[1].StartSizeRange.Z.Min *= ChargeLoad/5.0;
			Explosion.Emitters[1].StartSizeRange.Z.Max *= ChargeLoad/5.0;
			Explosion.Emitters[2].StartSizeRange.X.Min *= ChargeLoad/5.0;
			Explosion.Emitters[2].StartSizeRange.X.Max *= ChargeLoad/5.0;
			Explosion.Emitters[2].StartSizeRange.Y.Min *= ChargeLoad/5.0;
			Explosion.Emitters[2].StartSizeRange.Y.Max *= ChargeLoad/5.0;
			Explosion.Emitters[2].StartSizeRange.Z.Min *= ChargeLoad/5.0;
			Explosion.Emitters[2].StartSizeRange.Z.Max *= ChargeLoad/5.0;
			Explosion.Emitters[3].StartSizeRange.X.Min *= ChargeLoad/5.0;
			Explosion.Emitters[3].StartSizeRange.X.Max *= ChargeLoad/5.0;
			Explosion.Emitters[3].StartSizeRange.Y.Min *= ChargeLoad/5.0;
			Explosion.Emitters[3].StartSizeRange.Y.Max *= ChargeLoad/5.0;
			Explosion.Emitters[3].StartSizeRange.Z.Min *= ChargeLoad/5.0;
			Explosion.Emitters[3].StartSizeRange.Z.Max *= ChargeLoad/5.0;
			Explosion.Emitters[4].StartSizeRange.X.Min *= ChargeLoad/5.0;
			Explosion.Emitters[4].StartSizeRange.X.Max *= ChargeLoad/5.0;
			Explosion.Emitters[4].StartSizeRange.Y.Min *= ChargeLoad/5.0;
			Explosion.Emitters[4].StartSizeRange.Y.Max *= ChargeLoad/5.0;
			Explosion.Emitters[5].StartSizeRange.X.Min *= ChargeLoad/5.0;
			Explosion.Emitters[5].StartSizeRange.X.Max *= ChargeLoad/5.0;
			Explosion.Emitters[5].StartSizeRange.Y.Min *= ChargeLoad/5.0;
			Explosion.Emitters[5].StartSizeRange.Y.Max *= ChargeLoad/5.0;
			Explosion.Emitters[5].StartSizeRange.Z.Min *= ChargeLoad/5.0;
			Explosion.Emitters[5].StartSizeRange.Z.Max *= ChargeLoad/5.0;
			Explosion.Emitters[6].StartSizeRange.X.Min *= ChargeLoad/5.0;
			Explosion.Emitters[6].StartSizeRange.X.Max *= ChargeLoad/5.0;
			Explosion.Emitters[8].StartSizeRange.X.Min *= ChargeLoad/5.0;
			Explosion.Emitters[8].StartSizeRange.X.Max *= ChargeLoad/5.0;
			Explosion.Emitters[8].StartSizeRange.Y.Min *= ChargeLoad/5.0;
			Explosion.Emitters[8].StartSizeRange.Y.Max *= ChargeLoad/5.0;
			Explosion.Emitters[9].StartSizeRange.Z.Min *= ChargeLoad/5.0;
			Explosion.Emitters[9].StartSizeRange.Z.Max *= ChargeLoad/5.0;			
		}
		bHidden = true; //for netplay - makes it irrelevant
		if (ChargeEmitter != None)
			ChargeEmitter.Destroy();
		if (Instigator != None && Instigator.Health > 0)
		{
			MakeNoise(1.0);
			PlaySound(sound'WeaponSounds.redeemer_explosionsound');
			DoDamage(DamageRadius);
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
     ChargeTime=2.000000
     MaxDrain=30.000000
     MinDrain=15.000000
     DrainTime=5.000000
     DamageRadius=2200.000000
     DrawType=DT_None
     TransientSoundVolume=1.000000
     TransientSoundRadius=5000.000000
}
