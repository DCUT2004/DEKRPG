class AbilityWeaponSkill extends CostRPGAbility
	config(UT2004RPG) 
	abstract;
	
var config float DamageMultiplier;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ArtifactWeaponSkill AW;
	local SpecialistInv Inv;
	
	if (Other != None)
	{
		AW = ArtifactWeaponSkill(Other.FindInventoryType(class'ArtifactWeaponSkill'));
		if (AW == None)
		{
			AW = Other.spawn(class'ArtifactWeaponSkill');		
			AW.giveTo(Other);
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

static function ModifyWeapon(Weapon Weapon, int AbilityLevel)
{
    class'AbilityWeaponsProficiency'.static.InformPlayerOfProficiency(Weapon, default.AbilityName);
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	local SpecialistInv Inv;
	local Weapon W;
    local class<weapon> WClass;
	local float DamageChange;
	local RPGStatsInv StatsInv;
    local int WPLevel;
	local float incPerc;
    local int x;
    local DualityInv DInv;
    	
	if (!bOwnedByInstigator)
		return;
	if (bOwnedByInstigator)
	{
		if (RPGWeapon(Instigator.Weapon) != None)
			W = RPGWeapon(Instigator.Weapon).ModifiedWeapon;
		else
			W = Instigator.Weapon;
        WClass = W.Class;
        
        // but we might need to cap the damage if they have WeaponsProficiency and it is close to max
		Inv = SpecialistInv(Instigator.FindInventoryType(class'SpecialistInv'));
		if (Inv != None)
		{
			if (Inv.SelectedSkillWeapon != None)
			{
				if (Inv.SelectedSkillWeapon == WClass)
				{
                    DamageChange = AbilityLevel * default.DamageMultiplier;
                    // Log("++++ AbilityWeaponSkill about to increase damage by" @ DamageChange @ "for ability level" @ AbilityLevel @ "for weapon" @ WClass);
                    
                    // first find out what percentage we are adding on from WeaponsProficiency or DualityProficiency
                	StatsInv = RPGStatsInv(Instigator.FindInventoryType(class'RPGStatsInv'));
                
                	for (x = 0; StatsInv != None && x < StatsInv.Data.Abilities.length; x++)
                    {
                		if (StatsInv.Data.Abilities[x] == class'AbilityWeaponsProficiency')
                			WPLevel = StatsInv.Data.AbilityLevels[x];
                    }
                    
                    if (WPLevel > 0 && Instigator.Weapon.Owner != None)
                    {
    		            DInv = DualityInv(Instigator.FindInventoryType(class'DualityInv'));
                        incPerc = 0.f;
                        
                        if (DInv != None)
                        {
                    		if (WClass == DInv.DualWeaponOne || WClass == DInv.DualWeaponTwo)
                                class'AbilityWeaponsProficiency'.static.DualityGetNumKillsForWeapon(incPerc, Instigator, DInv, WPLevel);
                        }
                        else    // use the increase from Weaponproficiency
                        {
                        	if(instr(caps(string(W)), "AVRIL") > -1)   //hack for vinv avril
                        		class'AbilityWeaponsProficiency'.static.GetNumKillsForWeapon(incPerc, class'INAVRiL', TeamPlayerReplicationInfo(Pawn(Instigator.Weapon.Owner).PlayerReplicationInfo), WPLevel);
                        	else
                        		class'AbilityWeaponsProficiency'.static.GetNumKillsForWeapon(incPerc, WClass, TeamPlayerReplicationInfo(Pawn(Instigator.Weapon.Owner).PlayerReplicationInfo), WPLevel);
                        }

                        if (incPerc + DamageChange > class'AbilityWeaponsProficiency'.default.MaxIncrease)
                        {
                            DamageChange = class'AbilityWeaponsProficiency'.default.MaxIncrease - incPerc;
                            // Log("++++ AbilityWeaponSkill reducing damage increase to" @ DamageChange @ "because WeaponProficiency is set to" @ incPerc);
                        }
                    }
                
            		Damage *= (1 + DamageChange);	
                    // Log("+++ WeaponSkill Damage increased by" @ DamageChange @ "for ability level" @ AbilityLevel @ "for weapon" @ WClass);
				}
			}
		}
        
	}
}

defaultproperties
{
     DamageMultiplier=0.05000
     AbilityName="Weapon Skill"
     Description="You are granted the Weapon Skill artifact. Use this artifact to select one weapon to have extra skill in. This weapon receives an extra 5% damage bonus per level.|Cost (per level): 10."
     StartingCost=10
     MaxLevel=10
}
