class RuneFlareFire extends RuneInstantFire
	config(DEKWeapons);
	
var config float MinFlareRangeX, MaxFlareRangeX;	//How much left/right flares should spawn
var config float MinFlareRangeY, MaxFlareRangeY;	//How much forward/backward flares should spawn
var config float MinFlareRangeZ, MaxFlareRangeZ;	//How much above/below flares should spawn
var Array < Class < RuneFlareBurst > > Bursts;
var config int BurstDamage;
var config float BurstDamageRadius;

function DoFireEffect()
{
	local RuneFlareBurst Burst;
	local Vector SpawnLocation;
	local int x;
	
	if (Instigator == None || Instigator.Controller == None)
		return;
	
	//First, check to see if we have enough adren
	
	if (Instigator.Controller.Adrenaline < AdrenCost)
		return;

    Instigator.MakeNoise(1.0);

	SpawnLocation = Instigator.Location;
	
	SpawnLocation.X += RandRange(MinFlareRangeX, MaxFlareRangeX);
	SpawnLocation.Y += RandRange(MinFlareRangeY, MaxFlareRangeY);
	SpawnLocation.Z += RandRange(MinFlareRangeZ, MaxFlareRangeZ);

	x = RandRange(0, Bursts.Length);

	Burst = Instigator.Spawn(Bursts[x], Instigator, , SpawnLocation);
	if (Burst != None)
	{
		Instigator.Controller.Adrenaline -= AdrenCost;
		Burst.HurtRadius(BurstDamage, BurstDamageRadius, DamageType, Momentum, Burst.Location);
		Burst.Destroy();
	}
}

defaultproperties
{	
	 MinFlareRangeX=-300.000000
	 MaxFlareRangeX=300.00000
	 MinFlareRAngeY=-300.0000
	 MaxFlareRangeY=300.00000
	 MinFlareRangeZ=0.0000
	 MaxFlareRangeZ=200.00000
	 Bursts(0)=Class'DEKRPG209E.RuneFlareBurstRed'
	 Bursts(1)=Class'DEKRPG209E.RuneFlareBurstBlue'
	 Bursts(2)=Class'DEKRPG209E.RuneFlareBurstGreen'
	 AdrenCost=0.60000000
	 BurstDamage=60
	 BurstDamageRadius=300.000
     FireRate=0.100000
	 DamageType=Class'DEKRPG209E.DamTypeRuneFlare'
     FireSound=Sound'ONSVehicleSounds-S.HoverBike.HoverBikeFire01'
     bModeExclusive=False
     bReflective=False
}
