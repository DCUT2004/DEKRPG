class AbilityLoadedTurrets extends CostRPGAbility
	config(UT2004RPG)
	abstract;

struct TurretConfig
{
    var int Level;
	var string SubClass;
	Var String FriendlyName;
	var Class<Pawn> Turret;
	var int Points;
	var int StartHealth;
	var int NormalHealth;
	var int RecoveryPeriod;
};
var config Array<TurretConfig> TurretConfigs;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local int i;
	local LoadedInv LoadedInv;
	Local RPGArtifact Artifact;
	Local int StartLevel;
	local EngineerPointsInv EInv;
	local RPGStatsInv StatsInv;
    local string SubClassName;

	EInv = class'AbilityLoadedEngineer'.static.GetEngInv(Other);
    if (EInv != None)
    {
        if (AbilityLevel >= 5)
            EInv.HasAutoTurrets = true;
        else
            EInv.HasAutoTurrets = false;
    }

	LoadedInv = LoadedInv(Other.FindInventoryType(class'LoadedInv'));
	if(LoadedInv != None)
	{
		if(LoadedInv.bGotLoadedEngineer)
		{
			if (LoadedInv.LETAbilityLevel == AbilityLevel)
				return;
			StartLevel = LoadedInv.LETAbilityLevel + 1; //only giving artifacts for this level.
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

	LoadedInv.LETAbilityLevel = AbilityLevel;

	StatsInv = RPGStatsInv(Other.FindInventoryType(class'RPGStatsInv'));
    SubClassName = class'DruidArtifactLoaded'.static.GetSubClassName(StatsInv.Data);
    if (SubClassName == "")
        return;

	// now we are going to give them the correct artifacts. If just going up by one level, then we just add on the new ones, 
	for(i = 0; i < Default.TurretConfigs.length; i++)
	{
		if(Default.TurretConfigs[i].Turret != None) //make sure the object is sane.
		{
			if (Default.TurretConfigs[i].Level >= StartLevel && Default.TurretConfigs[i].Level <= AbilityLevel && 
                (default.TurretConfigs[i].SubClass == "" || default.TurretConfigs[i].SubClass == SubClassName))
			{
				Artifact = Other.spawn(class'DruidTurretSummon', Other,,, rot(0,0,0));
				if(Artifact == None)
					continue; // wow.
				DruidTurretSummon(Artifact).Setup(Default.TurretConfigs[i].FriendlyName, Default.TurretConfigs[i].Turret, Default.TurretConfigs[i].Points, Default.TurretConfigs[i].StartHealth, Default.TurretConfigs[i].NormalHealth, Default.TurretConfigs[i].RecoveryPeriod);
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
     AbilityName="Turret Builder"
     Description="Learn turrets to summon. At each level, you can summon better items. |Cost (per level): 3,4,5,6,7..."
     StartingCost=3
     CostAddPerLevel=1
     MaxLevel=20
}
