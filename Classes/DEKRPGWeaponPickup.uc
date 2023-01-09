class DEKRPGWeaponPickup extends RPGWeaponPickup;

auto state Pickup
{
	function bool ValidTouch (actor Other)
	{
		local DEKRPGWeapon mpw;
		local int imax;

		if (DroppedWeapon != None && Other != None && Pawn(Other) != None)
		{
			mpw = DEKRPGWeapon(DroppedWeapon);
			if (mpw != None)
			{
				imax = mpw.MaxPowersForThisPlayer(Pawn(Other));
				if (mpw.NumPowerTypes > imax)
					return false;		// too powerful for this chap
			}
		}

		return Super.ValidTouch(Other);
	}
}

function inventory SpawnCopy( pawn Other )
{
	// unfortunately, there is a bug in the RPGWeaponPickup code 
	// If there is a DroppedWeapon in the pickup (always!), then we still need to remove the reference from StatsInv.OldWeapons
	local RPGStatsInv DWStatsInv;
	local int x;
	local RPGWeapon OldWeapon;
	local inventory Copy;
 	local RPGStatsInv StatsInv;
	local class<RPGWeapon> NewWeaponClass;
	local bool bRemoveReference;
	local Weapon NewWeapon;

	if ( Inventory != None )
		Inventory.Destroy();

	if (DroppedWeapon != None)
	{
		DWStatsInv = RPGStatsInv(Other.FindInventoryType(class'RPGStatsInv'));
		if (DWStatsInv != None)
			for (x = 0; x < DWStatsInv.OldRPGWeapons.length; x++)
			{
				if (DWStatsInv.OldRPGWeapons[x].ModifiedClass == InventoryType)
				{
					OldWeapon = DWStatsInv.OldRPGWeapons[x].Weapon;
					if (OldWeapon == None)
					{
						DWStatsInv.OldRPGWeapons.Remove(x, 1);
						x--;
					}
					else
					{
						DWStatsInv.OldRPGWeapons.Remove(x, 1);
						OldWeapon.RemoveReference();
						OldWeapon = None;
						break;
					}
				}
			}
		OldWeapon = DroppedWeapon;
		NewWeaponClass = OldWeapon.Class;
	}
	else if (bWeaponStay)
	{
		//if player previously had a weapon of class InventoryType, force modifier to be the same
		StatsInv = RPGStatsInv(Other.FindInventoryType(class'RPGStatsInv'));
		if (StatsInv != None)
			for (x = 0; x < StatsInv.OldRPGWeapons.length; x++)
				if (StatsInv.OldRPGWeapons[x].ModifiedClass == InventoryType)
				{
					OldWeapon = StatsInv.OldRPGWeapons[x].Weapon;
					if (OldWeapon == None)
					{
						StatsInv.OldRPGWeapons.Remove(x, 1);
						x--;
					}
					else
					{
						NewWeaponClass = OldWeapon.Class;
						StatsInv.OldRPGWeapons.Remove(x, 1);
						bRemoveReference = true;
						break;
					}
				}
	}

	if (NewWeaponClass == None)
		NewWeaponClass = RPGMut.GetRandomWeaponModifier(class<Weapon>(InventoryType), Other);

	Copy = spawn(NewWeaponClass,Other,,,rot(0,0,0));
    NewWeapon = Weapon(spawn(InventoryType,Other,,,rot(0,0,0)));
    DEKRPGWeapon(Copy).ModifiedWeapon = NewWeapon;
    if (Copy.IsA('DEKRPGWeapon'))
    {
    	DEKRPGWeapon(Copy).Generate(OldWeapon);
    	DEKRPGWeapon(Copy).SetModifiedWeapon(NewWeapon, ((bDropped && OldWeapon != None && OldWeapon.bIdentified) || RPGMut.bNoUnidentified));
    }
    else
    {
    	RPGWeapon(Copy).Generate(OldWeapon);
    	RPGWeapon(Copy).SetModifiedWeapon(Weapon(spawn(InventoryType,Other,,,rot(0,0,0))), ((bDropped && OldWeapon != None && OldWeapon.bIdentified) || RPGMut.bNoUnidentified));
    }

	Copy.GiveTo(Other, self);

	if (bRemoveReference)
		OldWeapon.RemoveReference();

	return Copy;
}

defaultproperties
{
}
