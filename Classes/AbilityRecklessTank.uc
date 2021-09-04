class AbilityRecklessTank extends AbilityNiche
	config(UT2004RPG) 
	abstract;

var config float SelfDamageMultiplier, ProtectionMultiplier;


static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if(bOwnedByInstigator)
	{
		if (Injured == Instigator)
			Damage *= 2;
		else if (Injured != Instigator)
			return;
	}
	if(Damage > 0 && !bOwnedByInstigator)
		Damage *= (abs((AbilityLevel * default.ProtectionMultiplier)-1));
}

defaultproperties
{
     SelfDamageMultiplier=0.150000
     ProtectionMultiplier=0.050000
     ExcludingAbilities(0)=Class'DEKRPG209A.AbilityHeavyTank'
     ExcludingAbilities(1)=Class'DEKRPG209A.AbilityLargeTank'
     ExcludingAbilities(2)=Class'UT2004RPG.AbilityReduceSelfDamage'
     AbilityName="Niche: Reckless"
     Description="Increases your cumulative total damage reduction by 5% per level, but also doubles self-damage.|You must be level 180 to buy a niche. You can not be in more than one niche at a time.|You cannot have this ability and Cautiousness at the same time.|Cost (per level): 10."
     StartingCost=10
     MaxLevel=20
}
