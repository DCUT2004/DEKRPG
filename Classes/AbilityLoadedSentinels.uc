class AbilityLoadedSentinels extends CostRPGAbility
	config(UT2004RPG)
	abstract;

struct SentinelConfig
{
    var int Level;
	Var String FriendlyName;
	var Class<Pawn> Sentinel;
	var int Points;
	var int StartHealth;
	var int NormalHealth;
	var int RecoveryPeriod;
};
var config Array<SentinelConfig> SentinelConfigs;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local int i;
	local LoadedInv LoadedInv;
	Local RPGArtifact Artifact;
	Local int StartLevel;

	LoadedInv = LoadedInv(Other.FindInventoryType(class'LoadedInv'));
	if(LoadedInv != None)
	{
		if(LoadedInv.bGotLoadedEngineer)
		{
			if (LoadedInv.LESAbilityLevel == AbilityLevel)
				return;
			StartLevel = LoadedInv.LESAbilityLevel + 1; //only giving artifacts for this level.
		}
	}
	else
	{
		LoadedInv = Other.spawn(class'LoadedInv');
		LoadedInv.giveTo(Other);
		StartLevel = 1; 	//give all artifacts up to this level.
	}

	if(LoadedInv == None)
		return;

	LoadedInv.LESAbilityLevel = AbilityLevel;

	// now we are going to give them the correct artifacts. If just going up by one level, then we just add on the new ones, 
	for(i = 0; i < Default.SentinelConfigs.length; i++)
	{
		if(Default.SentinelConfigs[i].Sentinel != None) //make sure the object is sane.
		{
			if (Default.SentinelConfigs[i].Level >= StartLevel && Default.SentinelConfigs[i].Level <= AbilityLevel)
			{
				Artifact = Other.spawn(class'DruidSentinelSummon', Other,,, rot(0,0,0));
				if(Artifact == None)
					continue; // wow.
				DruidSentinelSummon(Artifact).Setup(Default.SentinelConfigs[i].FriendlyName, Default.SentinelConfigs[i].Sentinel, Default.SentinelConfigs[i].Points, Default.SentinelConfigs[i].StartHealth, Default.SentinelConfigs[i].NormalHealth, Default.SentinelConfigs[i].RecoveryPeriod);
				Artifact.GiveTo(Other);
			}
		}
	}

// I'm guessing that NextItem is here to ensure players don't start with
// no item selected.  So the if should stop weird artifact scrambles.
	if(Other.SelectedItem == None)
		Other.NextItem();
}

defaultproperties
{
     AbilityName="Sentinel Builder"
     Description="Learn sentinels to summon. At each level, you can summon better items.||Cost (per level): 3,4,5,6,7,..."
     StartingCost=3
     CostAddPerLevel=1
     MaxLevel=20
}
