class AbilityCombo extends AbilityUnlockable
	config(UT2004RPG)
	abstract;

var config float BaseMultiplier, MultiplierAddPerStep, MultiplierStep;	//How strong the effect of this combo is
var config int BaseDamage, DamageStep, DamageAddPerStep;				//How much damage this combo does, if applicable
var config float BaseLifespan, LifespanStep, LifespanAddPerStep;		//How long this combo will last
var config bool Dispellable, All, Single;								//How many targets this combo will affect
var byte ComboType;														//0 = Buff, 1 = Ailment, 2 = Offensive, 3 = Special
var config int SameTypeLimits[4];										//Specifies how many combos of the same type can be allowed, for each type (same indexing as ComboType)

static simulated function int GetCost(RPGPlayerDataObject Data, int CurrentLevel)
{
	local int x;
	local int y;
	local int ab;
	local int ComboCount;
	local int threshold;
	local int MatchingComboCount;
	local class <AbilityCombo> ComboClass;
	
	if (Data == None)
		return 0;
		
	//Safety check, since ComboType will be used to index a fixed array
	if (default.ComboType < 0 || default.ComboType > 3)
		return 0;
	
	// check the stats
	if (Data.WeaponSpeed < default.MinWeaponSpeed + (CurrentLevel * default.WeaponSpeedStep))
		return 0;
	if (Data.HealthBonus < default.MinHealthBonus + (CurrentLevel * default.HealthBonusStep))
		return 0;
	if (Data.AdrenalineMax < default.MinAdrenalineMax + (CurrentLevel * default.AdrenalineMaxStep))
		return 0;
	if (Data.Attack < default.MinDB + (CurrentLevel * default.DBStep))
		return 0;
	if (Data.Defense < default.MinDR + (CurrentLevel * default.DRStep))
		return 0;
	if (Data.AmmoMax < default.MinAmmo + (CurrentLevel * default.AmmoStep))
		return 0;
	
	// now check the player level
	if(Data.Level < (default.MinPlayerLevel + CurrentLevel*default.PlayerLevelStep))
		return 0;

	if (default.PlayerLevelReqd.length > CurrentLevel+1)		// since zero based need +1
		if (default.PlayerLevelReqd[CurrentLevel+1] > Data.Level)
			return 0;

	// check if already maxed
	if (CurrentLevel >= default.MaxLevel)
		return 0;
	
	// check that this player does not have more of the same type of combo allowed (e.g. 2 Buffs, cannot buy a 3rd Buff)
	MatchingComboCount = 0;
	for (ab = 0; ab < Data.Abilities.Length; ab++)
	{
		if (ClassIsChildOf(Data.Abilities[ab], class'AbilityCombo') && CurrentLevel == 0)
		{
			ComboClass = Class<AbilityCombo>(Data.Abilities[ab]);
			if (ComboClass.default.ComboType == default.ComboType)	//Player has a combo of the same type
			{
				MatchingComboCount++;
				if (MatchingComboCount >= default.SameTypeLimits[default.ComboType])	//Player already has reached the max allowed number of combos of this type
					return 0;
			}
		}
	}
				
	// check for required materials
	for (ab = 0; ab < default.Materials.length; ab++)
	{
		//We are only interested in checking the Materials at the level we want to purchase
		if (ab < CurrentLevel)
			continue;
		
		//If we have all the requisite materials according to the previous iteration of this loop, stop checking for higher level materials
		if (ab > CurrentLevel)
			break;
		
		threshold = 0;
		//Now loop through the RequiredMaterials list
		for (x = 0; x < default.Materials[ab].RequiredMaterials.Length; x++)
		{
			//For each required material, check our current abilities to see if we have the match
			for (y = 0; y < Data.Abilities.Length; y++)
			{
				if (Data.Abilities[y] == default.Materials[ab].RequiredMaterials[x] && Data.AbilityLevels[y] >= default.Materials[ab].RequiredMaterialLevels[x])
				{
					//We have a requisite material. Up the threshold, get out of our current abilities loop and check for the next material
					threshold++;
					break;
				}
			}
		}
		//If our threshold is lower than the number of materials required, return 0 so player can't purchase
		if (threshold < default.Materials[ab].RequiredMaterials.Length)
			return 0;
	}

	// wow. Can buy
	if (default.LevelCost.length <= CurrentLevel)
		return default.StartingCost + default.CostAddPerLevel * CurrentLevel;
	else
		return default.LevelCost[CurrentLevel+1];
}

defaultproperties
{
	SameTypeLimits(0)=1
	SameTypeLimits(1)=1
	SameTypeLimits(2)=1
	SameTypeLimits(3)=1
	AbilityName="Combo Ability"
	MinPlayerLevel=90
}
