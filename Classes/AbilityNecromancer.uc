class AbilityNecromancer extends RPGDeathAbility
	config(UT2004RPG);

var config float SacrificeReductionPerLevel, ExtremeSacrificePerc;
var config float MinimumSacrificeRequired;
var config float LifespanPerLevel;
var config float MaxLifespan;
var config int ExtremeAdrenalineRequired;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local LoadedInv LoadedInv;
	local ArtifactResurrect AR;

	LoadedInv = LoadedInv(Other.FindInventoryType(class'LoadedInv'));

	if(LoadedInv != None)
	{
		if(LoadedInv.bGotLoadedNecromancer && LoadedInv.LNAbilityLevel == AbilityLevel)
			return;
	}
	else
	{
		LoadedInv = Other.spawn(class'LoadedInv');
		LoadedInv.giveTo(Other);
	}

	if(LoadedInv == None)
		return;

	LoadedInv.bGotLoadedNecromancer = true;
	LoadedInv.LNAbilityLevel = AbilityLevel;
		
	AR = ArtifactResurrect(Other.FindInventoryType(class'ArtifactResurrect'));
	if (AR == None)
	{
		AR = Other.spawn(class'ArtifactResurrect', Other,,, rot(0,0,0));
		if(AR == None)
			return; //get em next pass I guess?
		AR.giveTo(Other);
	}
	EnhanceResurrect(Other, AbilityLevel, AR);
	
	if(Other.SelectedItem == None)
		Other.NextItem();
}

static function EnhanceResurrect(Pawn Other, int AbilityLevel, ArtifactResurrect AR)
{
	if (AbilityLevel <= 1)
		return;
	else if (AbilityLevel >= 6)	//Extreme
	{
		if (AR != None)
		{
			AR.SacrificePerc = (AbilityLevel * default.ExtremeSacrificePerc);
			AR.AdrenalineRequired = default.ExtremeAdrenalineRequired;
			AR.RevenantLifespan += (AbilityLevel * default.LifespanPerLevel);
			if (AR.RevenantLifespan > default.MaxLifespan)
				AR.RevenantLifespan = default.MaxLifespan;		
		}
	}
	else
	{
		if (AR != None)
		{
			AR.SacrificePerc -= (AbilityLevel * default.SacrificeReductionPerLevel);
			if (AR.SacrificePerc < default.MinimumSacrificeRequired)
				AR.SacrificePerc = default.MinimumSacrificeRequired;
			AR.RevenantLifespan += (AbilityLevel * default.LifespanPerLevel);
			if (AR.RevenantLifespan > default.MaxLifespan)
				AR.RevenantLifespan = default.MaxLifespan;
		}
		else
			return;
	}
}

defaultproperties
{
     SacrificeReductionPerLevel=0.050000
     MinimumSacrificeRequired=0.250000
     LifespanPerLevel=5.000000
     MaxLifespan=70.000000
     ExtremeAdrenalineRequired=100
     MinHealthBonus=100
     MinAdrenalineMax=150
     AbilityName="Loaded Necromancer"
     Description="You are granted the Resurrect artifact. You can revive dead teammates for a period of time, after which they will be sent back to death. During their time alive, resurrected teammates are invulnerable, and experience earned by them will also be rewarded to you as experience.||Each additional level of this ability decreases the health sacrifice requirements of the resurrect artifact by 5% per level and also increases the lifespan of resurrected teammates by 5 seconds per level.|Extreme level 6 reduces the adrenaline cost and removes the health sacrifice.||You must have 150 adrenaline bonus and 100 health bonus before purchasing this ability.||Cost(per level): 6,9,12,15,18."
     StartingCost=6
     CostAddPerLevel=3
     MaxLevel=6
}
