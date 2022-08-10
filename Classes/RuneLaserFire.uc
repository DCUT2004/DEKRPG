class RuneLaserFire extends RuneInstantFire
	config(DEKWeapons);

var class<ShockBeamEffect> BeamMissEffectClass, BeamHitEffectClass;

function SpawnBeamEffect(Vector Start, Rotator Dir, Vector HitLocation, Vector HitNormal, int ReflectNum)
{
	local Actor Other;
    local ShockBeamEffect Beam;
	local Vector TempHitLocation, TempHitNormal;
	
	if (Weapon == None || Instigator == None)
		return;
		
	Other = Weapon.Trace(TempHitLocation, TempHitNormal, Start + TraceRange * Vector(Dir), Start, true);
	
	if (Other == None || Other != None && Pawn(Other) == None)
		Beam = Weapon.Spawn(BeamMissEffectClass,,, Start, Dir);
	else if (Other != None && Pawn(Other) != None )
	{
		if ( Pawn(Other).GetTeamNum() == Instigator.GetTeamNum() )
			Beam = Weapon.Spawn(BeamMissEffectClass,,, Start, Dir);
		else
			Beam = Weapon.Spawn(BeamHitEffectClass,,, Start, Dir);
	}
	if (Beam != None && ReflectNum != 0) Beam.Instigator = None; // prevents client side repositioning of beam start
		Beam.AimAt(HitLocation, HitNormal);
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
     BeamMissEffectClass=Class'XWeapons.SuperShockBeamEffect'
	 BeamHitEffectClass=Class'DEKRPG999X.GreenBeamEmitter'
     bReflective=True
     TraceRange=17000.000000
     Momentum=15000.000000
     Spread=0.030000
     SpreadStyle=SS_Random
}
