class AbilityMaterialGloves extends AbilityMaterial
	config(UT2004RPG)
	abstract;
	
var config float LevMultiplier;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ShieldMaxMaterialInv Inv;
	local RPGStatsInv StatsInv;
	local int x;
	local bool bHasBaseAbility;
	
	if (Other != None)
	{
		//We want to increase the max shield for this player as a bonus.
		//We can do this easily if the player does not have the Shields Up ability
		//But if they do have Shields Up, we will spawn an inventory item on the Pawn, tell it to wait a few seconds, and then apply the boost to the max shield
		//This is because after a player ghosts, abilities are called again in the order they are purchased. It is possible that this ability gets called before Shields Up (which sets a max shield, not increase it, thereby negating this bonus)
		
		//First, check if the player has the Shields Up ability
		bHasBaseAbility = False;
		StatsInv = RPGStatsInv(Other.FindInventoryType(Class'RPGStatsInv'));

		for (x = 0; StatsInv != None && x < StatsInv.Data.Abilities.length; x++)
		{
			if (StatsInv.Data.Abilities[x] == Class'UT2004RPG.AbilityShieldStrength')
			{
				bHasBaseAbility = True;
				break;
			}
		}
		
		
		if (bHasBaseAbility)	//This Pawn has Shields Up. So we need to create a special inventory which will wait a few seconds before giving the additional boost to the shield max.
		{
			Inv = ShieldMaxMaterialInv(Other.FindInventoryType(Class'ShieldMaxMaterialInv'));
			if (Inv == None)
			{
				Inv = Other.Spawn(Class'ShieldMaxMaterialInv');
				Inv.Boost = 1 + AbilityLevel*default.LevMultiplier;
				Inv.GiveTo(Other);
			}
			else	//After ghosting, all abilities get called again. Since Shields Up "sets" values and overrides material bonuses, we need to call Timer again
			{
				Inv.Boost = 1 + AbilityLevel*default.LevMultiplier;
				Inv.SetTimer(5, False);
			}
		}
		else	//This Pawn does not have Shields Up. We can apply the bonus as if it were Shields Up
		{
			if (xPawn(Other) != None)
				xPawn(Other).ShieldStrengthMax = xPawn(Other).default.ShieldStrengthMax * (1 + AbilityLevel*default.LevMultiplier);
		}
	}
}

defaultproperties
{
	 LevMultiplier=0.00100000
     AbilityName="Gloves*"
     Description="Gloves to protect the hand. Increases your max shield by 0.1% per level.||Rarity: Low*||This material can be found by making kills, completing solo and team missions, using Loot magic modifier, winning the game, or defeating bosses.||You must be level 90 to purchase this.||Cost (per level): 3"
	 MaxLevel=50
}
