class AbilityExtremeDamage extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

var config float WeaponDamage;
var config float OtherDamage;

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
    local float DamageChange;
	if(!bOwnedByInstigator)
		return;

	if(Damage > 0)
    {
		if (ClassIsChildOf(DamageType, class'WeaponDamageType'))
        {
            DamageChange = default.WeaponDamage * AbilityLevel;
			Damage *= (1 + DamageChange);
            // Log("+++ Extreme - Increased damage by" @ DamageChange @ "for damage type" @ DamageType @ "for ability level" @ AbilityLevel);
        }
		else if (!ClassIsChildOf(DamageType, class'VehicleDamageType'))
        {
            DamageChange = default.OtherDamage * AbilityLevel;
			Damage *= 1 + (1 + DamageChange);
            // Log("+++ Extreme - Decreased damage by" @ DamageChange @ "for damage type" @ DamageType @ "for ability level" @ AbilityLevel);
        }
    }
}

defaultproperties
{
     WeaponDamage=0.05
     OtherDamage=-0.05
     AbilityName="Extreme Damage Bonus"
     Description="Increases your cumulative total damage bonus by 5% per level for weapons, but reduces damage by 5% for other damage types. |Cost (per level): 5. "
     StartingCost=5
     MaxLevel=6
}
