class AbilityWeaponsProficiency extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

var config float LevMultiplier;
var config float MaxIncrease;

static function GetNumKillsForWeapon(out float incPerc, class<Weapon> WeaponClass, TeamPlayerReplicationInfo TPPI, int WeaponProficiencyLevel)
{
	local int i;
	local int numKills;
	
	incPerc = 0.0;
	if (TPPI == None)
		return;

	for ( i=0; i<TPPI.WeaponStatsArray.Length && i<200; i++ )
	{
		if (ClassIsChildOf(WeaponClass, TPPI.WeaponStatsArray[i].WeaponClass))
		{
			numKills = TPPI.WeaponStatsArray[i].Kills;
			i = TPPI.WeaponStatsArray.Length;
		}
	}
	incPerc = numKills * (WeaponProficiencyLevel * default.LevMultiplier);
	if (incPerc > default.MaxIncrease)
		incPerc = default.MaxIncrease;
    // Log("++++ GetNumKillsForWeapon Standard increasing damage by" @ incPerc @ "for weapon" @ WeaponClass @ "with kills" @ numKills @ "Abilityevel" @ WeaponProficiencyLevel);
}

static function DualityGetNumKillsForWeapon(out float DualityincPerc, Pawn P, DualityInv DInv, int WeaponProficiencyLevel)
{
    local int NumKills;
	if (DInv == None)
        return;

    NumKills = DInv.DualityKills;        
	DualityincPerc = NumKills * WeaponProficiencyLevel * default.LevMultiplier;
	if (DualityincPerc > default.MaxIncrease)
		DualityincPerc = default.MaxIncrease;
    // Log("++++ GetNumKillsForWeapon Duality increasing damage by" @ DualityincPerc @ "with kills" @ NumKills @ "Abilityevel" @ WeaponProficiencyLevel);
}

static function float GetLevMultiplier()
{
	return default.LevMultiplier;
}

static function float GetMaxIncrease()
{
	return default.MaxIncrease;
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	local float incPerc;
	local Weapon W;
    local class<weapon> WClass;
	local DualityInv DInv;
	
	if(!bOwnedByInstigator)
		return;
        
	if (RPGWeapon(Instigator.Weapon) != None)
		W = RPGWeapon(Instigator.Weapon).ModifiedWeapon;
	else
		W = Instigator.Weapon;
    WClass = W.Class;

    // take into account WeaponProficiency bonus and DualityProficiency bonus, but not WeaponSkill ot SpecialistProficiency        
	if(Damage > 0 && Instigator != None && ClassIsChildOf(DamageType, class'WeaponDamageType'))
	{
		DInv = DualityInv(Instigator.FindInventoryType(class'DualityInv'));
		
		if(DInv != None)
		{
    		if (WClass == DInv.DualWeaponOne || WClass == DInv.DualWeaponTwo)
                DualityGetNumKillsForWeapon(incPerc, Instigator, DInv, AbilityLevel);
            else
                return;
		}
		else
		{
			GetNumKillsForWeapon(incPerc, class<WeapondamageType>(DamageType).default.WeaponClass, TeamPlayerReplicationInfo(Instigator.PlayerReplicationInfo), AbilityLevel);
		}
			
		// ok, now check for DD
		if (Instigator.HasUDamage())
		{
			// shouldn't increase the DD bonus with this ability. To ensure just original damage gets DD boosted, half the proficiency bonus given
			// still allows the triple under some circumstances to give a bit extra, but that is rare, and those games will not normally have high kills
			incPerc = incPerc / 2.f;
		}
        // Log("++++ AbilityWeaponprofociency increasing damage by" @ incPerc @ "for weapon" @ W);
		
		Damage = damage * (incPerc + 1.0);
	}
}

static function InformPlayerOfProficiency(Weapon Weapon, string FromAbilityName)
{
	local Weapon W;
    local class<weapon> WClass;
	local SpecialistInv SInv;
	local DualityInv DInv;
	local RPGStatsInv StatsInv;
    local int WPLevel;
    local int WSLevel;
    local int SPLevel;
	local float incPerc;
	local int intPerc;
	local int x;
    local bool WeaponIsOneOfTheDualWeapons;

    // the player has just selected this weapon and we need to announce the percentage increase on it.
    // this could be increased by WaeponSkill, WeapnProficiency, SpecialistProficiency or DualityProficiency. Only one of Specialist or Duality can be active as they are niche abilities.
    // WeaponSkill and WeaponProficiency work together, and combined must not go over the max allowed increase
    // Specialist and Duality are niches where they give and take, so they can add or remove damage.
	
	if (Weapon == None || Weapon.Owner == None || Pawn(Weapon.Owner) == None || Pawn(Weapon.Owner).PlayerReplicationInfo == None || PlayerController(Pawn(Weapon.Owner).Controller) == None)
		return;
	if (Weapon.Role != ROLE_Authority)
		return;
        
	StatsInv = RPGStatsInv(Pawn(Weapon.Owner).FindInventoryType(class'RPGStatsInv'));

	for (x = 0; StatsInv != None && x < StatsInv.Data.Abilities.length; x++)
    {
		if (StatsInv.Data.Abilities[x] == class'AbilityWeaponsProficiency')
			WPLevel = StatsInv.Data.AbilityLevels[x];
		if (StatsInv.Data.Abilities[x] == class'AbilityWeaponSkill')
			WSLevel = StatsInv.Data.AbilityLevels[x];
		if (StatsInv.Data.Abilities[x] == class'AbilitySpecialistProficiency')
			SPLevel = StatsInv.Data.AbilityLevels[x];
    }
    
    // see if we are announcing or not. This function is called from WeaponsProficiency and WeaponSkill. If player has WeaponSkill leave it to that to announce
    // not called from SpecialistProficiency or DualityProficiency as they requires WeaponsProficiency, so it can handle the message
    if (WSLevel > 0)
        if (FromAbilityName == default.AbilityName)
            return;     // leave it to WeaponSkill to announce
		
	if (RPGWeapon(Weapon) != None)
		W = RPGWeapon(Weapon).ModifiedWeapon;
	else
		W = Weapon;
    WClass = w.Class;
		
	if (Pawn(Weapon.Owner) != None && Pawn(Weapon.Owner).Health > 0)
    {
		SInv = SpecialistInv(Pawn(Weapon.Owner).FindInventoryType(class'SpecialistInv'));
		DInv = DualityInv(Pawn(Weapon.Owner).FindInventoryType(class'DualityInv'));
    }
    
    incPerc = 0.0;
    // first get the Increase percentage from WeaponsProficiency, if they have it
    WeaponIsOneOfTheDualWeapons = false;
    if (WPLevel > 0)
    {
    	if (DInv != None)
    	{
    		if (WClass == DInv.DualWeaponOne || WClass == DInv.DualWeaponTwo)
    		{
                WeaponIsOneOfTheDualWeapons = true;
    			if(instr(caps(string(W)), "AVRIL") > -1)//hack for vinv avril
    				class'AbilityWeaponsProficiency'.static.DualityGetNumKillsForWeapon(incPerc, Pawn(Weapon.Owner), DInv, WPLevel);
    			else
    				class'AbilityWeaponsProficiency'.static.DualityGetNumKillsForWeapon(incPerc, Pawn(Weapon.Owner), DInv, WPLevel);
    		}
            // else not one of the 2 weapons so no bonus added
    	}
    	else
    	{
        	if (instr(caps(string(W)), "AVRIL") > -1) //hack for vinv avril
        		class'AbilityWeaponsProficiency'.static.GetNumKillsForWeapon(incPerc, class'INAVRiL', TeamPlayerReplicationInfo(Pawn(Weapon.Owner).PlayerReplicationInfo), WPLevel);
        	else
        		class'AbilityWeaponsProficiency'.static.GetNumKillsForWeapon(incPerc, W.Class, TeamPlayerReplicationInfo(Pawn(Weapon.Owner).PlayerReplicationInfo), WPLevel);
    	}
    }
 
    // now add on any increase from WeaponSkill    			
	if (SInv != None)
	{
		if (SInv.SelectedSkillWeapon != None && WSLevel != 0)
		{
    		if (SInv.SelectedSkillWeapon == WClass)
            {
    			incPerc += WSLevel * class'AbilityWeaponSkill'.default.DamageMultiplier;
            }
        }
	}
    
    // now cap at the maximim
	if (incPerc > default.MaxIncrease)
		incPerc = default.MaxIncrease;
    
    // now add on any increase from Specialist proficiency    			
	if (SInv != None)
	{
		if (SInv.SelectedSpecialistWeapon != None && SPLevel != 0)
		{
    		if (SInv.SelectedSpecialistWeapon == WClass)
            {
    			incPerc += SPLevel * class'AbilitySpecialistProficiency'.default.SelectedDamageMultiplier;
            }
    		else
            {
    			incPerc += SPLevel * class'AbilitySpecialistProficiency'.default.UnselectedDamageMultiplier;
            }
        }
	}
    
    intPerc = 100 * incPerc;

    PlayerController(Pawn(Weapon.Owner).Controller).ReceiveLocalizedMessage(Class'ProficiencyMessage', intPerc,,,W);
}

// note what the proficiency of this weapon is 
static function ModifyWeapon(Weapon Weapon, int AbilityLevel)
{
    class'AbilityWeaponsProficiency'.static.InformPlayerOfProficiency(Weapon, default.AbilityName);
}

defaultproperties
{
     LevMultiplier=0.000555
     MaxIncrease=1.000000
     AbilityName="Weapons Proficiency"
     Description="Tracks the kills per weapon, and adds extra damage the more you kill. The extra damage can go up to a maximum of 100% of normal damage.|Cost (per level): 20. "
     StartingCost=20
     MaxLevel=10
}
