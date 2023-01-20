class PlayerDataBackup extends Object
	config(PlayerDataBackup)
	PerObjectConfig;

//Player name is the object name
var config string OwnerID; //unique PlayerID of person who owns this name ("Bot" for bots)

var config int Level, Experience, WeaponSpeed, HealthBonus, AdrenalineMax, Attack, Defense, AmmoMax,
	       PointsAvailable, NeededExp;
var config float ExperienceFraction; 

var config array<class<RPGAbility> > Abilities;
var config array<int> AbilityLevels;

var config string LastPlayedAt;

function CopyDataFrom(RPGPlayerDataObject DataObject, string CurrentDateStr)
{
	OwnerID = DataObject.OwnerID;
	Level = DataObject.Level;
	Experience = DataObject.Experience;
	WeaponSpeed = DataObject.WeaponSpeed;
	HealthBonus = DataObject.HealthBonus;
	AdrenalineMax = DataObject.AdrenalineMax;
	Attack = DataObject.Attack;
	Defense = DataObject.Defense;
	AmmoMax = DataObject.AmmoMax;
	PointsAvailable = DataObject.PointsAvailable;
	NeededExp = DataObject.NeededExp;
    ExperienceFraction = DataObject.ExperienceFraction;
	Abilities = DataObject.Abilities;
	AbilityLevels = DataObject.AbilityLevels;

    LastPlayedAt = CurrentDateStr;
}
