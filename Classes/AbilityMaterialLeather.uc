class AbilityMaterialLeather extends AbilityMaterial
	config(UT2004RPG)
	abstract;
	
var config float LevMultiplier;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local DodgeSpeedMaxMaterialInv Inv;
	local RPGStatsInv StatsInv;
	local int x;
	local bool bHasBaseAbility;
	
	if (Other != None)
	{
		//We want to increase the max dodge speed for this player as a bonus.
		//We can do this easily if the player does not have the Nimble niche ability
		//But if they do have Nimble, we will spawn an inventory item on the Pawn, tell it to wait a few seconds, and then apply the boost to the max dodge speed
		//This is because after a player ghosts, abilities are called again in the order they are purchased. It is possible that this ability gets called before Nimble (which sets a max dodge speed, not increase it, thereby negating this bonus)
		
		//First, check if the player has the Quickfoot ability
		bHasBaseAbility = False;
		StatsInv = RPGStatsInv(Other.FindInventoryType(Class'RPGStatsInv'));

		for (x = 0; StatsInv != None && x < StatsInv.Data.Abilities.length; x++)
		{
			if (StatsInv.Data.Abilities[x] == Class'DEKRPG208AH.AbilityNimbleBerserker')
			{
				bHasBaseAbility = True;
				break;
			}
		}
		
		if (bHasBaseAbility)	//This Pawn has Quickfoot. So we need to create a special inventory which will wait a few seconds before giving the additional boost to the speed max.
		{
			Inv = DodgeSpeedMaxMaterialInv(Other.FindInventoryType(Class'DodgeSpeedMaxMaterialInv'));
			if (Inv == None)
			{
				Inv = Other.Spawn(Class'DodgeSpeedMaxMaterialInv');
				Inv.Boost = 1 + AbilityLevel*default.LevMultiplier;
				Inv.GiveTo(Other);
			}
			else	//After ghosting, all abilities get called again. Since Quickfoot "sets" values and overrides material bonuses, we need to call Timer again
			{
				Inv.Boost = 1 + AbilityLevel*default.LevMultiplier;
				Inv.SetTimer(5, False);
			}
		}
		else	//This Pawn does not have Nimble. We can apply the bonus directly
		{
			if (xPawn(Other) != None && xPawn(Other).Role == ROLE_Authority)
			{
				xPawn(Other).DodgeSpeedFactor = xPawn(Other).default.DodgeSpeedFactor * (1 + AbilityLevel*default.LevMultiplier);
				xPawn(Other).DodgeSpeedZ = xPawn(Other).default.DodgeSpeedZ * (1.0 + default.LevMultiplier*AbilityLevel);
			}
		}
	}
}

defaultproperties
{
	 LevMultiplier=0.00200000
     AbilityName="Fine Leather**"
     Description="Fine leather from many monsters. Increases your cumulative dodge speed 0.2% per level.||Rarity: Medium**||This material can be found by making kills, completing solo and team missions, using Loot magic modifier, winning the game, or defeating bosses.||You must be level 90 to purchase this.||Cost (per level): 3"
	 MaxLevel=50
}
