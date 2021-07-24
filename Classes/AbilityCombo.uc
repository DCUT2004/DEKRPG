class AbilityCombo extends AbilityUnlockable
	config(UT2004RPG)
	abstract;

var config float BaseMultiplier, MultiplierAddPerStep, MultiplierStep;
var config int BaseDamage, DamageStep, DamageAddPerStep;
var config float BaseLifespan, LifespanStep, LifespanAddPerStep;
var config bool Dispellable, All, Single;
var config int MaxCombos;

static simulated function int GetCost(RPGPlayerDataObject Data, int CurrentLevel)
{
	local int x;
	local int y;
	local int ab;
	local int ComboCount;
	local int threshold;
	
	if (Data == None)
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
		
	//Check for max allowable combos
	ComboCount = 0;
	for (ab = 0; ab < Data.Abilities.Length; ab++)
	{
		if (ClassIsChildOf(Data.Abilities[ab], class'AbilityCombo'))
			ComboCount++;
		if (ComboCount >= default.MaxCombos)
			break;
	}
	if (ComboCount >= default.MaxCombos && CurrentLevel <= 0)	//We counted 3 combos, so if CurrentLevel is <= 0, means this player has reached their MaxCombos capacity and cannot buy
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
		
	// check for excluding abilities
	for (ab = 0; ab < default.ExcludingAbilities.length; ab++)
		for (x = 0; x < Data.Abilities.length; x++)
			if (Data.Abilities[x] == default.ExcludingAbilities[ab])
				return 0;
				
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
	 MaxCombos=3
     AbilityName="Combo Ability"
	 MinPlayerLevel=90
}
