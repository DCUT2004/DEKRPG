class RuneIcicleFire extends RuneInstantFire
	config(DEKWeapons);
	
var RuneIcicleBeamEffect			Beam;
var class<RuneIcicleBeamEffect>	BeamEffectClass;

simulated function ModeTick(float dt)
{
	local Vector HitLocation, HitNormal, EndTrace, StartTrace, EndEffect;
    local Rotator R, Aim;
	local Actor Other;
	
	Super.ModeTick(dt);
	if (Instigator != None && bIsFiring)
	{
		StartTrace = Instigator.Location + Instigator.EyePosition();
		Aim = AdjustAim(StartTrace, AimError);
		R = rotator(vector(Aim) + VRand()*FRand()*Spread);
		EndTrace = StartTrace + Vector(R)*TraceRange;
		Other = Weapon.Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);
		if ( Other != None && Other != Instigator )
			EndEffect = HitLocation;
		else
			EndEffect = EndTrace;
		if (Beam == None)
			Beam = Weapon.Spawn(BeamEffectClass, Instigator, , Instigator.Location, rotator(EndEffect - Instigator.Location));
		if (Beam != None)
		{
			Beam.SetBase(Instigator);
			Beam.mSpawnVecA = EndEffect;
			Beam.SetRotation(rotator(EndEffect - Instigator.Location));
		}
	}
	else
	{
		if (Beam != None)
		{
			Beam.Destroy();
			Beam = None;
		}
	}
}

function DoTrace(Vector Start, Rotator Dir)
{
    local Vector X, End, HitLocation, HitNormal;
    local Actor Other;
    //local int Damage;
	local RuneIcicle Icicle;
	local RuneBlizzardEffect HitEffect;
	
	if (Instigator == None || Instigator.Controller == None)
		return;
	MaxRange();
	X = Vector(Dir);
	End = Start + TraceRange * X;

	Other = Weapon.Trace(HitLocation, HitNormal, End, Start, true);
	
	if (Other != None)
	{
		if (Other.bWorldGeometry)
		{
			if (Weapon.FastTrace(HitLocation, HitLocation + Vect(0,0,70)))	//If we don't hit anything above our spawn point, assume we're on the ground and spawn the Icicle
			{
				Icicle = Weapon.Spawn(Class'RuneIcicle', Instigator, , HitLocation + Vect(0, 0, -50));	//Spawn a bit down below so the icicles appear to be touching ground
				HitEffect = Instigator.Spawn(Class'RuneBlizzardEffect', , , HitLocation);
			}
		}
	}
}

defaultproperties
{
	 BeamEffectClass=Class'DEKRPG209B.RuneIcicleBeamEffect'
	 bModeExclusive=False
     //DamageType=Class'DEKRPG209B.DamTypeRuneHeatWhip'
	 AdrenCost=1
	 DamageMin=100
	 DamageMax=110
	 FireRate=0.5000000
     //FireSound=Sound'DEKRPG209B.RuneSounds.HeatWhipThrow'
     bReflective=False
     TraceRange=1000.000000
}
