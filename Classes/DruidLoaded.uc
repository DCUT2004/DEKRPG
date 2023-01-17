class DruidLoaded extends CostRPGAbility
	config(UT2004RPG) 
	abstract;

// these config variables just affect the server so ok
var config Array< String > Weapons;
var config Array< String > ONSWeapons;
var config Array< String > SuperWeapons;

static function bool AbilityIsAllowed(GameInfo Game, MutUT2004RPG RPGMut)
{
	if(RPGMut.WeaponModifierChance == 0)
		return false;

	return true;
}

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local Mutator m;
	local MutUT2004RPG RPGMut;
	local int x;
	local LoadedInv LoadedInv;
	local Inventory OInv;
	local Inventory UTIL;
	local Inventory DEKAVRIL;
	local int OldLevel;

	if (Other == None)
			return;
			
	if (Other.Level != None && Other.Level.Game != None)
	{
		for (m = Other.Level.Game.BaseMutator; m != None; m = m.NextMutator)
		if (MutUT2004RPG(m) != None)
		{
			RPGMut = MutUT2004RPG(m);
			break;
		}
	}

	LoadedInv = LoadedInv(Other.FindInventoryType(class'LoadedInv'));

	if (LoadedInv != None)
	{
		if(LoadedInv.bGotLoadedWeapons && LoadedInv.LWAbilityLevel == AbilityLevel)
			return;
	}
	else
	{
		LoadedInv = Other.spawn(class'LoadedInv');
		if(LoadedInv != None)
			LoadedInv.giveTo(Other);
	}

	if(LoadedInv == None)
		return;

	LoadedInv.bGotLoadedWeapons = true;
	OldLevel = LoadedInv.LWAbilityLevel;		// keep old level so only add new weapons
	LoadedInv.LWAbilityLevel = AbilityLevel;

	if(Other.Role != ROLE_Authority)
		return;

	for (OInv=Other.Inventory ; OInv != None && (UTIL == None || DEKAVRIL == None) ; OInv=OInv.Inventory)
	{
// You can't delete within the for, as Deleting results in OInv == None, so
// the DEKAVRIL is never found.  Instead, grab them both in their own var ...
		if(instr(caps(OInv.ItemName), "UTILITY") > -1)
		{
			UTIL=OInv;
		}
		if(instr(caps(OInv.ItemName), "AVRIL") > -1)
		{
			DEKAVRIL=OInv;
		}
	}

// This stops the client from erroneously deleting the UTIL and DEKAVRIL - like
// after a ghost, getting into and out of a vehicle ... all those dumb
// cases where the client likes to run ModifyPawn when it probably
// shouldn't.

	// And delete them after they're both found.
	if(UTIL != None && LoadedInv != None)
		Other.DeleteInventory(UTIL);
	if(DEKAVRIL != None && LoadedInv != None)
		Other.DeleteInventory(DEKAVRIL);

	// so give them the weapons
	// but only ones granted as part of this upgrade. otherwise get multiple copies of each
	if (OldLevel < 1)
		for(x = 0; x < default.Weapons.length; x++)
			giveWeapon(Other, default.Weapons[x], AbilityLevel, RPGMut);
	if (OldLevel < 2)
		for(x = 0; AbilityLevel >= 2 && x < default.ONSWeapons.length; x++)
			giveWeapon(Other, default.ONSWeapons[x], AbilityLevel, RPGMut);
	if (OldLevel < 3)
		for(x = 0; Other.Level.Game.IsA('Invasion') && AbilityLevel >= 3 && x < default.SuperWeapons.length; x++)
			giveWeapon(Other, default.SuperWeapons[x], AbilityLevel, RPGMut);

}

static function giveWeapon(Pawn Other, String oldName, int AbilityLevel, MutUT2004RPG RPGMut)
{
	Local string newName;
	local class<Weapon> WeaponClass;
	local class<RPGWeapon> RPGWeaponClass;
	local Weapon NewWeapon;
	local RPGWeapon RPGWeapon;

	if(Other == None || Other.IsA('Monster'))
		return;

	if(oldName == "")
		return;
	if (Other.Level != None && Other.Level.Game != None && Other.Level.Game.BaseMutator != None)
	{
		newName = Other.Level.Game.BaseMutator.GetInventoryClassOverride(oldName);
		WeaponClass = class<Weapon>(Other.DynamicLoadObject(newName, class'Class'));
	}
	else
		WeaponClass = class<Weapon>(Other.DynamicLoadObject(oldName, class'Class'));

	newWeapon = Other.spawn(WeaponClass, Other,,, rot(0,0,0));
	if(newWeapon == None)
		return;
	while(newWeapon.isA('RPGWeapon'))
		newWeapon = RPGWeapon(newWeapon).ModifiedWeapon;

	RPGWeaponClass = RPGMut.GetRandomWeaponModifier(WeaponClass, Other);

	RPGWeapon = Other.spawn(RPGWeaponClass, Other,,, rot(0,0,0));
	if(RPGWeapon == None)
    {
		return;
    }
    
    RPGWeapon.ModifiedWeapon = newWeapon;

	RPGWeapon.Generate(None);
	
	//I'm checking the state of RPG Weapon a bunch because sometimes it becomes none mid method.
	if(RPGWeapon == None)
		return;

	RPGWeapon.SetModifiedWeapon(newWeapon, true);

	if(RPGWeapon == None)
		return;

	RPGWeapon.GiveTo(Other);

	if(RPGWeapon == None)
		return;

	if(AbilityLevel == 1)
	{
		RPGWeapon.FillToInitialAmmo();
	}
	else if(AbilityLevel > 1)
	{
		if (oldName == "XWeapons.AssaultRifle")
		{
			RPGWeapon.Loaded();
		}
		RPGWeapon.MaxOutAmmo();
	}
}

defaultproperties
{
     PlayerLevelReqd(1)=1
     PlayerLevelReqd(2)=40
     PlayerLevelReqd(3)=55
     PlayerLevelReqd(4)=55
     PlayerLevelReqd(5)=55
     PlayerLevelReqd(6)=55
     AbilityName="Loaded Weapons"
     Description="When you spawn:|Level 1: You are granted a set of weapons with the default percentage chance for magic weapons.|Level 2: You are granted an additional set of weapons and all weapons with max ammo.|Level 3: You are granted super weapons (Invasion game types only).|You must be level 40 before you can buy level 2 and level 55 before you can buy level 3.|Cost (per level): 10,15,20"
     StartingCost=10
     CostAddPerLevel=5
     MaxLevel=3
}
