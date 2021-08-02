class ComboHealthMaxInv extends ComboEffectInv;

var int NewHealthMax, OriginalHealthMax;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	local RW_MagicalWard W;
	local MagicalWardProtectionInv MWInv;
	local ComboWardInv WardInv;
	
	if (EffectMultiplier > 1.0)
		bBuff = True;
	else if (EffectMultiplier < 1.0)
		bBuff = False;
	if (Other != None)
	{
		WardInv = ComboWardInv(Other.FindInventoryType(Class'ComboWardInv'));
		if (!bBuff && WardInv != None && Rand(100) <= WardInv.EffectMultiplier)
		{
			if (Other.Controller != None && PlayerController(Other.Controller) != None)
				PlayerController(Other.Controller).ClientPlaySound(Sound'DEKRPG208AE.ComboSounds.Ward');
			Destroy();
			return;
		}
		if ( Other.Weapon != None && Other.Weapon.IsA('RW_MagicalWard') && !bBuff)
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
		default.EffectMultiplier = EffectMultiplier;
		if (Other != None)
		{
			PawnOwner = Other;
			NewHealthMax = Other.HealthMax*EffectMultiplier;
			OriginalHealthMax = Other.HealthMax;
			
			Other.HealthMax = NewHealthMax;
			Other.ReceiveLocalizedMessage(MessageClass, Lifespan, None, None, Class);
		}
	}
	Super.GiveTo(Other);
}

function Timer()
{
	if (EffectMultiplier > 1.0)
		bBuff = True;
	if (EffectMultiplier < 1.0)
		bBuff = False;
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	local int Percent;
	
	Percent = abs((default.EffectMultiplier - 1)*100);
	
	if (default.EffectMultiplier > 1.0)
		return Default.ComboNameMessage $ "+ " $ Percent $ "% for " $ Switch $ Default.SecondsMessage;
	else if (default.EffectMultiplier < 1.0)
		return Default.ComboNameMessage $ "- " $ Percent $ "% for " $ Switch $ Default.SecondsMessage;
}

simulated function Destroyed()
{
	if (PawnOwner != None && PawnOwner.Health > 0)
		PawnOwner.HealthMax = OriginalHealthMax;
	Super.Destroyed();
}

defaultproperties
{
	 ComboNameMessage="Max Health: "
}
