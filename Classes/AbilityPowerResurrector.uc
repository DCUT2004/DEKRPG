class AbilityPowerResurrector extends AbilityNiche
	config(UT2004RPG)
	abstract;
	
var config float PowerPercPerLevel;
var config float HealthReductionPerLevel;

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ArtifactResurrect AR;
	local HealthReducerInv Inv;
	
	AR = ArtifactResurrect(Other.FindInventoryType(class'ArtifactResurrect'));
	if (AR == None)
	{
		AR = Other.spawn(class'ArtifactResurrect', Other,,, rot(0,0,0));
		if(AR == None)
			return; //get em next pass I guess?
		AR.giveTo(Other);
	}
	if (AR != None)
	{
		AR.bPowerResurrect = True;
		AR.PowerPerc = (AbilityLevel*default.PowerPercPerLevel);
	}
	
	Inv = HealthReducerInv(Other.FindInventoryType(class'HealthReducerInv'));
	if (Inv == None)
	{
		Inv = Other.Spawn(class'HealthReducerInv');
		Inv.AbilityLevel = AbilityLevel;
		Inv.HealthReductionPerLevel = default.HealthReductionPerLevel;
		Inv.GiveTo(Other);
	}

}

defaultproperties
{
     PowerPercPerLevel=0.050000
     HealthReductionPerLevel=10.000000
     ExcludingAbilities(0)=Class'DEKRPG208AA.AbilityVampireResurrector'
     RequiredAbilities(0)=Class'DEKRPG208AA.AbilityNecromancer'
     AbilityName="Niche: Power Resurrector"
     Description="Provides an additional 5% damage bonus per level to your resurrectees. Reduces your maximum health by 10 per level.||You must be level 180 and have Loaded Necromancer before buying this niche. You can not be in more than one niche at a time.||Cost(per level): 10"
     StartingCost=10
     MaxLevel=5
}
