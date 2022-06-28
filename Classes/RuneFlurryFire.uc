class RuneFlurryFire extends RuneProjectileFire
	config(DEKWeapons);
	
var config float MinFlurryRangeX, MaxFlurryRangeX;	//How much left/right flares should spawn
var config float MinFlurryRangeY, MaxFlurryRangeY;	//How much forward/backward flares should spawn
var config float MinFlurryRangeZ, MaxFlurryRangeZ;	//How much above/below flares should spawn
var config float Range;

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
	local Projectile P;
	local Vector SpawnLocation;
	local Vector HitLocation, HitNormal, End;
	local Actor Other, MuzFlash;
	
	End = Start + Vector(Dir)*Range;
	
	if (Instigator == None || Instigator.Controller == None)
		return None;
		
	//Check if we have enough adren
	if (Instigator.Controller.Adrenaline < AdrenCost)
		return None;
	
	SpawnLocation = Start;
	
	SpawnLocation.X += RandRange(MinFlurryRangeX, MaxFlurryRangeX);
	SpawnLocation.Y += RandRange(MinFlurryRangeY, MaxFlurryRangeY);
	SpawnLocation.Z += RandRange(MinFlurryRangeZ, MaxFlurryRangeZ);
	
	Other = Weapon.Trace(HitLocation, HitNormal, End, Start, true);
	
	if (Other != None)
		Dir = Rotator(HitLocation - SpawnLocation);
	
	P = Weapon.Spawn(ProjectileClass,,, SpawnLocation, Dir);
	if (P == None)
		return None;
	
	MuzFlash = Spawn(Class'RuneFlurryMuzzle',,, SpawnLocation);
	if (MuzFlash != None)
		MuzFlash.RemoteRole = ROLE_SimulatedProxy;
    p.Damage *= DamageAtten;
	Instigator.Controller.Adrenaline -= AdrenCost;
	return P;
}

defaultproperties
{
	 Range=50000.0000000000000
	 MinFlurryRangeX=-150.000000
	 MaxFlurryRangeX=150.00000
	 MinFlurryRAngeY=-150.0000
	 MaxFlurryRangeY=150.00000
	 MinFlurryRangeZ=0.0000
	 MaxFlurryRangeZ=200.00000
	 AdrenCost=2
     FireSound=Sound'ONSVehicleSounds-S.LaserSounds.Laser16'
     FireForce="RocketLauncherFire"
     FireRate=0.300000
     ProjectileClass=Class'DEKRPG209E.RuneFlurryProj'
     //Spread=1500.0000
     //SpreadStyle=SS_Random
}
