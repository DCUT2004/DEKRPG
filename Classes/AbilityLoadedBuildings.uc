class AbilityLoadedBuildings extends CostRPGAbility
	config(UT2004RPG)
	abstract;

struct BuildingConfig
{
    var int Level;
	Var String FriendlyName;
	var Class<Pawn> Building;
	var int Points;
	var int StartHealth;
	var int NormalHealth;
	var int RecoveryPeriod;
};
var config Array<BuildingConfig> BuildingConfigs;

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
			if (LoadedInv.LEBAbilityLevel == AbilityLevel)
				return;
			StartLevel = LoadedInv.LEBAbilityLevel + 1; //only giving artifacts for this level.
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

	LoadedInv.LEBAbilityLevel = AbilityLevel;

	// now we are going to give them the correct artifacts. If just going up by one level, then we just add on the new ones, 
	for(i = 0; i < Default.BuildingConfigs.length; i++)
	{
		if(Default.BuildingConfigs[i].Building != None) //make sure the object is sane.
		{
			if (Default.BuildingConfigs[i].Level >= StartLevel && Default.BuildingConfigs[i].Level <= AbilityLevel)
			{
				Artifact = Other.spawn(class'DruidBuildingSummon', Other,,, rot(0,0,0));
				if(Artifact == None)
					continue; // wow.
				DruidBuildingSummon(Artifact).Setup(Default.BuildingConfigs[i].FriendlyName, Default.BuildingConfigs[i].Building, Default.BuildingConfigs[i].Points, Default.BuildingConfigs[i].StartHealth, Default.BuildingConfigs[i].NormalHealth, Default.BuildingConfigs[i].RecoveryPeriod);
				Artifact.GiveTo(Other);
			}
		}
	}

    // TODO make sure these kill ones are clustered
	if (Default.BuildingConfigs.length > 0 && StartLevel <= 1)
	{
		Artifact = Other.spawn(class'ArtifactKillAllBuildings', Other,,, rot(0,0,0));
		Artifact.GiveTo(Other);
	}

// I'm guessing that NextItem is here to ensure players don't start with
// no item selected.  So the if should stop weird artifact scrambles.
	if(Other.SelectedItem == None)
		Other.NextItem();
}

defaultproperties
{
     AbilityName="Base Builder"
     Description="Build a base for others. At each level, you can summon better items.||Cost (per level): 3,4,5,6,7,8,9,10,11,12,13,14,15,16,17..."
     StartingCost=3
     CostAddPerLevel=1
     MaxLevel=20
}
