class AbilityHeavyTank extends AbilityNiche
	config(UT2004RPG) 
	abstract;

var config float DamageMultiplier;

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local xPawn X;
	
	X = xPawn(Other);

	if (X != None)
	{
		X.JumpZ = 0;
		X.bCanDodgeDoubleJump = False;
	}
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if(!bOwnedByInstigator)
		return;
	if(Damage > 0 && ClassIsChildOf(DamageType, class'WeaponDamageType'))
		Damage *= (1 + (AbilityLevel * default.DamageMultiplier));
}

defaultproperties
{
     DamageMultiplier=0.250000
     ExcludingAbilities(0)=Class'DEKRPG209B.AbilityLargeTank'
     ExcludingAbilities(1)=Class'DEKRPG209B.AbilityRecklessTank'
     AbilityName="Niche: Heavy"
     Description="Increases your cumulative total damage bonus by 25%. However, you cannot jump.|You must be level 180 to buy a niche. You can not be in more than one niche at a time.|Cost (per level): 50."
     StartingCost=50
     MaxLevel=1
}
