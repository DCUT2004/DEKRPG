class AbilityMaterialTarydiumShards extends AbilityMaterialLowRarity
	config(UT2004RPG)
	abstract;
	
var config float LevMultiplier;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local SwimSpeedMaxMaterialInv Inv;
	local RPGStatsInv StatsInv;
	local int x;
	local bool bHasBaseAbility;
	
	if (Other != None)
	{
		//We want to increase the max swim speed for this player as a bonus.
		//We can do this easily if the player does not have the Quickfoot ability
		//But if they do have Quickfoot, we will spawn an inventory item on the Pawn, tell it to wait a few seconds, and then apply the boost to the max swim speed
		//This is because after a player ghosts, abilities are called again in the order they are purchased. It is possible that this ability gets called before Quickfoot (which sets a max swim speed, not increase it, thereby negating this bonus)
		
		//First, check if the player has the Quickfoot ability
		bHasBaseAbility = False;
		StatsInv = RPGStatsInv(Other.FindInventoryType(Class'RPGStatsInv'));

		for (x = 0; StatsInv != None && x < StatsInv.Data.Abilities.length; x++)
		{
			if (StatsInv.Data.Abilities[x] == Class'UT2004RPG.AbilitySpeed')
			{
				bHasBaseAbility = True;
				break;
			}
		}
		
		if (bHasBaseAbility)	//This Pawn has Quickfoot. So we need to create a special inventory which will wait a few seconds before giving the additional boost to the speed max.
		{
			Inv = SwimSpeedMaxMaterialInv(Other.FindInventoryType(Class'SwimSpeedMaxMaterialInv'));
			if (Inv == None)
			{
				Inv = Other.Spawn(Class'SwimSpeedMaxMaterialInv');
				Inv.Boost = 1 + AbilityLevel*default.LevMultiplier;
				Inv.GiveTo(Other);
			}
			else	//After ghosting, all abilities get called again. Since Quickfoot "sets" values and overrides material bonuses, we need to call Timer again
			{
				Inv.Boost = 1 + AbilityLevel*default.LevMultiplier;
				Inv.SetTimer(5, False);
			}
		}
		else	//This Pawn does not have Quickfoot. We can apply the bonus as if it were Quickfoot
		{
			if (Other != None)
				Other.WaterSpeed = Other.default.WaterSpeed * (1 + AbilityLevel*default.LevMultiplier);
		}
	}
}
defaultproperties
{
	 LevMultiplier=0.0010000
     AbilityName="Tarydium Shards*"
     Description="Precious tarydium shards that are valuable across the galaxy. Increases your cumulative swim speed by 0.1% per level.||Rarity: Low*||This material can be found by making kills, completing solo and team missions, using Loot magic modifier, winning the game, or defeating bosses.||You must be level 60 to purchase this.||Cost (per level): 3"
	 MaxLevel=50
}
