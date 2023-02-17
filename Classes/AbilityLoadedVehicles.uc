class AbilityLoadedVehicles extends CostRPGAbility
	config(UT2004RPG)
	abstract;

var config Array<string> IncludeVehicleGametypes;

struct VehicleConfig
{
    var int Level;
	Var String FriendlyName;
	var Class<Pawn> Vehicle;
	var int Points;
	var int StartHealth;
	var int NormalHealth;
	var int RecoveryPeriod;
};
var config Array<VehicleConfig> VehicleConfigs;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local int i;
	local LoadedInv LoadedInv;
	Local RPGArtifact Artifact;
	local bool bAddVehicles;
	Local int StartLevel;

	LoadedInv = LoadedInv(Other.FindInventoryType(class'LoadedInv'));
	if(LoadedInv != None)
	{
		if(LoadedInv.bGotLoadedEngineer)
		{
			if (LoadedInv.LEVAbilityLevel == AbilityLevel)
				return;
			StartLevel = LoadedInv.LEVAbilityLevel+1; //only giving artifacts for this level.
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

	LoadedInv.LEVAbilityLevel = AbilityLevel;

	// see if we need to add vehicles as well
	bAddVehicles = false;
	for(i = 0; i < Default.IncludeVehicleGametypes.length; i++)
	{
		if (caps(Default.IncludeVehicleGametypes[i]) == "ALL"
		 || (Other.Level.Game != None && instr(caps(Other.Level.Game.GameName), caps(Default.IncludeVehicleGametypes[i])) > -1))
			bAddVehicles = true;
	}
	
	// now we are going to give them the correct artifacts. If just going up by one level, then we could just add on the new ones, but then the order of artifacts gets screwed
	if (bAddVehicles)
	{
		for(i = 0; i < Default.VehicleConfigs.length; i++)
		{
    		if(Default.VehicleConfigs[i].Vehicle != None) //make sure the object is sane.
    		{
    			if (Default.VehicleConfigs[i].Level >= StartLevel && Default.VehicleConfigs[i].Level <= AbilityLevel)
    			{
    				Artifact = Other.spawn(class'DruidVehicleSummon', Other,,, rot(0,0,0));
    				if(Artifact == None)
    					continue; // wow.
    				DruidvehicleSummon(Artifact).Setup(Default.VehicleConfigs[i].FriendlyName, Default.VehicleConfigs[i].Vehicle, Default.VehicleConfigs[i].Points, Default.VehicleConfigs[i].StartHealth, Default.VehicleConfigs[i].NormalHealth, Default.VehicleConfigs[i].RecoveryPeriod);
    				Artifact.GiveTo(Other);
    			}
    		}
		}
	}

	// ok,lets add the kill artifacts
	if (bAddVehicles && Default.VehicleConfigs.length > 0 && StartLevel <= 1)
	{
		Artifact = Other.spawn(class'ArtifactKillAllVehicles', Other,,, rot(0,0,0));
		Artifact.GiveTo(Other);
	}

// I'm guessing that NextItem is here to ensure players don't start with
// no item selected.  So the if should stop weird artifact scrambles.
	if(Other.SelectedItem == None)
		Other.NextItem();
}

defaultproperties
{
     IncludeVehicleGametypes(0)="All"
     AbilityName="Vehicle Builder"
     Description="Learn vehicles to summon. At each level, you can summon better items.||Cost (per level): 3,4,5,6,7,8,9,10,11,12,13,14,15,16,17..."
     StartingCost=3
     CostAddPerLevel=1
     MaxLevel=20
}
