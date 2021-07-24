class AbilityMasterSoulSorcerer extends AbilityNiche
	config(UT2004RPG)
	abstract;
	
var config float DamageMultiplier;

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local DecayInv Inv;
	
	Inv = DecayInv(Other.FindInventoryType(class'DecayInv'));
	if (Inv != None)
	{
		Inv.bMaster = True;
	}
	else
		return;
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if(bOwnedByInstigator)
		return;
	if(Damage > 0)
	{
			Damage *= default.DamageMultiplier;
	}
}

defaultproperties
{
	 DamageMultiplier=1.1000
     ExcludingAbilities(0)=Class'DEKRPG208AA.AbilityEternalSoulSorcerer'
     RequiredAbilities(0)=Class'DEKRPG208AA.AbilityNecroDecay'
     AbilityName="Niche: Master"
     Description="Each time a target you are chained to dies, this ability summons a hostile soul that seeks out other targets.|Your defense is decreased by 10%.||You must be level 180 and have Blood Magic before buying this niche. You can not be in more than one niche at a time.||Cost(per level): 50"
     StartingCost=50
     MaxLevel=1
}
