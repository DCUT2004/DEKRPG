class AbilityEnhancedArtifacts extends CostRPGAbility
	config(UT2004RPG);
	
var config int Lev1DAMMWAdren, Lev2DAMMWAdren, Lev3DAMMWAdren, Lev4DAMMWAdren, Lev5DAMMWAdren;
var config int Lev1DMMAdren, Lev2DMMAdren, Lev3DMMAdren, Lev4DMMAdren, Lev5DMMAdren;
var config int Lev1DDMAdren, Lev2DDMAdren, Lev3DDMAdren, Lev4DDMAdren, Lev5DDMAdren;
var config int Lev1RemoteAdren, Lev2RemoteAdren, Lev3RemoteAdren, Lev4RemoteAdren, Lev5RemoteAdren;
var config int Lev1ASICostPerSec, Lev2ASICostPerSec, Lev3ASICostPerSec, Lev4ASICostPerSec, Lev5ASICostPerSec;
var config int Lev1ASIAdren, Lev2ASIAdren, Lev3ASIAdren, Lev4ASIAdren, Lev5ASIAdren;
var config int Lev1ASDCostPerSec, Lev2ASDCostPerSec, Lev3ASDCostPerSec, Lev4ASDCostPerSec, Lev5ASDCostPerSec;
var config int Lev1ASDAdren, Lev2ASDAdren, Lev3ASDAdren, Lev4ASDAdren, Lev5ASDAdren;
var config int AdrenDecreasePerLevel;

static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	local int x;

	for (x = 0; x < Data.Abilities.length; x++)
	{
		if (Data.Abilities[x] == class'AbilityLoadedCraftsman')
			if (Data.AbilityLevels[x] >= 3)
				return Super.Cost(Data, CurrentLevel);
	}

	return 0;
}

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ArtifactSphereInvulnerability ASI;
	local ArtifactSphereDamage ASD;
	local ArtifactRemoteDamage ARD;
	local ArtifactRemoteInvulnerability ARI;
	local ArtifactRemoteMax ARM;
	local ArtifactRemoteAmplifier ARA;
	local DruidArtifactMakeMagicWeapon DAMMW;
	local DruidMaxModifier DMM;
	local DruidDoubleModifier DDM;

	ASI = ArtifactSphereInvulnerability(Other.FindInventoryType(class'ArtifactSphereInvulnerability'));

	ASD = ArtifactSphereDamage(Other.FindInventoryType(class'ArtifactSphereDamage'));

	ARD = ArtifactRemoteDamage(Other.FindInventoryType(class'ArtifactRemoteDamage'));

	ARI = ArtifactRemoteInvulnerability(Other.FindInventoryType(class'ArtifactRemoteInvulnerability'));

	ARM = ArtifactRemoteMax(Other.FindInventoryType(class'ArtifactRemoteMax'));
	
	ARA = ArtifactRemoteAmplifier(Other.FindInventoryType(class'ArtifactRemoteAmplifier'));

	DAMMW = DruidArtifactMakeMagicWeapon(Other.FindInventoryType(class'DruidArtifactMakeMagicWeapon'));

	DMM = DruidMaxModifier(Other.FindInventoryType(class'DruidMaxModifier'));

	DDM = DruidDoubleModifier(Other.FindInventoryType(class'DruidDoubleModifier'));
	
	if (ARA != None)
	{
		ARA.AdrenalineRequired -= (AbilityLevel * default.AdrenDecreasePerLevel);
	}
	
	if(AbilityLevel == 1)
	{
		if (DAMMW != None)
			DAMMW.AdrenalineRequired = (Default.Lev1DAMMWAdren);
		if (DMM != None)
			DMM.AdrenalineRequired = (Default.Lev1DMMAdren);
		if (DDM != None)
			DDM.CostPerSec = (Default.Lev1DDMAdren);
		if (ARI != None)
			ARI.AdrenalineRequired = (Default.Lev1RemoteAdren);
		if (ARD != None)
			ARD.AdrenalineRequired = (Default.Lev1RemoteAdren);
		if (ARM != None)
			ARM.AdrenalineRequired = (Default.Lev1DMMAdren);
	}
	else if(AbilityLevel == 2)
	{
		if (DAMMW != None)
			DAMMW.AdrenalineRequired = (Default.Lev2DAMMWAdren);
		if (DMM != None)
			DMM.AdrenalineRequired = (Default.Lev2DMMAdren);
		if (DDM != None)
			DDM.CostPerSec = (Default.Lev2DDMAdren);
		if (ARI != None)
			ARI.AdrenalineRequired = (Default.Lev2RemoteAdren);
		if (ARD != None)
			ARD.AdrenalineRequired = (Default.Lev2RemoteAdren);
		if (ARM != None)
			ARM.AdrenalineRequired = (Default.Lev2DMMAdren);
	}
	else if(AbilityLevel == 3)
	{
		if (DAMMW != None)
			DAMMW.AdrenalineRequired = (Default.Lev3DAMMWAdren);
		if (DMM != None)
			DMM.AdrenalineRequired = (Default.Lev3DMMAdren);
		if (DDM != None)
			DDM.CostPerSec = (Default.Lev3DDMAdren);
		if (ARI != None)
			ARI.AdrenalineRequired = (Default.Lev3RemoteAdren);
		if (ARD != None)
			ARD.AdrenalineRequired = (Default.Lev3RemoteAdren);
		if (ARM != None)
			ARM.AdrenalineRequired = (Default.Lev3DMMAdren);
	}
	else if(AbilityLevel == 4)
	{
		if (DAMMW != None)
			DAMMW.AdrenalineRequired = (Default.Lev4DAMMWAdren);
		if (DMM != None)
			DMM.AdrenalineRequired = (Default.Lev4DMMAdren);
		if (DDM != None)
			DDM.CostPerSec = (Default.Lev4DDMAdren);
		if (ARI != None)
			ARI.AdrenalineRequired = (Default.Lev4RemoteAdren);
		if (ARD != None)
			ARD.AdrenalineRequired = (Default.Lev4RemoteAdren);
		if (ARM != None)
			ARM.AdrenalineRequired = (Default.Lev4DMMAdren);
	}
	else if(AbilityLevel == 5)
	{
		if (DAMMW != None)
			DAMMW.AdrenalineRequired = (Default.Lev5DAMMWAdren);
		if (DMM != None)
			DMM.AdrenalineRequired = (Default.Lev5DMMAdren);
		if (DDM != None)
			DDM.CostPerSec = (Default.Lev5DDMAdren);
		if (ARI != None)
			ARI.AdrenalineRequired = (Default.Lev5RemoteAdren);
		if (ARD != None)
			ARD.AdrenalineRequired = (Default.Lev5RemoteAdren);
		if (ARM != None)
			ARM.AdrenalineRequired = (Default.Lev5DMMAdren);
	}
	else if(AbilityLevel == 6)
	{
		if (DAMMW != None)
			DAMMW.AdrenalineRequired = (Default.Lev5DAMMWAdren);
		if (DMM != None)
			DMM.AdrenalineRequired = (Default.Lev5DMMAdren);
		if (DDM != None)
			DDM.CostPerSec = (Default.Lev5DDMAdren);
		if (ARI != None)
			ARI.AdrenalineRequired = (Default.Lev5RemoteAdren);
		if (ARD != None)
			ARD.AdrenalineRequired = (Default.Lev5RemoteAdren);
		if (ARM != None)
			ARM.AdrenalineRequired = (Default.Lev5DMMAdren);
		if (ASI != None)
		{
			ASI.CostPerSec = (Default.Lev1ASICostPerSec);
			ASI.AdrenalineRequired = (Default.Lev1ASIAdren);
		}
		if (ASD != None)
		{
			ASD.CostPerSec = (Default.Lev1ASDCostPerSec);
			ASD.AdrenalineRequired = (Default.Lev1ASDAdren);
		}
	}
	else if(AbilityLevel == 7)
	{
		if (DAMMW != None)
			DAMMW.AdrenalineRequired = (Default.Lev5DAMMWAdren);
		if (DMM != None)
			DMM.AdrenalineRequired = (Default.Lev5DMMAdren);
		if (DDM != None)
			DDM.CostPerSec = (Default.Lev5DDMAdren);
		if (ARI != None)
			ARI.AdrenalineRequired = (Default.Lev5RemoteAdren);
		if (ARD != None)
			ARD.AdrenalineRequired = (Default.Lev5RemoteAdren);
		if (ARM != None)
			ARM.AdrenalineRequired = (Default.Lev5DMMAdren);
		if (ASI != None)
		{
			ASI.CostPerSec = (Default.Lev2ASICostPerSec);
			ASI.AdrenalineRequired = (Default.Lev2ASIAdren);
		}
		if (ASD != None)
		{
			ASD.CostPerSec = (Default.Lev2ASDCostPerSec);
			ASD.AdrenalineRequired = (Default.Lev2ASDAdren);
		}
	}
	else if(AbilityLevel == 8)
	{
		if (DAMMW != None)
			DAMMW.AdrenalineRequired = (Default.Lev5DAMMWAdren);
		if (DMM != None)
			DMM.AdrenalineRequired = (Default.Lev5DMMAdren);
		if (DDM != None)
			DDM.CostPerSec = (Default.Lev5DDMAdren);
		if (ARI != None)
			ARI.AdrenalineRequired = (Default.Lev5RemoteAdren);
		if (ARD != None)
			ARD.AdrenalineRequired = (Default.Lev5RemoteAdren);
		if (ARM != None)
			ARM.AdrenalineRequired = (Default.Lev5DMMAdren);
		if (ASI != None)
		{
			ASI.CostPerSec = (Default.Lev3ASICostPerSec);
			ASI.AdrenalineRequired = (Default.Lev3ASIAdren);
		}
		if (ASD != None)
		{
			ASD.CostPerSec = (Default.Lev3ASDCostPerSec);
			ASD.AdrenalineRequired = (Default.Lev3ASDAdren);
		}
	}
	else if(AbilityLevel == 9)
	{
		if (DAMMW != None)
			DAMMW.AdrenalineRequired = (Default.Lev5DAMMWAdren);
		if (DMM != None)
			DMM.AdrenalineRequired = (Default.Lev5DMMAdren);
		if (DDM != None)
			DDM.CostPerSec = (Default.Lev5DDMAdren);
		if (ARI != None)
			ARI.AdrenalineRequired = (Default.Lev5RemoteAdren);
		if (ARD != None)
			ARD.AdrenalineRequired = (Default.Lev5RemoteAdren);
		if (ARM != None)
			ARM.AdrenalineRequired = (Default.Lev5DMMAdren);
		if (ASI != None)
		{
			ASI.CostPerSec = (Default.Lev4ASICostPerSec);
			ASI.AdrenalineRequired = (Default.Lev4ASIAdren);
		}
		if (ASD != None)
		{
			ASD.CostPerSec = (Default.Lev4ASDCostPerSec);
			ASD.AdrenalineRequired = (Default.Lev4ASDAdren);
		}
	}
	else if(AbilityLevel == 10)
	{
		if (DAMMW != None)
			DAMMW.AdrenalineRequired = (Default.Lev5DAMMWAdren);
		if (DMM != None)
			DMM.AdrenalineRequired = (Default.Lev5DMMAdren);
		if (DDM != None)
			DDM.CostPerSec = (Default.Lev5DDMAdren);
		if (ARI != None)
			ARI.AdrenalineRequired = (Default.Lev5RemoteAdren);
		if (ARD != None)
			ARD.AdrenalineRequired = (Default.Lev5RemoteAdren);
		if (ARM != None)
			ARM.AdrenalineRequired = (Default.Lev5DMMAdren);
		if (ASI != None)
		{
			ASI.CostPerSec = (Default.Lev5ASICostPerSec);
			ASI.AdrenalineRequired = (Default.Lev5ASIAdren);
		}
		if (ASD != None)
		{
			ASD.CostPerSec = (Default.Lev5ASDCostPerSec);
			ASD.AdrenalineRequired = (Default.Lev5ASDAdren);
		}
	}
}

defaultproperties
{
     Lev1DAMMWAdren=70
     Lev2DAMMWAdren=65
     Lev3DAMMWAdren=60
     Lev4DAMMWAdren=55
     Lev5DAMMWAdren=50
     Lev1DMMAdren=140
     Lev2DMMAdren=130
     Lev3DMMAdren=120
     Lev4DMMAdren=110
     Lev5DMMAdren=100
     Lev1DDMAdren=9
     Lev2DDMAdren=8
     Lev3DDMAdren=7
     Lev4DDMAdren=6
     Lev5DDMAdren=5
     Lev1RemoteAdren=90
     Lev2RemoteAdren=80
     Lev3RemoteAdren=70
     Lev4RemoteAdren=60
     Lev5RemoteAdren=50
     Lev1ASICostPerSec=17
     Lev2ASICostPerSec=16
     Lev3ASICostPerSec=15
     Lev4ASICostPerSec=14
     Lev5ASICostPerSec=12
     Lev1ASIAdren=67
     Lev2ASIAdren=62
     Lev3ASIAdren=57
     Lev4ASIAdren=52
     Lev5ASIAdren=47
     Lev1ASDCostPerSec=14
     Lev2ASDCostPerSec=13
     Lev3ASDCostPerSec=12
     Lev4ASDCostPerSec=11
     Lev5ASDCostPerSec=10
     Lev1ASDAdren=38
     Lev2ASDAdren=36
     Lev3ASDAdren=34
     Lev4ASDAdren=32
     Lev5ASDAdren=30
     AdrenDecreasePerLevel=5
     LevelCost(1)=7
     LevelCost(2)=7
     LevelCost(3)=7
     LevelCost(4)=7
     LevelCost(5)=7
     LevelCost(6)=9
     LevelCost(7)=9
     LevelCost(8)=9
     LevelCost(9)=9
     LevelCost(10)=9
     RequiredAbilities(0)=Class'DEKRPG999X.AbilityLoadedCraftsman'
     AbilityName="Enhanced Artifacts"
     Description="Each level of this ability will decrease the adrenaline cost of all your artifacts, except sphere artifacts and enchanter artifacts, by 10%, until level 5.|After level 5, each level will decrease the adrenaline cost of your sphere artifacts by 10%.||You will need to have Loaded Craftsman maxed before purchasing this ability.|Cost(per level): 7,7,7,7,7,9,9,9,9,9"
     MaxLevel=10
}
