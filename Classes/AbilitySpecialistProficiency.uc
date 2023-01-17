class AbilitySpecialistProficiency extends AbilityNiche
	config(UT2004RPG) 
	abstract;
	
var config float SelectedDamageMultiplier;
var config float UnselectedDamageMultiplier;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ArtifactSpecialize AS;
	local SpecialistInv Inv;
	
	if (Other != None)
	{
		AS = ArtifactSpecialize(Other.FindInventoryType(class'ArtifactSpecialize'));
		if (AS == None)
		{
			AS = Other.spawn(class'ArtifactSpecialize');		
			AS.giveTo(Other);
		}
		Inv = SpecialistInv(Other.FindInventoryType(class'SpecialistInv'));
		if (Inv == None)
		{
			Inv = Other.spawn(class'SpecialistInv');		
			Inv.giveTo(Other);
		}
		if(Other.SelectedItem == None)
			Other.NextItem();	
	}
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	local SpecialistInv Inv;
	local Weapon W;
    local class<weapon> WClass;
    local float DamageChange;
	
	if (!bOwnedByInstigator)
		return;
	if (bOwnedByInstigator)
	{
		if (RPGWeapon(Instigator.Weapon) != None)
			W = RPGWeapon(Instigator.Weapon).ModifiedWeapon;
		else
			W = Instigator.Weapon;
        WClass = W.Class;
            
		Inv = SpecialistInv(Instigator.FindInventoryType(class'SpecialistInv'));
		if (Inv != None)
		{
			if (Inv.SelectedSpecialistWeapon != None)
			{
				if (Inv.SelectedSpecialistWeapon == WClass)
				{
                    DamageChange = AbilityLevel * default.SelectedDamageMultiplier;
					Damage *= (1 + DamageChange);	
                    // Log("+++ SpecialistProficiency Damage changed by" @ DamageChange @ "for selected weapon" @ W @ "for ability level" @ AbilityLevel);
				}
				else
				{
                    DamageChange = AbilityLevel * default.UnselectedDamageMultiplier;
					Damage *= (1 + DamageChange);	
                    // Log("+++ SpecialistProficiency Damage changed by" @ DamageChange @ "for unselected weapon" @ W @ "for ability level" @ AbilityLevel @ "selected weapon is" @ Inv.SelectedSpecialistWeapon);
				}
			}
		}
	}
}

defaultproperties
{
     SelectedDamageMultiplier=0.05
     UnselectedDamageMultiplier=-0.05
     ExcludingAbilities(0)=Class'DEKRPG999X.AbilityDualityProficiency'
     RequiredAbilities(0)=Class'DEKRPG999X.AbilityWeaponsProficiency'
     AbilityName="Niche: Specialist"
     Description="You are granted the Weapon Specialize artifact. Use this artifact to select one weapon to specialize in. This weapon receives an extra 5% damage bonus per level, and will stack with weapons proficiency. In exchange, the damage from other weapons is reduced by 5% per level.|You must have Weapons Proficiency before purchasing this ability. You must be level 180 to buy a niche. You can not be in more than one niche at a time.|Cost (per level): 10."
     StartingCost=10
     MaxLevel=20
}
