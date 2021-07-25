class ComboDefenseGazeInv extends ComboEffectInv;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	local RW_MagicalWard W;
	local MagicalWardProtectionInv MWInv;
	
	bBuff = False;

	if (Other != None && Other.Weapon != None && Other.Weapon.IsA('RW_MagicalWard') && !bBuff)
	{
		W = RW_MagicalWard(Other.Weapon);
		if (Rand(100) <= W.Modifier*W.ChanceToWardPerModifier)
		{
			MWInv = MagicalWardProtectionInv(Other.FindInventoryType(class'MagicalWardProtectionInv'));
			if (MWInv == None)
			{
				MWInv = Other.Spawn(Class'MagicalWardProtectionInv');
				MWInv.GiveTo(Other);
			}
			else
			{
				MWInv.Lifespan = MWInv.default.Lifespan;
				MWInv.ProtectionMultiplier -= MWInv.ProtectionPerWardMultiplier;
				if (MWInv.ProtectionMultiplier < MWInv.MaxProtectionMultiplier)
					MWInv.ProtectionMultiplier = MWInv.MaxProtectionMultiplier;
			}
			Destroy();
			return;
		}
	}
	Super.GiveTo(Other);
}

defaultproperties
{
	 bBuff=False
     EffectEmitterClass=Class'DEKRPG208AB.ComboDefenseDownEffect'
}
