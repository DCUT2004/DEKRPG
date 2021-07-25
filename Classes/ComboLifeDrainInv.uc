class ComboLifeDrainInv extends ComboEffectInv;

var config int MinimumHealth;

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
	default.EffectMultiplier = EffectMultiplier;	//"Initialize" for static GetLocalString function
	
	if (Other != None)
		Other.ReceiveLocalizedMessage(MessageClass, Lifespan, None, None, Class);
	Super.GiveTo(Other);
}

function Timer()
{
	local int DrainDamage;
	
	if (PawnOwner != None && PawnOwner.Health > MinimumHealth)
	{
		DrainDamage = PawnOwner.Health * EffectMultiplier;
		PawnOwner.Health -= DrainDamage; 	//Do it this way and not TakeDamage() to ignore damage reduction
		if (Enemy != None)
			Enemy.GiveHealth(DrainDamage, Enemy.HealthMax);
	}
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	local int EffectInt;
	
	EffectInt = default.EffectMultiplier;
	
	return Default.ComboNameMessage $ "Lose " $ EffectInt*100 $ "% HP/sec for " $ Switch $ Default.SecondsMessage;
}

defaultproperties
{
	 bBuff=False
	 ComboNameMessage="- Life Drain: "
	 MinimumHealth=50
     EffectEmitterClass=Class'DEKRPG208AB.ComboInaccuracyEffect'
}
