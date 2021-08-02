class AbilityNimbleBerserker extends AbilityNiche
	config(UT2004RPG) 
	abstract;
	
var config float SpeedMultiplier;
var config int HealthMultiplier;

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local xPawn X;
	local HealthMaxModifierInv Inv;
	
	if (Other != None)
	{
		X = xPawn(Other);
		if (X != None && X.Role == ROLE_Authority)
		{
			X.DodgeSpeedFactor = X.default.DodgeSpeedFactor * (1.0 + default.SpeedMultiplier * float(AbilityLevel));
			X.DodgeSpeedZ = X.default.DodgeSpeedZ * (1.0 + default.SpeedMultiplier * float(AbilityLevel));
		}
		
		Inv = HealthMaxModifierInv(Other.FindInventoryType(Class'HealthMaxModifierInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(Class'HealthMaxModifierInv');
			Inv.Multiplier = abs((AbilityLevel*default.HealthMultiplier)-1);
			Inv.GiveTo(Other);
		}
	}
}

defaultproperties
{
     SpeedMultiplier=0.100000
     HealthMultiplier=0.0300000000
     ExcludingAbilities(0)=Class'DEKRPG208AE.AbilityMeleeBerserker'
     AbilityName="Niche: Nimble"
     Description="Increases your dodging speed by 10% per level, but reduces max health by 3% per level.|You must be level 180 to buy a niche. You can not be in more than one niche at a time.|Cost (per level): 10."
     StartingCost=10
     MaxLevel=20
}
