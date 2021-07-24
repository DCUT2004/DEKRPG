class DruidVampire extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

var config int AdjustableHealingDamage;

static function HandleDamage(int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if(Instigator.Weapon != None && Instigator.Weapon.isA('RW_Rage'))
		return; //no vamp for rage weapons
	LocalHandleDamage(Damage, Injured, Instigator, Momentum, DamageType, bOwnedByInstigator, float(AbilityLevel));
}

static function LocalHandleDamage(int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, Float AbilityLevel)
{
	local float VampHealth;
	local Pawn P;
	local Mission1Inv M1Inv;
	local Mission2Inv M2Inv;
	local Mission3Inv M3Inv;

	if (!bOwnedByInstigator || DamageType == class'DamTypeRetaliation' || Injured == Instigator || Instigator == None)
		return;

	if (Vehicle(Instigator) == None)
	{
		P = Instigator;
	}
	else
	{
		P = Vehicle(Instigator).Driver;
		if (P == None)
		{
			return;
		}
	}

	VampHealth = Damage;
	//if (Monster(Injured) != None && Instigator.HasUDamage())
	//	VampHealth *= 2;					// double damage will not be taken into account until later
		
	if (Injured != None && VampHealth > Injured.Health)
		VampHealth = Injured.Health;		// only get vampire on damage we actually do

	VampHealth *= 0.05 * AbilityLevel;
	if (VampHealth < 1.0 && Damage > 0)
	{
		VampHealth = 1.0;
	}
	
	if (P != None)
	{
		if (P.Health < P.HealthMax + default.AdjustableHealingDamage)
		{
			M1Inv = Mission1Inv(P.FindInventoryType(class'Mission1Inv'));
			M2Inv = Mission2Inv(P.FindInventoryType(class'Mission2Inv'));
			M3Inv = Mission3Inv(P.FindInventoryType(class'Mission3Inv'));
			if (M1Inv != None && !M1Inv.Stopped && M1Inv.DraculaActive)
				M1Inv.MissionCount += VampHealth;
			if (M2Inv != None && !M2Inv.Stopped && M2Inv.DraculaActive)
				M2Inv.MissionCount += VampHealth;
			if (M3Inv != None && !M3Inv.Stopped && M3Inv.DraculaActive)
				M3Inv.MissionCount += VampHealth;
		}
		P.GiveHealth(VampHealth, P.HealthMax + default.AdjustableHealingDamage);
	}
}

defaultproperties
{
     AdjustableHealingDamage=50
     MinDB=50
     AbilityName="Vampirism"
     Description="Whenever you damage an opponent, you are healed for 5% of the damage per level (up to your starting health amount + 50). You can't gain health from self-damage and you can't gain health from damage caused by the Retaliation ability. You must have a Damage Bonus of at least 50 to purchase this ability. |Cost (per level): 10,15,20,25,30,35,40,45,50..."
     StartingCost=10
     CostAddPerLevel=5
     BotChance=10
     MaxLevel=20
}
