class EngineerLinkProjectile extends LinkProjectile;

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	if (Other != None && Other.IsA('DruidEnergyWall'))
		return;
	Super.ProcessTouch(Other, HitLocation);
}

defaultproperties
{
     Speed=2500.000000
     MaxSpeed=6000.000000
     Damage=52.000000
}
