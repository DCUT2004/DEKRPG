class AbilityHordeSummoner extends AbilityNiche
	abstract;
	
var config float AdrenalineUsage;

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local MonsterPointsInv Inv;
	local ArtifactHealingBlast AHB;
	local ArtifactSphereHealing ASH;
	local int x, MonsterPointLevel;
	local RPGStatsInv StatsInv;

	Inv = MonsterPointsInv(Other.FindInventoryType(class'MonsterPointsInv'));
	
	if (Inv == None)
		return;

	//Increase monster points
	MonsterPointLevel = 0;
	StatsInv = RPGStatsInv(Other.FindInventoryType(class'RPGStatsInv'));
	for (x = 0; StatsInv != None && x < StatsInv.Data.Abilities.length; x++){
		if (StatsInv.Data.Abilities[x] == class'AbilityMonsterPoints'){
			MonsterPointLevel = StatsInv.Data.AbilityLevels[x];
			break;
		}
	}
	if (MonsterPointLevel == 0)
		return;
	Inv.TotalMonsterPoints = MonsterPointLevel + 5;
	
	//Increase max monsters
	Inv.MaxMonsters = Inv.default.MaxMonsters + 1;
	
	AHB = ArtifactHealingBlast(Other.FindInventoryType(class'ArtifactHealingBlast'));
	ASH = ArtifactSphereHealing(Other.FindInventoryType(class'ArtifactSphereHealing'));
		
	if (AHB != None)
		AHB.EnhanceAdrenalineRequired(default.AdrenalineUsage * AHB.default.AdrenalineRequired);
	if (ASH != None)
		ASH.EnhanceAdrenalineRequired(default.AdrenalineUsage * ASH.default.AdrenalineRequired);

}

defaultproperties
{
     AdrenalineUsage=1.500000
     ExcludingAbilities(0)=Class'DEKRPG999X.AbilityBeastSummoner'
     ExcludingAbilities(1)=Class'DEKRPG999X.AbilityMindControlSummoner'
     RequiredAbilities(0)=Class'DEKRPG999X.AbilityMonsterPoints'
     AbilityName="Niche: Horde"
     Description="Increases your maximum Monster Points by 5, and increases your maximum summonable pets by 1. However, the cost of your healing artifacts also increases.|You must be level 180 and have at least level 1 of Monster Points before buying this niche. You can not be in more than one niche at a same time.||Cost(per level): 50"
     StartingCost=50
     MaxLevel=1
}
