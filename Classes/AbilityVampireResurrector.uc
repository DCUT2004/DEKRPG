class AbilityVampireResurrector extends AbilityNiche
	config(UT2004RPG)
	abstract;
	
var config float VampirePercPerLevel;
var config float AdrenMultiplier;

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ArtifactResurrect AR;
	local AdrenMaxModifierInv Inv;
	
	if (Other != None)
	{
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
			AR.bVampireResurrect = True;
			AR.VampirePerc = (AbilityLevel*default.VampirePercPerLevel);
		}
		
		Inv = AdrenMaxModifierInv(Other.FindInventoryType(Class'AdrenMaxModifierInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(Class'AdrenMaxModifierInv');
			Inv.Multiplier = abs((AbilityLevel*default.AdrenMultiplier)-1);
			Inv.GiveTo(Other);
		}
	}
}

defaultproperties
{
     VampirePercPerLevel=0.050000
     AdrenMultiplier=0.030000
     ExcludingAbilities(0)=Class'DEKRPG209A.AbilityPowerResurrector'
     RequiredAbilities(0)=Class'DEKRPG209A.AbilityNecromancer'
     AbilityName="Niche: Vampire Resurrector"
     Description="Whenever your resurrectee damages an opponent, you are healed for 5% of the damage per level. Reduces your maximum adrenaline by 3% per level.||You must be level 180 and have Loaded Necromancer before buying this niche. You can not be in more than one niche at a time.||Cost(per level): 10"
     StartingCost=10
     MaxLevel=5
}
