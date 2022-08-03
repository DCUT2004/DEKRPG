class RuneEarthquakeFire extends RuneInstantFire
	config(DEKWeapons);
	
function DoTrace(Vector Start, Rotator Dir)
{
    local Vector X;
	local RuneEarthquakeInv Inv;

	MaxRange();
	X = Vector(Dir);
	if (Instigator.Physics != PHYS_None)	//Make sure we can't do this while nulled/in Halt
		Instigator.SetPhysics(PHYS_Falling);
	Instigator.Velocity.Z += 200;
	Instigator.Velocity += TraceRange * X;	//X is direction, TraceRange is magnitude
	
	Inv = RuneEarthquakeInv(Instigator.FindInventoryType(Class'RuneEarthquakeInv'));
	if (Inv == None && Instigator.Physics == PHYS_Falling)
	{
		Inv = Instigator.Spawn(Class'RuneEarthquakeInv');
		Inv.GiveTo(Instigator);
	}
}

defaultproperties
{
     bModeExclusive=False
	 TraceRange=1400.000000
	 AdrenCost=15.00000000
     FireRate=2.5000000
     //FireSound=Sound'ONSVehicleSounds-S.HoverBike.HoverBikeFire01'
     bReflective=False
}
