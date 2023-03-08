class DEKSkyMineTurretBeamFire extends InstantFire;

var class<DEKSkyMineBeam> BeamEffectClass;
var() Vector ProjSpawnOffset;
var	bool				bSwitch;
var name				FireAnimLeft, FireAnimRight;
var	array<Projectile> Projectiles;

var float MinAim;

simulated function Rotator	GetPlayerAim( vector StartTrace, float InAimError )
{
	local vector HL, HN;
	ASVehicle(Instigator).CalcWeaponFire( HL, HN );
	return Rotator( HL - StartTrace );
}

event ModeDoFire()
{
	if ( Weapon.ThirdPersonActor != None )
		bSwitch = ( (WeaponAttachment(Weapon.ThirdPersonActor).FlashCount % 2) == 1 );
	else
		bSwitch = !bSwitch;

	super.ModeDoFire();
}

function DoFireEffect()
{
	local Vector	ProjOffset;
	local Vector	Start, X,Y,Z, HL, HN;
    local float CurAim, BestAim;
    local int o;
    local Projectile BestMine;

	if ( Instigator.IsA('ASVehicle') )
		ProjOffset = ASVehicle(Instigator).VehicleProjSpawnOffset;

	ProjSpawnOffset = ProjOffset;
	if ( bSwitch )
		ProjSpawnOffset.Y = -ProjSpawnOffset.Y;

	Instigator.MakeNoise(1.0);
    Instigator.GetAxes(Instigator.Rotation, X, Y, Z);

	Start = MyGetFireStart(X, Y, Z);

	ASVehicle(Instigator).CalcWeaponFire( HL, HN );
	BestAim = MinAim;
	for (o = 0; o < Projectiles.length; o++)
	{
		if (Projectiles[o] == None)
		{
			Projectiles.Remove(o, 1);
			o--;
		}
		else
		{
				BestMine = Projectiles[o];
				BestAim = CurAim;
		}
	}
	if (BestMine != None)
		DoTrace(Start, rotator(BestMine.Location - Start));
	else
	        DoTrace(Start, Rotator(HL - Start));
}

function DoTrace(Vector Start, Rotator Dir)
{
	local Vector X, Y, Z, End, HitLocation, HitNormal, RefNormal;
	local Actor Other;
	local int Damage;
	local bool bDoReflect;
	local int ReflectNum;
	local RPGStatsInv StatsInv;
	local float old_xp;
    local int DriverLevel;

	MaxRange();
	
	Start = MyGetFireStart(X, Y, Z);

	ReflectNum = 0;
	while (true)
	{
		bDoReflect = false;
		X = Vector(Dir);
		End = Start + TraceRange * X;

		Other = Weapon.Trace(HitLocation, HitNormal, End, Start, true);

		if ( Other != None && (Other != Instigator || ReflectNum > 0) )
		{
			if (bReflective && Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, DamageMin*0.25))
			{
				bDoReflect = true;
				HitNormal = Vect(0,0,0);
			}
			else if ( !Other.bWorldGeometry )
			{
				Damage = DamageMin;
				if ( (DamageMin != DamageMax) && (FRand() > 0.5) )
					Damage += Rand(1 + DamageMax - DamageMin);
				Damage = Damage * DamageAtten;

				// Update hit effect except for pawns (blood) other than vehicles.
				if ( Other.IsA('Vehicle') || (!Other.IsA('Pawn') && !Other.IsA('HitScanBlockingVolume')) )
					WeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(Other, HitLocation, HitNormal);

				// find the current dataobject
				if (DEKSkyMineTurret(Instigator) != None && DEKSkyMineTurret(Instigator).Driver != None)
				{
					StatsInv = RPGStatsInv(DEKSkyMineTurret(Instigator).Driver.FindInventoryType(class'RPGStatsInv'));
					if (StatsInv != None && StatsInv.DataObject != None)
					{
						old_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
						DriverLevel = StatsInv.DataObject.Level;

						if (Level.TimeSeconds > (DEKSkyMineTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay) && (DEKSkyMineTurret(Instigator).NumHealers > 0))
						{
							Damage = Damage * class'RW_EngineerLink'.static.DamageIncreasedByLinkers(DEKSkyMineTurret(Instigator).NumHealers);
						}
					}
				}

				Other.TakeDamage(Damage, Instigator, HitLocation, Momentum*X, DamageType);
				HitNormal = Vect(0,0,0);

                class'RW_EngineerLink'.static.DistributeHealingXP(StatsInv, DriverLevel, DEKSkyMineTurret(Instigator).Healers, old_xp, DEKSkyMineTurret(Instigator).RPGMut);

			}
			else if ( WeaponAttachment(Weapon.ThirdPersonActor) != None )
				WeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(Other,HitLocation,HitNormal);
		}
		else
		{
			HitLocation = End;
			HitNormal = Vect(0,0,0);
			WeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(Other,HitLocation,HitNormal);
		}

		if (bDoReflect && ++ReflectNum < 4)
		{
			Start = HitLocation;
			Dir = Rotator(RefNormal); //Rotator( X - 2.0*RefNormal*(X dot RefNormal) );
		}
		else
		{
			break;
		}
	}
	Instigator.PlaySound(Sound'ONSVehicleSounds-S.PRV.PRVFire02',,50.00);
	Super.DoTrace(Start, Dir);
}

function SpawnBeamEffect(Vector Start, Rotator Dir, Vector HitLocation, Vector HitNormal, int ReflectNum)
{
	local DEKSkyMineBeam Beam;
	local Vector X,Y,Z;
	
	Start = MyGetFireStart(X, Y, Z);

	Beam = Spawn(BeamEffectClass,,, Start, rotator(HitLocation - Start));
	BeamEmitter(Beam.Emitters[0]).BeamDistanceRange.Min = VSize(Start - HitLocation);
	BeamEmitter(Beam.Emitters[0]).BeamDistanceRange.Max = VSize(Start - HitLocation);
	BeamEmitter(Beam.Emitters[1]).BeamDistanceRange.Min = VSize(Start - HitLocation);
	BeamEmitter(Beam.Emitters[1]).BeamDistanceRange.Max = VSize(Start - HitLocation);
	Beam.SpawnEffects(HitLocation, HitNormal);
}

simulated function vector MyGetFireStart(vector X, vector Y, vector Z)
{
    return Instigator.Location + X*ProjSpawnOffset.X + Y*ProjSpawnOffset.Y + Z*ProjSpawnOffset.Z;
}

function PlayFiring()
{
	if ( Weapon.Mesh != None )
	{
		if ( bSwitch && Weapon.HasAnim(FireAnimRight) )
			FireAnim = FireAnimRight;
		else if ( !bSwitch && Weapon.HasAnim(FireAnimLeft) )
			FireAnim = FireAnimLeft;
	}

	super.PlayFiring();
}

defaultproperties
{
     BeamEffectClass=Class'DEKRPG999X.DEKSkyMineBeam'
     ProjSpawnOffset=(X=200.000000,Y=14.000000,Z=-14.000000)
     FireAnimLeft="FireL"
     FireAnimRight="FireR"
     MinAim=0.925000
     DamageType=Class'DEKRPG999X.DamTypeSkyMineBeam'
     DamageMin=25
     DamageMax=25
     FireSound=Sound'ONSVehicleSounds-S.PRV.PRVFire02'
     FireForce="PRVSideAltFire"
     FireRate=0.750000
     AmmoClass=Class'UT2k4Assault.Ammo_Dummy'
     ShakeRotMag=(X=40.000000)
     ShakeRotRate=(X=2000.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(Y=1.000000)
     ShakeOffsetRate=(Y=-2000.000000)
     ShakeOffsetTime=4.000000
}
