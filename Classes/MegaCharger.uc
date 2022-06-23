class MegaCharger extends Actor;

var xEmitter ChargeEmitter;
var MegaExplosion Explosion;
var class<DamageType> DamageType;
var float MomentumTransfer;
var AvoidMarker Fear;
var Controller InstigatorController;

var float ChargeTime;
var float Damage;
var float DamageRadius;

var float ChargeLoad;

function DoDamage(float BlastDamage,float Radius)
{
	local float damageScale, dist;
	local vector dir;
	local Controller C, NextC;

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
			dir = dir/dist;
			damageScale = 1 - FMax(0,dist/DamageRadius);
			C.Pawn.TakeDamage(damageScale * BlastDamage, Instigator, C.Pawn.Location, (damageScale * MomentumTransfer * dir), DamageType);

			//now see if we killed it
			if (C == None || C.Pawn == None || C.Pawn.Health <= 0 )
				class'ArtifactLightningBeam'.static.AddArtifactKill(Instigator, class'WeaponMegaBlast');	// assume killed
		}
		C = NextC;
	}
}

simulated function PostBeginPlay()
{
	if (Level.NetMode != NM_DedicatedServer)
		ChargeEmitter = spawn(class'MegaChargeEmitter');

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
			Fear.SetCollisionSize(DamageRadius, 200);
			Fear.StartleBots();

			Sleep(ChargeTime);
			Log("In MegaCharger: ChargeLoad is " $ ChargeLoad);
			if (Instigator != None && Instigator.Health > 0)
			{
				Explosion = Spawn(Class'MegaExplosion');
				if (Explosion != None)		//Oy-fucking vey
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
				MakeNoise(1.0);
				PlaySound(sound'WeaponSounds.redeemer_explosionsound');
				DoDamage(Damage*0.3,DamageRadius*0.4);
			}
			bHidden = true; //for netplay - makes it irrelevant
			if (ChargeEmitter != None)
				ChargeEmitter.Destroy();
			Sleep(0.05);
			if (Instigator != None && Instigator.Health > 0)
			{
				DoDamage(Damage*0.2,DamageRadius*0.6);
				Sleep(0.05);
			}
			if (Instigator != None && Instigator.Health > 0)
			{
				DoDamage(Damage*0.2,DamageRadius*0.8);
				Sleep(0.05);
			}
			if (Instigator != None && Instigator.Health > 0)
				DoDamage(Damage*0.3,DamageRadius);
		}
		else if (ChargeEmitter != None)
			ChargeEmitter.Destroy();


		if (Fear != None)
			Fear.Destroy();
		Destroy();
}

defaultproperties
{
     DamageType=Class'DEKRPG209C.DamTypeMegaExplosion'
     MomentumTransfer=20000.000000
     ChargeTime=2.000000
     Damage=260.000000
     DamageRadius=320.000000
     DrawType=DT_None
     TransientSoundVolume=1.000000
     TransientSoundRadius=5000.000000
}
