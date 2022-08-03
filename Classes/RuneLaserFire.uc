class RuneLaserFire extends RuneInstantFire
	config(DEKWeapons);

var class<ONSTurretBeamEffect> BeamEffectClass;

simulated function SpawnBeamEffect(Vector Start, Rotator Dir, Vector HitLocation, Vector HitNormal, int ReflectNum)
{
    local ONSTurretBeamEffect Beam;

    if (Weapon != None)
    {
        Beam = Weapon.Spawn(BeamEffectClass,,, Start, Dir);
		if (Beam != None)
		{
			Beam.RemoteRole = ROLE_SimulatedProxy;
			BeamEmitter(Beam.Emitters[0]).BeamDistanceRange.Min = VSize(Start - HitLocation);
			BeamEmitter(Beam.Emitters[0]).BeamDistanceRange.Max = VSize(Start - HitLocation);
			BeamEmitter(Beam.Emitters[1]).BeamDistanceRange.Min = VSize(Start - HitLocation);
			BeamEmitter(Beam.Emitters[1]).BeamDistanceRange.Max = VSize(Start - HitLocation);
			Beam.SpawnEffects(HitLocation, HitNormal);
		}
    }
}

defaultproperties
{
     bModeExclusive=False
     DamageType=Class'DEKRPG999X.DamTypeRuneLaser'
	 AdrenCost=1
	 DamageMin=18
	 DamageMax=22
     FireRate=0.2000000
     FireSound=Sound'ONSVehicleSounds-S.LaserSounds.Laser09'
     BeamEffectClass=Class'DEKRPG999X.RuneLaserEffect'
     bReflective=False
     TraceRange=17000.000000
     Momentum=15000.000000
     Spread=0.030000
     SpreadStyle=SS_Random
}
