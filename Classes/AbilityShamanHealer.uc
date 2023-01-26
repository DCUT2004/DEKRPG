class AbilityShamanHealer extends AbilityNiche
	config(UT2004RPG);
	
static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	local int x;

	for (x = 0; x < Data.Abilities.length; x++)
	{
		if (Data.Abilities[x] == class'AbilityDEKLoadedHealing')
			if (Data.AbilityLevels[x] >= 8)
				return Super.Cost(Data, CurrentLevel);
	}

	return 0;
}

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ShamanInv Inv;

	if (Other.IsA('Monster'))
		return;

	Inv = ShamanInv(Other.FindInventoryType(Class'ShamanInv'));
	if (Inv == None)
	{
		Inv = Other.Spawn(Class'ShamanInv');
		Inv.GiveTo(Other);
	}
}

defaultproperties
{
     ExcludingAbilities(0)=Class'DEKRPG999X.AbilityGuardianHealer'
     AbilityName="Niche: Shaman"
     Description="Sacrifices 10 health per teammate every 2 seconds for all teammates, as long as your health is beyond max. Each teammate continues to heal with this ability to +200 beyond their max health.|You must be level 180 and have at least level 8 of Loaded Healing before buying this niche. You can not be in more than one niche at a time.||Cost(per level): 50"
     StartingCost=50
     MaxLevel=1
}
