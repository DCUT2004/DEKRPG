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
	}

	return Super.SpawnCopy( Other );

}

defaultproperties
{
}
