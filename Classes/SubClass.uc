class SubClass extends RPGAbility
	config(UT2004RPG)
	abstract;

// this ability is just a place holder for the different subclasses on the system.
// each level represents a different subclass.
// AbilityConfigs(0)=(AvailableAbility=Class'DruidsRPG221.DruidSomeAbility',AvailableSubClasses="0,3,6,12",MaxLevels="5,15,15,10")


// mapping of level to subclass. level 0 is no subclass. level 1 is SubClasses(1) etc.
var config Array<string> SubClasses;

// structure containing list of subclasses available to each class, and what minimum level it can be bought at
struct SubClassAvailability
{
	var class<RPGClass> AvailableClass;
	var string AvailableSubClass;
	var int MinLevel;			// min level this class can use this subclass
};
var config Array<SubClassAvailability> SubClassConfigs;
// to remove a subclass, remove it from this SubClassConfigs list. Then the L screen will force the user to sell.

// structure containing list of abilities available to each class/subclass. Set MaxLevel to zero for abilities not available.
struct AbilityConfig
{
	var class<RPGAbility> AvailableAbility;
	var Array<int> MaxLevels;			// one maxlevel per subclass, zero means cannot have
};
var config Array<AbilityConfig> AbilityConfigs;

static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	if ( Data != None && Data.OwnerID == "Bot")
		return 0;		// do not let bots buy subclasses. Too complex for them.

	if (CurrentLevel==0)
		return 1;	// can buy. Check for valid class is done elsewhere
	else
		return 0;	// can only buy one level for cost purposes

}

static function int BotBuyChance(Bot B, RPGPlayerDataObject Data, int CurrentLevel)
{
		return 0;	// stop bots from buying. Could just set BotChance to 0, but we still then have the hassle of calculating the cost.
}

defaultproperties
{
     SubClasses(0)="None"
     SubClasses(1)="Class: Weapons Master"
     SubClasses(2)="Class: Adrenaline Master"
     SubClasses(3)="Class: Monster/Medic Master"
     SubClasses(4)="Class: Engineer"
     SubClasses(5)="Class: General"
     SubClasses(6)="Class: Classic RPG"
     SubClasses(7)="Extreme Weapons Master"
     SubClasses(8)="Berserker"
     SubClasses(9)="Weapons Proficiency"
     SubClasses(10)="Tank"
     SubClasses(11)="Extreme Adrenaline Master"
     SubClasses(12)="Craftsman"
     SubClasses(13)="Base Builder"
     SubClasses(14)="Engineer Weaponry"
     SubClasses(15)="Healer"
     SubClasses(16)="Summoner"
     SubClasses(17)="Weapon-Adrenaline Hybrid"
     SubClasses(18)="Weapon-Medic Hybrid"
     SubClasses(19)="Weapon-Engineer Hybrid"
     SubClasses(20)="Adrenaline-Medic Hybrid"
     SubClasses(21)="Adrenaline-Engineer Hybrid"
     SubClasses(22)="Medic-Engineer Hybrid"
     SubClasses(23)="Auto Engineer"
     SubClasses(24)="Sniper"
     SubClasses(25)="Necromancer"
     SubClasses(26)="Reset Your Skills"
     SubClassConfigs(0)=(AvailableClass=Class'DEKRPG208AC.ClassWeaponsMaster',AvailableSubClass="None",MinLevel=30)
     SubClassConfigs(1)=(AvailableClass=Class'DEKRPG208AC.ClassAdrenalineMaster',AvailableSubClass="None",MinLevel=30)
     SubClassConfigs(2)=(AvailableClass=Class'DEKRPG208AC.ClassMonsterMaster',AvailableSubClass="None",MinLevel=30)
     SubClassConfigs(3)=(AvailableClass=Class'DEKRPG208AC.ClassEngineer',AvailableSubClass="None",MinLevel=30)
     SubClassConfigs(4)=(AvailableClass=Class'DEKRPG208AC.ClassGeneral',AvailableSubClass="None",MinLevel=30)
     SubClassConfigs(5)=(AvailableClass=Class'DEKRPG208AC.ClassClassicRPG',AvailableSubClass="None",MinLevel=30)
     SubClassConfigs(6)=(AvailableClass=Class'DEKRPG208AC.ClassWeaponsMaster',AvailableSubClass="Extreme Weapons Master",MinLevel=90)
     SubClassConfigs(7)=(AvailableClass=Class'DEKRPG208AC.ClassWeaponsMaster',AvailableSubClass="Berserker",MinLevel=90)
     SubClassConfigs(8)=(AvailableClass=Class'DEKRPG208AC.ClassWeaponsMaster',AvailableSubClass="Sniper",MinLevel=90)
     SubClassConfigs(9)=(AvailableClass=Class'DEKRPG208AC.ClassWeaponsMaster',AvailableSubClass="Weapons Proficiency",MinLevel=90)
     SubClassConfigs(10)=(AvailableClass=Class'DEKRPG208AC.ClassWeaponsMaster',AvailableSubClass="Tank",MinLevel=90)
     SubClassConfigs(11)=(AvailableClass=Class'DEKRPG208AC.ClassAdrenalineMaster',AvailableSubClass="Extreme Adrenaline Master",MinLevel=90)
     SubClassConfigs(12)=(AvailableClass=Class'DEKRPG208AC.ClassAdrenalineMaster',AvailableSubClass="Craftsman",MinLevel=90)
     SubClassConfigs(13)=(AvailableClass=Class'DEKRPG208AC.ClassEngineer',AvailableSubClass="Base Builder",MinLevel=90)
     SubClassConfigs(14)=(AvailableClass=Class'DEKRPG208AC.ClassEngineer',AvailableSubClass="Engineer Weaponry",MinLevel=90)
     SubClassConfigs(15)=(AvailableClass=Class'DEKRPG208AC.ClassEngineer',AvailableSubClass="Auto Engineer",MinLevel=90)
     SubClassConfigs(16)=(AvailableClass=Class'DEKRPG208AC.ClassMonsterMaster',AvailableSubClass="Healer",MinLevel=90)
     SubClassConfigs(17)=(AvailableClass=Class'DEKRPG208AC.ClassMonsterMaster',AvailableSubClass="Summoner",MinLevel=90)
     SubClassConfigs(18)=(AvailableClass=Class'DEKRPG208AC.ClassMonsterMaster',AvailableSubClass="Necromancer",MinLevel=90)
     SubClassConfigs(19)=(AvailableClass=Class'DEKRPG208AC.ClassGeneral',AvailableSubClass="Weapon-Adrenaline Hybrid",MinLevel=90)
     SubClassConfigs(20)=(AvailableClass=Class'DEKRPG208AC.ClassGeneral',AvailableSubClass="Weapon-Medic Hybrid",MinLevel=90)
     SubClassConfigs(21)=(AvailableClass=Class'DEKRPG208AC.ClassGeneral',AvailableSubClass="Weapon-Engineer Hybrid",MinLevel=90)
     SubClassConfigs(22)=(AvailableClass=Class'DEKRPG208AC.ClassGeneral',AvailableSubClass="Adrenaline-Medic Hybrid",MinLevel=90)
     SubClassConfigs(23)=(AvailableClass=Class'DEKRPG208AC.ClassGeneral',AvailableSubClass="Adrenaline-Engineer Hybrid",MinLevel=90)
     SubClassConfigs(24)=(AvailableClass=Class'DEKRPG208AC.ClassGeneral',AvailableSubClass="Medic-Engineer Hybrid",MinLevel=90)
     SubClassConfigs(25)=(AvailableClass=Class'DEKRPG208AC.ClassWeaponsMaster',AvailableSubClass="Reset Your Skills",MinLevel=30)
     SubClassConfigs(26)=(AvailableClass=Class'DEKRPG208AC.ClassAdrenalineMaster',AvailableSubClass="Reset Your Skills",MinLevel=30)
     SubClassConfigs(27)=(AvailableClass=Class'DEKRPG208AC.ClassMonsterMaster',AvailableSubClass="Reset Your Skills",MinLevel=30)
     SubClassConfigs(28)=(AvailableClass=Class'DEKRPG208AC.ClassEngineer',AvailableSubClass="Reset Your Skills",MinLevel=30)
     SubClassConfigs(29)=(AvailableClass=Class'DEKRPG208AC.ClassGeneral',AvailableSubClass="Reset Your Skills",MinLevel=30)
     SubClassConfigs(30)=(AvailableClass=Class'DEKRPG208AC.ClassClassicRPG',AvailableSubClass="Reset Your Skills",MinLevel=30)
     AbilityConfigs(0)=(AvailableAbility=Class'DEKRPG208AC.DruidAmmoRegen',MaxLevels=(0,4,4,0,0,1,2,6,6,6,4,4,4,0,0,0,0,4,2,2,2,2,0,1,4,2,1))
     AbilityConfigs(1)=(AvailableAbility=Class'DEKRPG208AC.DruidAwareness',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(2)=(AvailableAbility=Class'DEKRPG208AC.DruidNoWeaponDrop',MaxLevels=(0,2,3,0,0,0,3,2,2,2,2,2,3,0,0,0,0,2,2,2,2,2,0,0,2,0,0))
     AbilityConfigs(3)=(AvailableAbility=Class'DEKRPG208AC.DruidRegen',MaxLevels=(3,5,1,5,1,3,5,5,5,5,5,1,1,1,1,0,5,3,5,3,3,1,3,2,5,0,3))
     AbilityConfigs(4)=(AvailableAbility=Class'DEKRPG208AC.AbilityHealerRegen',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(5)=(AvailableAbility=Class'DEKRPG208AC.DruidAdrenalineRegen',MaxLevels=(0,0,3,1,0,1,0,0,0,0,0,3,3,0,0,1,1,2,1,0,3,2,1,0,0,1,0))
     AbilityConfigs(6)=(AvailableAbility=Class'DEKRPG208AC.AbilityVehicleEject',MaxLevels=(1,1,1,1,4,2,1,1,1,1,1,1,1,4,4,1,1,1,1,2,1,2,2,4,1,1,1))
     AbilityConfigs(7)=(AvailableAbility=Class'DEKRPG208AC.AbilityWheeledVehicleStunts',MaxLevels=(2,2,2,2,4,2,2,2,2,2,2,2,2,2,4,2,2,2,2,3,3,3,3,4,2,2,2))
     AbilityConfigs(8)=(AvailableAbility=Class'DEKRPG208AC.DruidGhost',MaxLevels=(3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,0,3))
     AbilityConfigs(9)=(AvailableAbility=Class'DEKRPG208AC.DruidUltima',MaxLevels=(4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4))
     AbilityConfigs(10)=(AvailableAbility=Class'DEKRPG208AC.DruidCounterShove',MaxLevels=(5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5))
     AbilityConfigs(11)=(AvailableAbility=Class'DEKRPG208AC.DruidRetaliate',MaxLevels=(10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10))
     AbilityConfigs(12)=(AvailableAbility=Class'UT2004RPG.AbilityJumpZ',MaxLevels=(3,3,3,3,3,3,3,3,3,3,0,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3))
     AbilityConfigs(13)=(AvailableAbility=Class'UT2004RPG.AbilityReduceFallDamage',MaxLevels=(4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4))
     AbilityConfigs(14)=(AvailableAbility=Class'UT2004RPG.AbilitySpeed',MaxLevels=(4,4,4,4,4,4,4,4,4,4,0,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4))
     AbilityConfigs(15)=(AvailableAbility=Class'UT2004RPG.AbilityShieldStrength',MaxLevels=(4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4))
     AbilityConfigs(16)=(AvailableAbility=Class'UT2004RPG.AbilityReduceSelfDamage',MaxLevels=(5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5))
     AbilityConfigs(17)=(AvailableAbility=Class'UT2004RPG.AbilitySmartHealing',MaxLevels=(4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4))
     AbilityConfigs(18)=(AvailableAbility=Class'UT2004RPG.AbilityAirControl',MaxLevels=(4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4))
     AbilityConfigs(19)=(AvailableAbility=Class'UT2004RPG.AbilityFastWeaponSwitch',MaxLevels=(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2))
     AbilityConfigs(20)=(AvailableAbility=Class'DEKRPG208AC.DruidAdrenalineSurge',MaxLevels=(0,0,2,0,0,0,0,0,0,0,0,3,2,0,0,0,0,3,0,0,1,1,0,0,0,3,0))
     AbilityConfigs(21)=(AvailableAbility=Class'DEKRPG208AC.DruidEnergyVampire',MaxLevels=(0,0,5,0,0,2,0,0,0,0,0,5,3,0,0,0,0,3,0,0,2,2,0,0,0,0,0))
     AbilityConfigs(22)=(AvailableAbility=Class'DEKRPG208AC.AbilityEnergyShield',MaxLevels=(0,0,2,0,0,0,0,0,0,0,0,2,3,0,0,0,0,1,0,0,1,1,0,0,0,0,0))
     AbilityConfigs(23)=(AvailableAbility=Class'DEKRPG208AC.AbilityMagicVault',MaxLevels=(0,3,0,0,0,0,0,3,3,3,3,0,3,0,0,0,0,2,1,1,0,0,0,0,3,0,0))
     AbilityConfigs(24)=(AvailableAbility=Class'DEKRPG208AC.DEKLoadedClassicShield',MaxLevels=(1,2,1,1,1,1,2,2,2,2,2,1,1,1,1,1,1,2,2,2,1,1,1,1,2,1,1))
     AbilityConfigs(25)=(AvailableAbility=Class'DEKRPG208AC.DEKLoadedClassicAR',MaxLevels=(1,2,1,1,1,1,0,2,2,2,2,1,1,1,1,1,1,2,2,2,1,1,1,1,2,1,1))
     AbilityConfigs(26)=(AvailableAbility=Class'DEKRPG208AC.DEKLoadedUtility',MaxLevels=(0,2,0,0,0,1,0,2,2,2,2,0,0,0,0,0,0,2,2,2,0,0,0,0,2,0,0))
     AbilityConfigs(27)=(AvailableAbility=Class'DEKRPG208AC.DEKLoadedAVRiL',MaxLevels=(0,2,0,0,0,1,0,2,2,2,2,0,0,0,0,0,0,2,2,2,0,0,0,0,2,0,0))
     AbilityConfigs(28)=(AvailableAbility=Class'DEKRPG208AC.DEKLoadedWarrior',MaxLevels=(0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(29)=(AvailableAbility=Class'DEKRPG208AC.DruidArtifactLoaded',MaxLevels=(0,0,4,0,0,2,0,0,0,0,0,5,0,0,0,0,0,3,0,0,3,3,0,0,0,0,0))
     AbilityConfigs(30)=(AvailableAbility=Class'DEKRPG208AC.AbilityLoadedCraftsman',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(31)=(AvailableAbility=Class'DEKRPG208AC.DruidLoaded',MaxLevels=(0,5,0,0,0,0,0,6,5,5,3,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0))
     AbilityConfigs(32)=(AvailableAbility=Class'DEKRPG208AC.AbilityHybridWeapons',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,0,0,0,0,0,0,0,0))
     AbilityConfigs(33)=(AvailableAbility=Class'DEKRPG208AC.AbilityHybridWeaponsEM',MaxLevels=(0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0))
     AbilityConfigs(34)=(AvailableAbility=Class'DEKRPG208AC.DruidVampire',MaxLevels=(0,10,0,0,0,2,0,10,10,10,10,0,0,0,0,0,0,5,5,5,0,0,0,2,10,7,0))
     AbilityConfigs(35)=(AvailableAbility=Class'DEKRPG208AC.DruidVampireSurge',MaxLevels=(0,0,0,0,0,0,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(36)=(AvailableAbility=Class'DEKRPG208AC.AbilityEnhancedDamage',MaxLevels=(0,10,0,0,0,3,15,0,0,0,0,0,0,0,0,0,0,5,5,5,0,0,0,0,0,0,0))
     AbilityConfigs(37)=(AvailableAbility=Class'DEKRPG208AC.AbilityBerserkerDamage',MaxLevels=(0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(38)=(AvailableAbility=Class'DEKRPG208AC.AbilityDistalDamage',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0))
     AbilityConfigs(39)=(AvailableAbility=Class'DEKRPG208AC.AbilityWeaponsProficiency',MaxLevels=(0,0,0,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(40)=(AvailableAbility=Class'DEKRPG208AC.AbilityIncreasedDamage',MaxLevels=(0,0,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(41)=(AvailableAbility=Class'DEKRPG208AC.AbilityIncreasedProtection',MaxLevels=(0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(42)=(AvailableAbility=Class'DEKRPG208AC.AbilityLoadedHealing',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(43)=(AvailableAbility=Class'DEKRPG208AC.AbilityDEKLoadedHealing',MaxLevels=(0,0,0,7,0,1,0,0,0,0,0,0,0,0,0,10,5,0,5,0,5,0,5,0,0,0,0))
     AbilityConfigs(44)=(AvailableAbility=Class'DEKRPG208AC.AbilityNecromancer',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0))
     AbilityConfigs(45)=(AvailableAbility=Class'DEKRPG208AC.AbilityExpHealing',MaxLevels=(0,0,0,9,0,2,0,0,0,0,0,0,0,0,0,12,2,0,5,0,5,0,5,0,0,0,0))
     AbilityConfigs(46)=(AvailableAbility=Class'DEKRPG208AC.AbilityMedicAwareness',MaxLevels=(0,0,0,2,0,1,0,0,0,0,0,0,0,0,0,2,2,0,2,0,2,0,2,0,0,0,0))
     AbilityConfigs(47)=(AvailableAbility=Class'DEKRPG208AC.AbilityLoadedMonsters',MaxLevels=(0,0,0,10,0,0,0,0,0,0,0,0,0,0,0,5,20,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(48)=(AvailableAbility=Class'DEKRPG208AC.AbilityNecroLoadedMonsters',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0))
     AbilityConfigs(49)=(AvailableAbility=Class'DEKRPG208AC.AbilityMonsterHealthBonus',MaxLevels=(0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,3,10,0,0,0,0,0,0,0,0,10,0))
     AbilityConfigs(50)=(AvailableAbility=Class'DEKRPG208AC.AbilityMonsterPoints',MaxLevels=(0,0,0,10,0,0,0,0,0,0,0,0,0,0,0,5,20,0,0,0,0,0,0,0,0,10,0))
     AbilityConfigs(51)=(AvailableAbility=Class'DEKRPG208AC.AbilityMonsterSkill',MaxLevels=(0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,7,7,0,0,0,0,0,0,0,0,7,0))
     AbilityConfigs(52)=(AvailableAbility=Class'DEKRPG208AC.AbilitySummonerMonsterDamage',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(53)=(AvailableAbility=Class'DEKRPG208AC.AbilityMonsterDamage',MaxLevels=(0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,5,0))
     AbilityConfigs(54)=(AvailableAbility=Class'DEKRPG208AC.AbilityEnhancedReduction',MaxLevels=(3,0,0,10,0,3,13,0,0,0,0,0,0,0,0,13,7,0,5,0,5,0,5,0,0,10,0))
     AbilityConfigs(55)=(AvailableAbility=Class'DEKRPG208AC.AbilityLoadedEngineer',MaxLevels=(0,0,0,0,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(56)=(AvailableAbility=Class'DEKRPG208AC.AbilityGeneralEngineer',MaxLevels=(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(57)=(AvailableAbility=Class'DEKRPG208AC.AbilityExtremeEngineer',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(58)=(AvailableAbility=Class'DEKRPG208AC.AbilityTurretSpecialist',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(59)=(AvailableAbility=Class'DEKRPG208AC.AbilityEngineerWeaponry',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(60)=(AvailableAbility=Class'DEKRPG208AC.AbilityAutoEngineer',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,0,0,0))
     AbilityConfigs(61)=(AvailableAbility=Class'DEKRPG208AC.AbilityBaseSpecialist',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,20,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(62)=(AvailableAbility=Class'DEKRPG208AC.DruidShieldRegen',MaxLevels=(0,0,0,0,10,3,0,0,0,0,0,0,0,5,10,0,0,0,0,5,0,5,5,15,0,0,0))
     AbilityConfigs(63)=(AvailableAbility=Class'DEKRPG208AC.AbilityShieldHealing',MaxLevels=(0,0,0,0,3,1,0,0,0,0,0,0,0,3,3,0,0,0,0,2,0,2,2,1,0,0,0))
     AbilityConfigs(64)=(AvailableAbility=Class'DEKRPG208AC.DruidArmorRegen',MaxLevels=(1,1,1,1,5,3,1,1,1,1,1,1,1,5,5,1,1,1,1,3,1,3,3,7,1,1,1))
     AbilityConfigs(65)=(AvailableAbility=Class'DEKRPG208AC.DruidArmorVampire',MaxLevels=(1,1,1,1,5,2,1,1,1,1,1,1,1,5,5,1,1,1,1,3,1,3,3,5,1,1,1))
     AbilityConfigs(66)=(AvailableAbility=Class'DEKRPG208AC.AbilityConstructionHealthBonus',MaxLevels=(0,0,0,0,7,5,0,0,0,0,0,0,0,9,7,0,0,0,0,5,0,5,5,7,0,0,0))
     AbilityConfigs(67)=(AvailableAbility=Class'DEKRPG208AC.AbilityEngineerAwareness',MaxLevels=(0,0,0,0,1,1,0,0,0,0,0,0,0,1,1,0,0,0,0,1,0,1,1,1,0,0,0))
     AbilityConfigs(68)=(AvailableAbility=Class'DEKRPG208AC.AbilityRapidBuild',MaxLevels=(0,0,0,0,15,12,0,0,0,0,0,0,0,15,15,0,0,0,0,12,0,12,12,15,0,0,0))
     AbilityConfigs(69)=(AvailableAbility=Class'DEKRPG208AC.AbilityHybridEngineer',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,10,0,0,0,0))
     AbilityConfigs(70)=(AvailableAbility=Class'DEKRPG208AC.AbilityHybridEngineerWM',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0,0,0,0,0))
     AbilityConfigs(71)=(AvailableAbility=Class'DEKRPG208AC.AbilityDefenseSentinelResupply',MaxLevels=(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,5,0,0,0))
     AbilityConfigs(72)=(AvailableAbility=Class'DEKRPG208AC.AbilityDefenseSentinelHealing',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0))
     AbilityConfigs(73)=(AvailableAbility=Class'DEKRPG208AC.AbilityDefenseSentinelShields',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0))
     AbilityConfigs(74)=(AvailableAbility=Class'DEKRPG208AC.AbilityDefenseSentinelEnergy',MaxLevels=(0,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0))
     AbilityConfigs(75)=(AvailableAbility=Class'DEKRPG208AC.AbilityDefenseSentinelArmor',MaxLevels=(0,0,0,0,8,8,0,0,0,0,0,0,0,8,8,0,0,0,0,5,0,5,5,8,0,0,0))
     AbilityConfigs(76)=(AvailableAbility=Class'DEKRPG208AC.AbilitySpiderSteroids',MaxLevels=(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0))
     AbilityConfigs(77)=(AvailableAbility=Class'DEKRPG208AC.AbilityHardCore',MaxLevels=(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1))
     BotChance=1
}
