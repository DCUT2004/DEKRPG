class AbilityMaterialLumber extends AbilityMaterial
	config(UT2004RPG)
	abstract;
	
var config float LevMultiplier;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local AirSpeedMaxMaterialInv Inv;
	local RPGStatsInv StatsInv;
	local int x;
	local bool bHasBaseAbility;
	
	if (Other != None)
	{
		//We want to increase the max air speed for this player as a bonus.
		//We can do this easily if the player does not have the Quickfoot ability
		//But if they do have Quickfoot, we will spawn an inventory item on the Pawn, tell it to wait a few seconds, and then apply the boost to the max air speed
		//This is because after a player ghosts, abilities are called again in the order they are purchased. It is possible that this ability gets called before Quickfoot (which sets a max air speed, not increase it, thereby negating this bonus)
		
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
			Inv = AirSpeedMaxMaterialInv(Other.FindInventoryType(Class'AirSpeedMaxMaterialInv'));
			if (Inv == None)
			{
				Inv = Other.Spawn(Class'AirSpeedMaxMaterialInv');
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
				Other.AirSpeed = Other.default.AirSpeed * (1 + AbilityLevel*default.LevMultiplier);
		}
	}
}

defaultproperties
{
	 LevMultiplier=0.0010000000000
     AbilityName="Lumber*"
     Description="Good wood! Increases your cumulative air speed by 0.1% per level.||Rarity: Low*||This material can be found by making kills, completing solo and team missions, using Loot magic modifier, winning the game, or defeating bosses.||You must be level 90 to purchase this.||Cost (per level): 3"
	 MaxLevel=50
}
