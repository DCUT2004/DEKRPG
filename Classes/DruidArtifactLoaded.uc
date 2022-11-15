class DruidArtifactLoaded extends RPGDeathAbility
	config(UT2004RPG) 
	abstract;

struct ArtifactConfig
{
	var int Level;
	var string SubClass;
	var class<RPGArtifact> Artifact;
	var float Cost;
    var float PerformanceIncrease;
};
var config Array<ArtifactConfig> ArtifactConfigs;

static function string GetSubClassName(RPGPlayerDataObject.RPGPlayerData Data)
{
	local int curSubClasslevel;
    local string curSubClass;
	local class<RPGClass> curClass;
	local int y;

	// first find class and subclass
    curSubClasslevel = -1;
    curSubClass = "";
	curClass = None;
    
	// first lets find the class
	for (y = 0; y < Data.Abilities.length; y++)
    {
		if (ClassIsChildOf(Data.Abilities[y], class'RPGClass'))
		{
			// found the class
			curClass = class<RPGClass>(Data.Abilities[y]);
		}
		else
		if (ClassIsChildOf(Data.Abilities[y], class'SubClass'))
		{
			//found the subclass
			curSubClassLevel = Data.AbilityLevels[y];
		}
    }
	
	// ok now check the subclass text
	if (curClass == None)
    {
        if (class'SubClass'.default.SubClasses.length > 0)
		  curSubClass = class'SubClass'.default.SubClasses[0];		// for no class
    }
	else
	{
		if (curSubClassLevel < 0)
		{
			// if got a class but no sub class, the abilities are configured under the class ability name
			curSubClass = curClass.default.AbilityName;								
		}
        else
        {
            if (class'SubClass'.default.SubClasses.length >= curSubClassLevel)
    		  curSubClass = class'SubClass'.default.SubClasses[curSubClassLevel];
        }
	}

    return curSubClass;
}

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local int x;
	local LoadedInv LoadedInv;
	local RPGStatsInv StatsInv;
    local string SubClassName;

	LoadedInv = LoadedInv(Other.FindInventoryType(class'LoadedInv'));

	if(LoadedInv != None)
	{
		if(LoadedInv.bGotLoadedArtifacts && LoadedInv.LAAbilityLevel == AbilityLevel)
			return;
	}
	else
	{
		LoadedInv = Other.spawn(class'LoadedInv');
		LoadedInv.giveTo(Other);
	}

	if(LoadedInv == None)
		return;

	LoadedInv.bGotLoadedArtifacts = true;
	LoadedInv.LAAbilityLevel = AbilityLevel;
    
	if(AbilityLevel >= 2)
		LoadedInv.ProtectArtifacts = true;
	else
		LoadedInv.ProtectArtifacts = false;
		
	StatsInv = RPGStatsInv(Other.FindInventoryType(class'RPGStatsInv'));
    SubClassName = GetSubClassName(StatsInv.Data);
    
    if (SubClassName == "")
        return;

	for(x = 0; x < default.ArtifactConfigs.length; x++)
        if (default.ArtifactConfigs[x].Level <= AbilityLevel && 
            (default.ArtifactConfigs[x].SubClass == "" || default.ArtifactConfigs[x].SubClass == SubClassName))
			 giveArtifact(other, default.ArtifactConfigs[x].Artifact, default.ArtifactConfigs[x].Cost, default.ArtifactConfigs[x].PerformanceIncrease);

	if(AbilityLevel >= 2)
	{
		// now check if we get the other hybrid artifacts
		for (x = 0; StatsInv != None && x < StatsInv.Data.Abilities.length; x++)
		{
			if (StatsInv.Data.Abilities[x] == class'AbilityShieldHealing')
			{
			    // give them the shieldblast
			    giveArtifact(other, class'ArtifactShieldBlast', class'ArtifactShieldBlast'.default.AdrenalineRequired, 1.0);
			}
			if (StatsInv.Data.Abilities[x] == class'AbilityDEKLoadedHealing' && StatsInv.Data.AbilityLevels[x] >= 2)
			{
			    // give them the healingblast
			    giveArtifact(other, class'ArtifactHealingBlast', class'ArtifactHealingBlast'.default.AdrenalineRequired, 1.0);
			}
		}
	}

// I'm guessing that NextItem is here to ensure players don't start with
// no item selected.  So the if should stop wierd artifact scrambles.
	if(Other.SelectedItem == None)
		Other.NextItem();
}

static function giveArtifact(Pawn other, class<RPGArtifact> ArtifactClass, float Cost, float PerformanceIncrease)
{
	local RPGArtifact Artifact;

	if(Other.IsA('Monster'))
		return;
	if(Other.findInventoryType(ArtifactClass) != None)
		return; //they already have one
		
	Artifact = Other.spawn(ArtifactClass, Other,,, rot(0,0,0));
	Artifact.giveTo(Other);
    
 	if (ClassIsChildOf(Artifact.Class, class'EnhancedRPGArtifact'))
    {
        EnhancedRPGArtifact(Artifact).EnhanceAdrenalineRequired(Cost);
        EnhancedRPGArtifact(Artifact).EnhancePerformance(PerformanceIncrease);
    }
}

static function GenuineDeath(Pawn Killed, Controller Killer, class<DamageType> DamageType, vector HitLocation, int AbilityLevel)
{
	Local Inventory inv;

// If we end up with some wierdness here, it would be because we haven't
// ejected the player.  However, we shouldn't have to worry about that
// any more; it should be handled elsewhere, if needed.
	if(Killed.isA('Vehicle'))
	{
		Killed = Vehicle(Killed).Driver;
	}
// Wierdness - looks like sometimes PD called twice, particularly in VINV?
// Killed can become "None" somewhere along the line.
	if(Killed == None)
	{
		return;
	}

	for (inv=Killed.Inventory ; inv != None ; inv=inv.Inventory)
	{
		if(ClassIsChildOf(inv.class, class'UT2004RPG.RPGArtifact'))
		{
// Important note: *NO* artifact currently in possession will get dropped!
			inv.PickupClass = None;
		}
	}

	return;
}

static function bool OverridePickupQuery(Pawn Other, Pickup item, out byte bAllowPickup, int AbilityLevel)
{
	if (ClassIsChildOf(item.InventoryType, class'EnhancedRPGArtifact'))
	{
		if(Other.findInventoryType(item.InventoryType) != None)
		{
			bAllowPickup = 0;	// not allowed
			return true; 		//they already have one, and ours is probably enhanced already
		}
	}
	return false;		// don't know, so let someone else decide
}

defaultproperties
{
     AbilityName="Loaded Artifacts"
     Description="NOTE: This class is a work in progress. Visit us at discord.gg/8yEYsNc5ym to learn more about future updates and provide suggestions.||When you spawn:|Level 1: You are granted some artifacts.|Level 2: You are granted more artifacts, and breakable artifacts are made unbreakable.|Level 3: You get additional artifacts based on your subclass.|Cost (per level): 8,8,8"
     StartingCost=8
     MaxLevel=3
}
