class AbilityLoadedNodes extends CostRPGAbility
	config(UT2004RPG)
	abstract;

struct NodeConfig
{
    var int Level;
	Var String FriendlyName;
	var Class<Pawn> Node;
	var int Points;
	var int StartHealth;
	var int NormalHealth;
	var int RecoveryPeriod;
};
var config Array<NodeConfig> NodeConfigs;

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
			if (LoadedInv.LENAbilityLevel == AbilityLevel)
				return;
			StartLevel = LoadedInv.LENAbilityLevel + 1; //only giving artifacts for this level.
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

	LoadedInv.LENAbilityLevel = AbilityLevel;

	// now we are going to give them the correct artifacts. If just going up by one level, then we just add on the new ones, 
	for(i = 0; i < Default.NodeConfigs.length; i++)
	{
		if(Default.NodeConfigs[i].Node != None) //make sure the object is sane.
		{
			if (Default.NodeConfigs[i].Level >= StartLevel && Default.NodeConfigs[i].Level <= AbilityLevel)
			{
				Artifact = Other.spawn(class'DruidNodeSummon', Other,,, rot(0,0,0));
				if(Artifact == None)
					continue; // wow.
				DruidNodeSummon(Artifact).Setup(Default.NodeConfigs[i].FriendlyName, Default.NodeConfigs[i].Node, Default.NodeConfigs[i].Points, Default.NodeConfigs[i].StartHealth, Default.NodeConfigs[i].NormalHealth, Default.NodeConfigs[i].RecoveryPeriod);
				Artifact.GiveTo(Other);
			}
		}
	}

	if (Default.NodeConfigs.length > 0 && StartLevel <= 1)
	{
		Artifact = Other.spawn(class'ArtifactKillAllNodes', Other,,, rot(0,0,0));
		Artifact.GiveTo(Other);
	}

// I'm guessing that NextItem is here to ensure players don't start with
// no item selected.  So the if should stop weird artifact scrambles.
	if(Other.SelectedItem == None)
		Other.NextItem();
}

defaultproperties
{
     AbilityName="Node Builder"
     Description="Learn to summon nodes to gather resources. At each level, you can summon better items.||Cost (per level): 3,4,5,6,7,..."
     StartingCost=3
     CostAddPerLevel=1
     MaxLevel=20
}
