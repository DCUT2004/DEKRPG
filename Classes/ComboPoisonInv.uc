class ComboPoisonInv extends ComboEffectInv;

var RPGRules RPGRules;

function PostBeginPlay()
{
	Local GameRules G;
	
	super.PostBeginPlay();
	for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
	{
		if(G.isA('RPGRules'))
		{
			RPGRules = RPGRules(G);
			break;
		}
	}

	if(RPGRules == None)
		Log("WARNING: Unable to find RPGRules in GameRules. EXP will not be properly awarded");
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	local DruidPoisonInv Inv;
	local RW_MagicalWard W;
	local MagicalWardProtectionInv MWInv;
	local ComboWardInv WardInv;
	
	bBuff = False;
	
	if (Other != None)
	{
		WardInv = ComboWardInv(Other.FindInventoryType(Class'ComboWardInv'));
		if (!bBuff && WardInv != None && Rand(100) <= WardInv.EffectMultiplier)
		{
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
				Destroy();
				return;
			}
		}
		
		Inv = DruidPoisonInv(Other.FindInventoryType(class'DruidPoisonInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'DruidPoisonInv');
			Inv.Lifespan = Lifespan;
			Inv.Modifier =  EffectMultiplier;
			if (Enemy != None)
			{
				Inv.Instigator = Enemy;
				Inv.InstigatorController = Enemy.Controller;
			}
			if (RPGRules != None)
				Inv.RPGRules = RPGRules;
			Inv.GiveTo(Other);
		}
		else
		{
			Inv.Lifespan= Lifespan;
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
	 ComboNameMessage="- Poison: "
}
