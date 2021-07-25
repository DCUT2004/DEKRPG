class NecromancerSoulWeaponAltFire extends WeaponFire;

var config float LockAim;
var config float MaxRange;

function DoFireEffect()
{
	local Rotator rot1, rot2, rot3, rot4, rot5, rot6, rot1Target, rot2Target, rot3Target, rot4Target, rot5Target, rot6Target;
	local NecromancerSoulWeaponHomingSoul Proj1, Proj2, Proj3, Proj4, Proj5, Proj6;
	local vector FX2Radius, FX3Radius, FX4Radius, FX5Radius, FX6Radius;
	local float BestAim, BestDist;
	
		FX2Radius.X=Instigator.Location.X+-5+FRand();
		FX2Radius.Y=Instigator.Location.Y+-5+FRand();
		FX2Radius.Z=Instigator.Location.Z+-5+FRand();

		FRand();

		FX3Radius.X=Instigator.Location.X+5+FRand();
		FX3Radius.Y=Instigator.Location.Y+5+FRand();
		FX3Radius.Z=Instigator.Location.Z+5+FRand();

		FRand();

		FX4Radius.X=Instigator.Location.X+-10+FRand();
		FX4Radius.Y=Instigator.Location.Y+-10+FRand();
		FX4Radius.Z=Instigator.Location.Z+-10+FRand();

		FRand();

		FX5Radius.X=Instigator.Location.X+-10+FRand();
		FX5Radius.Y=Instigator.Location.Y+-10+FRand();
		FX5Radius.Z=Instigator.Location.Z+-10+FRand();
		
		FRand();

		FX6Radius.X=Instigator.Location.X+-15+FRand();
		FX6Radius.Y=Instigator.Location.Y+-15+FRand();
		FX6Radius.Z=Instigator.Location.Z+-15+FRand();
		
		rot1 = Instigator.Controller.GetViewRotation();
		rot1.yaw += FRand()*12000-6000;
		rot1.roll += FRand()*12000-6000;
		rot1Target = rot1;
		rot1Target.pitch -= 10000;
		
		rot2 = Instigator.Controller.GetViewRotation();
		rot2.yaw -= FRand()*12000-6000;
		rot2.roll -= FRand()*12000-6000;
		rot2Target = rot2;
		rot2Target.pitch -= 10000;		
		
		rot3 = Instigator.Controller.GetViewRotation();
		rot3.yaw += FRand()*12000-6000;
		rot3.roll += FRand()*12000-6000;
		rot3Target = rot3;
		rot3Target.pitch -= 10000;
		
		rot4 = Instigator.Controller.GetViewRotation();
		rot4.yaw -= FRand()*12000-6000;
		rot4.roll -= FRand()*12000-6000;
		rot4Target = rot4;
		rot4Target.pitch -= 10000;
		
		rot5 = Instigator.Controller.GetViewRotation();
		rot5.yaw += FRand()*12000-6000;
		rot5.roll += FRand()*12000-6000;
		rot5Target = rot5;
		rot5Target.pitch -= 10000;
		
		rot6 = Instigator.Controller.GetViewRotation();
		rot6.yaw -= FRand()*12000-6000;
		rot6.roll -= FRand()*12000-6000;
		rot6Target = rot6;
		rot6Target.pitch -= 10000;
		
		BestAim = LockAim;
		
		Proj1 = Spawn(class'NecromancerSoulWeaponHomingSoul',,,Instigator.Location ,rot1);
		Proj1.Seeking = Instigator.Controller.PickTarget(BestAim, BestDist, vector(rot1target), Instigator.Location, MaxRange);
		Proj2 = Spawn(class'NecromancerSoulWeaponHomingSoul',,,Instigator.Location,rot2);
		Proj2.Seeking = Instigator.Controller.PickTarget(BestAim, BestDist, vector(rot2target), Instigator.Location, MaxRange);
		Proj3 = Spawn(class'NecromancerSoulWeaponHomingSoul',,,Instigator.Location,rot3);
		Proj3.Seeking = Instigator.Controller.PickTarget(BestAim, BestDist, vector(rot3target), Instigator.Location, MaxRange);
		Proj4 = Spawn(class'NecromancerSoulWeaponHomingSoul',,,Instigator.Location,rot4);
		Proj4.Seeking = Instigator.Controller.PickTarget(BestAim, BestDist, vector(rot4target), Instigator.Location, MaxRange);
		Proj5 = Spawn(class'NecromancerSoulWeaponHomingSoul',,,Instigator.Location,rot5);
		Proj5.Seeking = Instigator.Controller.PickTarget(BestAim, BestDist, vector(rot5target), Instigator.Location, MaxRange);
		Proj6 = Spawn(class'NecromancerSoulWeaponHomingSoul',,,Instigator.Location,rot6);
		Proj6.Seeking = Instigator.Controller.PickTarget(BestAim, BestDist, vector(rot6target), Instigator.Location, MaxRange);
}

defaultproperties
{
     LockAim=0.000010
     MaxRange=90000.000000
     bModeExclusive=False
     FireRate=2.000000
     AmmoClass=Class'DEKRPG208AB.NecromancerSoulWeaponAmmo'
     AmmoPerFire=20
}
