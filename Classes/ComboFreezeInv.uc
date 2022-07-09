class ComboFreezeInv extends ComboEffectInv;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	local FreezeInv Inv;
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
				PlayerController(Other.Controller).ClientPlaySound(Sound'DEKRPG209F.ComboSounds.Ward');
			Destroy();
			return;
		}
		if (Other.Weapon != None && Other.Weapon.IsA('RW_MagicalWard'))
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
					PlayerController(Other.Controller).ClientPlaySound(Sound'DEKRPG209F.ComboSounds.Ward');
				Destroy();
				return;
			}
		}
		Inv = FreezeInv(Other.FindInventoryType(class'FreezeInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'FreezeInv');
			Inv.Lifespan = Lifespan;
			Inv.Modifier =  EffectMultiplier;
			Inv.GiveTo(Other);
		}
		else
		{
			if (Inv.Lifespan < Lifespan)
				Inv.Lifespan= Lifespan;
			if (Inv.Modifier < EffectMultiplier)
				Inv.Modifier = EffectMultiplier;
		}
		Other.ReceiveLocalizedMessage(MessageClass, Lifespan, None, None, Class);
	}
	Super.GiveTo(Other);
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	return Default.ComboNameMessage $ Switch $ Default.SecondsMessage;
}

defaultproperties
{
	 bBuff=False
	 ComboNameMessage="- Freeze: "
}
