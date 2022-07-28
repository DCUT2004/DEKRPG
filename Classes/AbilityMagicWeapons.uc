class AbilityMagicWeapons extends CostRPGAbility
	config(UT2004RPG)
	abstract;

struct MagicWeaponLevel
{
    var int MaxAddons;
	var int PercentChanceNormal;
	var int PercentChanceZeroAddons;
	var int PercentChanceOneAddon;
	var int PercentChanceTwoAddons;
	var int PercentChanceThreeAddons;
	var int PercentChanceMoreAddons;
};
var config array<MagicWeaponLevel> MagicWeaponLevels;	// complete list of config;

defaultproperties
{
     MinAdrenalineMax=125
     AdrenalineMaxStep=25
     AbilityName="Magic Weapons"
     Description="Have magic weapons. At each level, you get weapons with more magic addons.||You must spend 25 points in your Adrenaline Max stat for each level of this ability you want to purchase. |Cost (per level): 10"
     StartingCost=10
     CostAddPerLevel=10
     MaxLevel=4
     MagicWeaponLevels(0)=(MaxAddons=1,PercentChanceNormal=60,PercentChanceZeroAddons=10,PercentChanceOneAddon=30,PercentChanceTwoAddons=0,PercentChanceThreeAddons=0,PercentChanceMoreAddons=0)
     MagicWeaponLevels(1)=(MaxAddons=1,PercentChanceNormal=20,PercentChanceZeroAddons=20,PercentChanceOneAddon=60,PercentChanceTwoAddons=0,PercentChanceThreeAddons=0,PercentChanceMoreAddons=0)
     MagicWeaponLevels(2)=(MaxAddons=2,PercentChanceNormal=10,PercentChanceZeroAddons=10,PercentChanceOneAddon=30,PercentChanceTwoAddons=50,PercentChanceThreeAddons=0,PercentChanceMoreAddons=0)
     MagicWeaponLevels(3)=(MaxAddons=3,PercentChanceNormal=0,PercentChanceZeroAddons=10,PercentChanceOneAddon=20,PercentChanceTwoAddons=30,PercentChanceThreeAddons=40,PercentChanceMoreAddons=0)
     MagicWeaponLevels(4)=(MaxAddons=4,PercentChanceNormal=0,PercentChanceZeroAddons=0,PercentChanceOneAddon=10,PercentChanceTwoAddons=25,PercentChanceThreeAddons=30,PercentChanceMoreAddons=35)
}
