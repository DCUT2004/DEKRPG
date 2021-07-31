class AbilityNimbleBerserker extends AbilityNiche
	config(UT2004RPG) 
	abstract;
	
var config float SpeedMultiplier;
var config int HealthReductionPerLevel;

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local xPawn X;
	local HealthReducerInv Inv;
	
	Inv = HealthReducerInv(Other.FindInventoryType(class'HealthReducerInv'));
		
	if (Inv == None)
	{
		Inv = Other.spawn(class'HealthReducerInv');		
		Inv.AbilityLevel = AbilityLevel;
		Inv.HealthReductionPerLevel = default.HealthReductionPerLevel;
		Inv.giveTo(Other);
	}
	
	X = xPawn(Other);
	if (X.Role == ROLE_Authority)
	{
		X.DodgeSpeedFactor = X.default.DodgeSpeedFactor * (1.0 + default.SpeedMultiplier * float(AbilityLevel));
		X.DodgeSpeedZ = X.default.DodgeSpeedZ * (1.0 + default.SpeedMultiplier * float(AbilityLevel));
	}
}

defaultproperties
{
     SpeedMultiplier=0.100000
     HealthReductionPerLevel=10
     ExcludingAbilities(0)=Class'DEKRPG208AD.AbilityMeleeBerserker'
     AbilityName="Niche: Nimble"
     Description="Increases your dodging speed by 10% per level, but reduces max health by 10 per level.|You must be level 180 to buy a niche. You can not be in more than one niche at a time.|Cost (per level): 10."
     StartingCost=10
     MaxLevel=20
}
