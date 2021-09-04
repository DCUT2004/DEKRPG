class RuneIceBeamFire extends RuneInstantFire
	config(DEKWeapons);

var() class<RuneIceBeamEffect> BeamEffectClass;
var Class<Emitter> ExplosionEffectClass;
var config float BlastDamage;
var config float BlastRadius;
var bool bHurtEntry;	

function DoTrace(Vector Start, Rotator Dir)
{
    local Vector X, End, HitLocation, HitNormal;
    local Actor Other;
    local int Damage;
	local RuneIceBeamExplosionActor A;
	local Emitter FX;

	MaxRange();
	X = Vector(Dir);
	End = Start + TraceRange * X;

	Other = Weapon.Trace(HitLocation, HitNormal, End, Start, true);

	if ( Other != None && Other != Instigator )
	{
		if ( !Other.bWorldGeometry )
		{
			Damage = DamageMin;
			if ( (DamageMin != DamageMax) && (FRand() > 0.5) )
				Damage += Rand(1 + DamageMax - DamageMin);
			Damage = Damage * DamageAtten;

			// Update hit effect except for pawns (blood) other than vehicles.
			if ( Other.IsA('Vehicle') || (!Other.IsA('Pawn') && !Other.IsA('HitScanBlockingVolume')) )
				WeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(Other, HitLocation, HitNormal);

			Other.TakeDamage(Damage, Instigator, HitLocation, Momentum*X, DamageType);
			HitNormal = Vect(0,0,0);
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
	//Spawn a quick actor at HitLocation to deal radius damage
	A = Instigator.Spawn(Class'RuneIceBeamExplosionActor', Instigator, , HitLocation);
	if (A != None)
	{
		A.HurtRadius(BlastDamage, BlastRadius, DamageType, Momentum, HitLocation);
		FX = Instigator.Spawn(ExplosionEffectClass, Instigator,, HitLocation);
		if (FX != None)
			if ( Level.NetMode == NM_DedicatedServer )
				FX.LifeSpan = 0.7;
		A.Destroy();
	}
	SpawnBeamEffect(Start, Dir, HitLocation, HitNormal, 1);
}

function SpawnBeamEffect(Vector Start, Rotator Dir, Vector HitLocation, Vector HitNormal, int ReflectNum)
{
    local RuneIceBeamEffect Beam;

    if (Weapon != None)
    {
        Beam = Weapon.Spawn(BeamEffectClass,,, Start, Dir);
		Beam.AimAt(HitLocation, HitNormal);
    }
}

defaultproperties
{
	BlastDamage=100.0000
	BlastRadius=400.0000
	DamageType=Class'DEKRPG209A.DamTypeRuneIceBeam'
	AdrenCost=10
	DamageMin=110
	DamageMax=120
	FireRate=2.00000000
	FireSound=Sound'PlayerSounds.BFootsteps.BFootstepSnow4'
	BeamEffectClass=Class'DEKRPG209A.RuneIceBeamEffect'
	ExplosionEffectClass=Class'DEKRPG209A.RuneIceBeamExplosion'
	bReflective=False
	Momentum=60000.000000
}
