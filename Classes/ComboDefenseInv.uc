class ComboDefenseInv extends ComboEffectInv;

var class<Emitter> EffectDownEmitterClass;
var Emitter EffectDownEmitter;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	local RW_MagicalWard W;
	local MagicalWardProtectionInv MWInv;
	local ComboWardInv WardInv;
	
	if (EffectMultiplier > 1.0)
		bBuff = False;
	else if (EffectMultiplier < 1.0)
		bBuff = True;
	if (Other != None)
	{
		WardInv = ComboWardInv(Other.FindInventoryType(Class'ComboWardInv'));
		if (!bBuff && WardInv != None && Rand(100) <= WardInv.EffectMultiplier)
		{
			if (Other.Controller != None && PlayerController(Other.Controller) != None)
				PlayerController(Other.Controller).ClientPlaySound(Sound'DEKRPG208AH.ComboSounds.Ward');
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
					PlayerController(Other.Controller).ClientPlaySound(Sound'DEKRPG208AH.ComboSounds.Ward');
				Destroy();
				return;
			}
		}
		default.EffectMultiplier = EffectMultiplier;	//"Initialize" for static GetLocalString function
		Other.ReceiveLocalizedMessage(MessageClass, Lifespan, None, None, Class);
	}
	Super.GiveTo(Other);
}

function Timer()
{
	if (EffectMultiplier > 1.0)
	{
		bBuff = False;
	}
	else if (EffectMultiplier < 1.0)
	{
		bBuff = True;
	}
	if (PawnOwner != None)
	{
		if (EffectMultiplier > 1.0 && EffectDownEmitter == None)
		{
			EffectDownEmitter = PawnOwner.Spawn(EffectDownEmitterClass, PawnOwner,,PawnOwner.Location);
			if (EffectDownEmitter != None)
			{
				EffectDownEmitter.bHardAttach = True;
				EffectDownEmitter.SetBase(PawnOwner);
			}
			if (EffectEmitter != None)
				EffectEmitter.Destroy();
		}
		else if (EffectMultiplier < 1.0 && EffectEmitter == None)
		{
			EffectEmitter = PawnOwner.Spawn(EffectEmitterClass, PawnOwner,,PawnOwner.Location);
			if (EffectEmitter != None)
			{
				EffectEmitter.bHardAttach = True;
				EffectEmitter.SetBase(PawnOwner);
			}
			if (EffectDownEmitter != None)
				EffectDownEmitter.Destroy();
		}
		else if (EffectMultiplier == 1.0)
		{
			if (EffectDownEmitter != None)
				EffectDownEmitter.Destroy();
			if (EffectEmitter != None)
				EffectEmitter.Destroy();
		}
	}
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	local int Percent;
	
	Percent = abs((default.EffectMultiplier - 1)*100);
	if (default.EffectMultiplier > 1.0)	//Defense down
		return Default.ComboNameMessage $ "- " $ Percent $ "% for " $ Switch $ Default.SecondsMessage;
	else if (default.EffectMultiplier < 1.0)	//Defense Up
		return Default.ComboNameMessage $ "+ " $ Percent $ "% for " $ Switch $ Default.SecondsMessage;
	else
		return Super.GetLocalString(Switch, RelatedPRI_1, RelatedPRI_2);
}

simulated function Destroyed()
{
	if (EffectEmitter != None)
		EffectEmitter.Destroy();
	if (EffectDownEmitter != None)
		EffectDownEmitter.Destroy();
	Super.Destroyed();
}

defaultproperties
{
	 ComboNameMessage="Defense: "
     EffectDownEmitterClass=Class'DEKRPG208AH.ComboDefenseDownEffect'
     EffectEmitterClass=Class'DEKRPG208AH.ComboDefenseUpEffect'
}
