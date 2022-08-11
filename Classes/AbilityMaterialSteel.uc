class AbilityMaterialSteel extends AbilityMaterialLowRarity
	config(UT2004RPG)
	abstract;
	
var config float LevMultiplier;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local JumpHeightMaxMaterialInv Inv;
	local RPGStatsInv StatsInv;
	local int x;
	local bool bHasBaseAbility;
	
	if (Other != None)
	{
		//We want to increase the max jump height for this player as a bonus.
		//We can do this easily if the player does not have the Power Jump ability
		//But if they do have Power Jump, we will spawn an inventory item on the Pawn, tell it to wait a few seconds, and then apply the boost to the max jump height
		//This is because after a player ghosts, abilities are called again in the order they are purchased. It is possible that this ability gets called before Power Jump (which sets a max jump height, not increase it, thereby negating this bonus)
		
		//First, check if the player has the Power Jump ability
		bHasBaseAbility = False;
		StatsInv = RPGStatsInv(Other.FindInventoryType(Class'RPGStatsInv'));

		for (x = 0; StatsInv != None && x < StatsInv.Data.Abilities.length; x++)
		{
			if (StatsInv.Data.Abilities[x] == Class'UT2004RPG.AbilityJumpZ')
			{
				bHasBaseAbility = True;
				break;
			}
		}
		
		if (bHasBaseAbility)	//This Pawn has Power Jump. So we need to create a special inventory which will wait a few seconds before giving the additional boost to the jump height max.
		{
			Inv = JumpHeightMaxMaterialInv(Other.FindInventoryType(Class'JumpHeightMaxMaterialInv'));
			if (Inv == None)
			{
				Inv = Other.Spawn(Class'JumpHeightMaxMaterialInv');
				Inv.Boost = 1 + AbilityLevel*default.LevMultiplier;
				Inv.GiveTo(Other);
			}
			else	//After ghosting, all abilities get called again. Since Power Jump "sets" values and overrides material bonuses, we need to call Timer again
			{
				Inv.Boost = 1 + AbilityLevel*default.LevMultiplier;
				Inv.SetTimer(5, False);
			}
		}
		else	//This Pawn does not have Power Jump. We can apply the bonus directly
		{
			if (Other != None)
				Other.JumpZ = Other.default.JumpZ * (1 + AbilityLevel*default.LevMultiplier);
		}
	}
}

defaultproperties
{
	 LevMultiplier=0.0010000000
     AbilityName="Steel*"
     Description="A strong and sturdy material commonly found in many structures. Increases your cumulative jump height by 0.1% per level.||Rarity: Low*||This material can be found by making kills, completing solo and team missions, using Loot magic modifier, winning the game, or defeating bosses.||You must be level 60 to purchase this.||Cost (per level): 3"
	 MaxLevel=50
}
