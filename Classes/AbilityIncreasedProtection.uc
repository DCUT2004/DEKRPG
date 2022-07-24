class AbilityIncreasedProtection extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

var config float ProtectionMultiplier;
var config float SpeedMultiplier;
var config float CombatBootsBonus;

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if(bOwnedByInstigator)
		return; //if the instigator is doing the damage, ignore this.
	if(Damage > 0)
	{
		Damage *= (abs(1-(AbilityLevel * default.ProtectionMultiplier)));
		if (Damage == 0)
			Damage = 1;
		Momentum = vect(0,0,0);
	}
}

// need to reduce movement speed.
static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	class'AbilityIncreasedProtection'.static.quickfoot(0, Other);	// let this deal with it
}

static function ModifySpeedPawn(Pawn Other, int AbilityLevel)
{
	if(AbilityLevel > 0)
	{
		Other.GroundSpeed = Other.default.GroundSpeed * (1.0 + default.SpeedMultiplier * float(AbilityLevel));
		Other.WaterSpeed = Other.default.WaterSpeed * (1.0 + default.SpeedMultiplier * float(AbilityLevel));
		Other.AirSpeed = Other.default.AirSpeed * (1.0 + default.SpeedMultiplier * float(AbilityLevel));
	}
	else if(AbilityLevel < 0)
	{
		Other.GroundSpeed = Other.default.GroundSpeed / (1.0 + default.SpeedMultiplier * abs(float(AbilityLevel)));
		Other.WaterSpeed = Other.default.WaterSpeed / (1.0 + default.SpeedMultiplier * abs(float(AbilityLevel)));
		Other.AirSpeed = Other.default.AirSpeed / (1.0 + default.SpeedMultiplier * abs(float(AbilityLevel)));
	}
	else
	{
		Other.GroundSpeed = Other.default.GroundSpeed;
		Other.WaterSpeed = Other.default.WaterSpeed;
		Other.AirSpeed = Other.default.AirSpeed;
	}
}

static function quickfoot(int localModifier, Pawn PawnOwner)
{
	local int x;
	local bool found;
	local RPGStatsInv StatsInv;

	StatsInv = RPGStatsInv(PawnOwner.FindInventoryType(class'RPGStatsInv'));
	found = false;

	for (x = 0; StatsInv != None && x < StatsInv.Data.Abilities.length; x++)
		if (StatsInv.Data.Abilities[x] == class'AbilitySpeed')
		{
			found = true;
			break;
		}

	if(!found)
		ModifySpeedPawn(PawnOwner, localModifier);

	else
		ModifySpeedPawn(PawnOwner, StatsInv.Data.AbilityLevels[x] + localModifier);
		
	//Check if the player has Combat Boots bonus
	found = false;
	for (x = 0;  StatsInv != None && x < StatsInv.Data.Abilities.length; x++)
	{
		if (StatsInv.Data.Abilities[x] == Class'AbilityMaterialCombatBoots')
		{
			found = true;
			break;
		}
	}
	if (found)
		PawnOwner.GroundSpeed *= 1 + StatsInv.Data.AbilityLevels[x]*default.CombatBootsBonus;
	
	// now check for having the Tank IncreasingProtection ability
	found = false;
	for (x = 0; StatsInv != None && x < StatsInv.Data.Abilities.length; x++)
		if (StatsInv.Data.Abilities[x] == class'AbilityIncreasedProtection')
		{
			found = true;
			break;
		}

	if(found)
		class'AbilityIncreasedProtection'.static.SlowDown(PawnOwner, StatsInv.Data.AbilityLevels[x]);
}

static simulated function SlowDown(Pawn Other, int AbilityLevel)
{	// override everything else and set speed based on default
	Other.GroundSpeed = Other.default.GroundSpeed * (1.0 - (default.SpeedMultiplier * float(AbilityLevel)));
	Other.WaterSpeed = Other.default.WaterSpeed * (1.0 - (default.SpeedMultiplier * float(AbilityLevel)));
	Other.AirSpeed = Other.default.AirSpeed * (1.0 - (default.SpeedMultiplier * float(AbilityLevel)));
}

defaultproperties
{
	 CombatBootsBonus=0.0010000000
     ProtectionMultiplier=0.050000
     SpeedMultiplier=0.025000
     AbilityName="Increased Damage Protection"
     Description="Increases your cumulative total damage reduction by 5% per level. Does not apply to self damage. However, the extra armor slows you down.|Cost (per level): 10."
     StartingCost=10
     MaxLevel=20
}
