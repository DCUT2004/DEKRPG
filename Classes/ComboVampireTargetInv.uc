//Enemy heals every time Owner takes damage. Used with Dreaded Gaze
class ComboVampireTargetInv extends ComboEffectInv;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	local RW_MagicalWard W;
	local MagicalWardProtectionInv MWInv;
	local ComboWardInv WardInv;
	
	bBuff = False;
	if (Other != None)
	{
		WardInv = ComboWardInv(Other.FindInventoryType(Class'ComboWardInv'));
		if (WardInv != None && Rand(100) <= WardInv.EffectMultiplier)
		{
			if (Other.Controller != None && PlayerController(Other.Controller) != None)
				PlayerController(Other.Controller).ClientPlaySound(Sound'DEKRPG208AE.ComboSounds.Ward');
			Destroy();
			return;
		}
		if (Other.Weapon != None && Other.Weapon.IsA('RW_MagicalWard') && !bBuff)
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
				if (Other.Controller != None && PlayerController(Other.Controller) != None)
					PlayerController(Other.Controller).ClientPlaySound(Sound'DEKRPG208AE.ComboSounds.Ward');
				Destroy();
				return;
			}
		}
	}
	Super.GiveTo(Other);
}

defaultproperties
{
	 bBuff=False
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
