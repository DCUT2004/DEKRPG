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
     PlayerLevelReqd(1)=1
     PlayerLevelReqd(2)=1
     PlayerLevelReqd(3)=1
     PlayerLevelReqd(4)=1
     PlayerLevelReqd(5)=1
     Weapons(0)="DEKRPG209D.RuneFireball_Heatwave"
     Weapons(1)="DEKRPG209D.RuneLaser_Guard"
     Weapons(2)="DEKRPG209D.RuneImmobilize_Magnet"
     Weapons(3)="DEKRPG209D.RuneFlurry_Barrage"
     Weapons(4)="DEKRPG209D.RuneEnergySteal"
     ONSWeapons(0)="DEKRPG209D.RuneBeam_Chain"
     ONSWeapons(1)="DEKRPG209D.RuneHeatWhip_Flare"
     ONSWeapons(3)="DEKRPG209D.RuneEarthquake_Blizzard"
     SuperWeapons(0)="DEKRPG209D.RuneMegaBlast_PoisonBlast"
     WeaponDamage=1.000000
     AdrenalineDamage=1.000000
     AbilityName="Loaded Runes"
     Description="NOTE: This class is a work in progress. Visit us on Discord at discord.gg/8yEYsNc5ym to learn more about future updates and provide suggestions.||Runes are weapons that consume adrenaline instead of ammo. Use the Energy Steal rune, which is the only rune to consume regular ammo, to replenish your adrenaline.||Some runes are elemental. Use Fire runes to deal extra damage against Ice monsters, Earth runes against Fire monsters, and Ice runes against Earth monsters. The element of a rune is indicated by the colored border in the weapon HUD.||You cannot pick up regular weapons. Ammo pickups will replenish the Energy Steal rune.||When you spawn:|Level 1: You are granted a set of runes with the default percentage chance for magic modifiers.|Level 2: You are granted an additional set of runes.|Level 3: You are granted super runes.|Level 4: Magic modifiers will be generated for all your runes.|Level 5: You receive all positive magic modifiers.|Cost (per level): 10,15,20,25,30..."
     StartingCost=10
     CostAddPerLevel=5
     MaxLevel=5
}