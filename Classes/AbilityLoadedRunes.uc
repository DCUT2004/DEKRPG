class AbilityLoadedRunes extends DruidLoaded
	abstract
	config(UT2004RPG);
	
var config int AddAmount;
	
static function bool OverridePickupQuery(Pawn Other, Pickup item, out byte bAllowPickup, int AbilityLevel)
{
	local Inventory Inv;
	local Ammunition Ammunition;
	local Class<Inventory> AmmunitionClass;
	local int AmmoAmount;
	local Weapon W;
	
	if (WeaponPickup(item) != None)
	{
			bAllowPickup = 0;
			return true;
	}
	
	if (Ammo(item) != None)
	{
		for (Inv = Other.Inventory; Inv != None; Inv = Inv.Inventory)
		{
			W = Weapon(Inv);
			if (W != None && W.AmmoClass[0] != None && W.AmmoClass[0].default.MaxAmmo != 5)
			{
				W.AddAmmo(default.AddAmount, 0);
				break;
			}
		}
		
		AmmunitionClass = Ammo(item).InventoryType;
		AmmoAmount = Ammo(item).AmmoAmount;
		for (Inv = Other.Inventory; Inv != None; Inv = Inv.Inventory)
		{
			Ammunition = Ammunition(Inv);
			if (Ammunition != None && Ammunition.Class == AmmunitionClass)
			{
				Ammunition.UseAmmo(AmmoAmount);
				break;
			}
		}
		bAllowPickup = 1;
		return true;
	}
	return false;
}

defaultproperties
{
	 AddAmount=10
     Weapons(0)="DEKRPG209B.RuneFireball_Heatwave"
     Weapons(1)="DEKRPG209B.RuneLaser_Guard"
     Weapons(2)="DEKRPG209B.RuneImmobilize_Magnet"
     Weapons(3)="DEKRPG209B.RuneFlurry_Barrage"
     Weapons(4)="DEKRPG209B.RuneEnergySteal"
     ONSWeapons(0)="DEKRPG209B.RuneBeam_Chain"
     ONSWeapons(1)="DEKRPG209B.RuneHeatWhip_Flare"
     ONSWeapons(3)="DEKRPG209B.RuneEarthquake_Blizzard"
     SuperWeapons(0)="DEKRPG209B.RuneMegaBlast_PoisonBlast"
     WeaponDamage=1.000000
     AdrenalineDamage=1.000000
     AbilityName="Loaded Runes"
     Description="NOTE: This class is a work in progress. Visit us at discord.gg/8yEYsNc5ym to learn more about future updates and provide suggestions.||Runes are weapons that consume adrenaline instead of ammo. Use the Energy Steal rune, which is the only rune to consume regular ammo, to replenish your adrenaline.|You cannot pick up regular weapons. Ammo pickups will replenish the Energy Steal rune.||When you spawn:|Level 1: You are granted a set of runes with the default percentage chance for magic modifiers.|Level 2: You are granted an additional set of runes.|Level 3: You are granted super runes.|Level 4: Magic modifiers will be generated for all your runes.|Level 5: You receive all positive magic modifiers.|Cost (per level): 10,15,20,25,30..."
     StartingCost=10
     CostAddPerLevel=5
     MaxLevel=5
}