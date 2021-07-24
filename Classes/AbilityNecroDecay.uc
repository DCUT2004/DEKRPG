class AbilityNecroDecay extends CostRPGAbility
	config(UT2004RPG);
	
var config float RangeMultiplier;
var config int MaxDrainMin, MaxDrainMax;
var config float BloodSpearMultiplier;
var config float DrainDuringPhantomMultiplier;
var config int SoulMageLevel;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local DecayInv Inv;
	local NecromancerBloodWeapon W;
	local NecromancerSoulWeapon S;
	
	if (Other.IsA('Monster'))
		return;
	if (AbilityLevel < default.SoulMageLevel)
	{
		W = NecromancerBloodWeapon(Other.FindInventoryType(class'NecromancerBloodWeapon'));
		if (W == None)
		{
			W = Other.Spawn(class'NecromancerBloodWeapon');
			W.GiveTo(Other);
		}
	}
	else
	{
		S = NecromancerSoulWeapon(Other.FindInventoryType(class'NecromancerSoulWeapon'));
		if (S == None)
		{
			S = Other.Spawn(class'NecromancerSoulWeapon');
			S.GiveTo(Other);
		}	
	}
	Inv = DecayInv(Other.FindInventoryType(class'DecayInv'));
	if (Inv == None)
	{
		Inv = Other.spawn(class'DecayInv', Other);
		Inv.AbilityLevel = AbilityLevel;
		Inv.SingleDrainRange *= (1 + (AbilityLevel*default.RangeMultiplier));
		Inv.ChainRadius *= (1 + (AbilityLevel*default.RangeMultiplier));
		Inv.SecondChainRadius *= (1 + (AbilityLevel*default.RangeMultiplier));
		Inv.DrainMin += AbilityLevel;
		if (Inv.DrainMin > default.MaxDrainMin)
			Inv.DrainMin = default.MaxDrainMin;
		Inv.DrainMax += AbilityLevel;
		if (Inv.DrainMax > default.MaxDrainMax)
			Inv.DrainMax = default.MaxDrainMax;
		Inv.giveTo(Other);
	}
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if(!bOwnedByInstigator)
		return;
	if(Damage > 0 && DamageType.IsA('DamTypeBloodSpear'))
		Damage *= (1 + (AbilityLevel * default.BloodSpearMultiplier));
	
}

defaultproperties
{
     RangeMultiplier=0.100000
     MaxDrainMin=15
     MaxDrainMax=17
     BloodSpearMultiplier=0.100000
     DrainDuringPhantomMultiplier=0.330000
     SoulMageLevel=7
     AbilityName="Blood Magic"
     Description="Drains the target's health that your crosshair is set on and adds 8% of the damage per level to your health +50 beyond max. Additionally, draining targets will earn you ammo for all weapons.||Draining a target within a short range will establish a blood chain, and the target's health will continue to drain without the need for your crosshair as long as you maintain proximity with the target. Additionally, a second target is chained to the first target if within range. If the first target in the chain dies, the second in the chain will replace it. If you break the chain by moving out of range, you will have to re-establish the blood chain with your crosshair. You cannot drain other targets while chained.||You cannot use Blood Magic on skulls, skeletons, ghosts, or tech monsters. Soul mage level 7 and beyond can.||Each level of this ability increases the health return and range that you can drain a target by 10%. Also increases the damage with the Blood Magic weapon by 10% per level.||Cost(per level): 5,8,11.."
     StartingCost=5
     CostAddPerLevel=3
     MaxLevel=10
}
