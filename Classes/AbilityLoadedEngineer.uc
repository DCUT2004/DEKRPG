class AbilityLoadedEngineer extends CostRPGAbility
	config(UT2004RPG)
	abstract;


static function SetShieldHealingLevel(Pawn Other, RW_EngineerLink EGun)
{
	local int x;
	local RPGStatsInv StatsInv;

	if (EGun == None || Other == None)
		return;

	StatsInv = RPGStatsInv(Other.FindInventoryType(class'RPGStatsInv'));

	for (x = 0; StatsInv != None && x < StatsInv.Data.Abilities.length; x++)
		if (StatsInv.Data.Abilities[x] == class'AbilityShieldHealing')
		{	// code duplicated from AbilityShieldHealing.ModifyPlayer
			EGun.HealingLevel = StatsInv.Data.AbilityLevels[x];
			EGun.ShieldHealingPercent = class'AbilityShieldHealing'.default.ShieldHealingPercent;
		}

	return;
}

static function SetSpiderBoostLevel(Pawn Other, RW_EngineerLink EGun)
{
	local int x;
	local RPGStatsInv StatsInv;

	if (EGun == None || Other == None)
		return;

	StatsInv = RPGStatsInv(Other.FindInventoryType(class'RPGStatsInv'));

	for (x = 0; StatsInv != None && x < StatsInv.Data.Abilities.length; x++)
		if (StatsInv.Data.Abilities[x] == class'AbilitySpiderSteroids')
		{	// code duplicated from AbilitySpiderSteroids.ModifyPlayer
		    EGun.SpiderBoost = StatsInv.Data.AbilityLevels[x] * class'AbilitySpiderSteroids'.default.LevMultiplier;
		}

	return;
}

static function EngineerPointsInv GetEngInv(Pawn Other)
{
	local EngineerPointsInv EInv;
	local RPGStatsInv StatsInv;

	StatsInv = RPGStatsInv(Other.FindInventoryType(class'RPGStatsInv'));

	EInv = EngineerPointsInv(Other.FindInventoryType(class'EngineerPointsInv'));
	if (EInv != None && StatsInv != None)
		EInv.PlayerLevel = StatsInv.Data.Level;
	
	// if they haven't got one, its time they had.
	if(EInv == None)
	{
		EInv = Other.spawn(class'EngineerPointsInv', Other,,, rot(0,0,0));
		if(EInv == None)
		{
			return EInv; //get it later I guess?
		}
		EInv.UsedBuildingPoints = 0;
		EInv.UsedSentinelPoints = 0;
		EInv.UsedVehiclePoints = 0;
		EInv.UsedTurretPoints = 0;
		EInv.UsedNodePoints = 0;
		EInv.FastBuildPercent = 1.0;
		if (StatsInv != None)
			EInv.PlayerLevel = StatsInv.Data.Level;
		EInv.giveTo(Other);
	}
	return EInv;
}

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local LoadedInv LoadedInv;
	local Inventory OInv;
	local Weapon NewWeapon;
	local EngineerPointsInv EInv;
	local bool bGotTrans;
	local EngTransLauncher ETrans;
	local RW_EngineerLink EGun;

	LoadedInv = LoadedInv(Other.FindInventoryType(class'LoadedInv'));
	if(LoadedInv == None)
	{
		LoadedInv = Other.spawn(class'LoadedInv');
		LoadedInv.giveTo(Other);
	}

	if(LoadedInv == None)
		return;

	LoadedInv.bGotLoadedEngineer = true;

	EInv = GetEngInv(Other);

	// lets see if they have a translocator. If not, then perhaps running a gametype that transing isn't a good idea
	// give them a limited translocator that will let them spawn items, but not translocate
	bGotTrans = false;
	for (OInv=Other.Inventory; OInv != None; OInv = OInv.Inventory)
	{
		if(instr(caps(OInv.ItemName), "TRANSLOCATOR") > -1 && ClassIsChildOf(OInv.Class,class'Weapon'))
		{
			bGotTrans=true;
		}
	}
	if (!bGotTrans)
	{
		ETrans = Other.spawn(class'EngTransLauncher', Other,,, rot(0,0,0));
		if (ETrans != None)
			ETrans.GiveTo(Other);
	}

	// Now let's give the EngineerLinkGun
	EGun = None;
	for (OInv=Other.Inventory; OInv != None; OInv = OInv.Inventory)
	{
		if(ClassIsChildOf(OInv.Class,class'RW_EngineerLink'))
		{
			EGun = RW_EngineerLink(OInv);
			break;
		}
	}
	if (EGun != None)
		return; //already got one

	// now add the new one.
	NewWeapon = Other.spawn(class'EngineerLinkGun', Other,,, rot(0,0,0));
	if(NewWeapon == None)
		return;
	while(NewWeapon.isA('RPGWeapon'))
		NewWeapon = RPGWeapon(NewWeapon).ModifiedWeapon;

	EGun = Other.spawn(class'RW_EngineerLink', Other,,, rot(0,0,0));
	if(EGun == None)
		return;

	EGun.Generate(None);
	if(EGun != None)
	{
		SetShieldHealingLevel(Other, EGun);	// set shield healing level
		SetSpiderBoostLevel(Other, EGun);	// set spider boost level
	}

	//I'm checking the state of RPG Weapon a bunch because sometimes it becomes none mid method.
	if(EGun != None)
		EGun.SetModifiedWeapon(NewWeapon, true);

	if(EGun != None)
		EGun.GiveTo(Other);

}

static function bool OverridePickupQuery(Pawn Other, Pickup item, out byte bAllowPickup, int AbilityLevel)
{
	local class<Weapon> NewWeaponClass;

	if (RPGLinkGunPickup(item) != None)
	{
		bAllowPickup = 0;	// not allowed
		return true;
	}
	else if (WeaponPickup(item) != None && WeaponPickup(item).InventoryType != None)
	{
		NewWeaponClass = class<Weapon>(WeaponPickup(item).InventoryType);
		if (NewWeaponClass != None && ClassIsChildOf(NewWeaponClass, class'RPGLinkGun'))
		{
			bAllowPickup = 0;	// not allowed
			return true;
		}
	}
	else if (WeaponLocker(item) != None && WeaponLocker(item).InventoryType != None)
	{
		NewWeaponClass = class<Weapon>(WeaponLocker(item).InventoryType);
		if (NewWeaponClass != None && ClassIsChildOf(NewWeaponClass, class'RPGLinkGun'))
		{
			bAllowPickup = 0;	// not allowed
			return true;
		}
	}
	return false;			// don't know, so let someone else decide
}

defaultproperties
{
     AbilityName="Loaded Engineer"
     Description="Learn sentinels, turrets, vehicle and buildings to summon, and get the Engineers Link Gun. |Cost: 3"
     StartingCost=3
     MaxLevel=1
}
