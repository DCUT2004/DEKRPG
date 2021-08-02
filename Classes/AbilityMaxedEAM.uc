class AbilityMaxedEAM extends AbilityNiche
	config(UT2004RPG) 
	abstract;
	
var config float AdrenMultiplier;
var config float HealthMultiplier;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local HealthMaxModifierInv HInv;
	local AdrenMaxModifierInv AInv;
	
	if (Other != None)
	{
		HInv = HealthMaxModifierInv(Other.FindInventoryType(Class'HealthMaxModifierInv'));
		AInv = AdrenMaxModifierInv(Other.FindInventoryType(Class'AdrenMaxModifierInv'));
		if (HInv == None)
		{
			HInv = Other.Spawn(Class'HealthMaxModifierInv');
			HInv.Multiplier = abs((AbilityLevel*default.HealthMultiplier)-1);
			HInv.GiveTo(Other);
		}
		if (AInv == None)
		{
			AInv = Other.Spawn(Class'AdrenMaxModifierInv');
			AInv.Multiplier = 1 + AbilityLevel*default.AdrenMultiplier;
			AInv.GiveTo(Other);			
		}
	}
}

defaultproperties
{
     AdrenMultiplier=0.0300000
     HealthMultiplier=0.0300000000
     ExcludingAbilities(0)=Class'DEKRPG208AE.AbilityWizardEAM'
     ExcludingAbilities(1)=Class'DEKRPG208AE.AbilityPowerEAM'
     AbilityName="Niche: Maxed"
     Description="Increases your max adrenaline by 3% per level, but also decreases max health by 3% per level.|You must be level 180 to buy a niche. You can not be in more than one niche at a time.|Cost (per level): 10."
     StartingCost=10
     MaxLevel=20
}
