class ComboWardInv extends ComboEffectInv;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	default.EffectMultiplier = EffectMultiplier;	//"Initialize" for static GetLocalString function
	bBuff = True;
	if (Other != None)
	{
		Other.ReceiveLocalizedMessage(MessageClass, Lifespan, None, None, Class);
	}
	Super.GiveTo(Other);
}

function Timer()
{
	if (PawnOwner != None)
	{
		PawnOwner.GiveHealth(EffectMultiplier, PawnOwner.Health + EffectMultiplier);
		if (PawnOwner.Controller != None && PlayerController(PawnOwner.Controller) != None)
			PlayerController(PawnOwner.Controller).ClientPlaySound(Sound'PickupSounds.HealthPack');
	}
	Super.Timer();
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	local int EffectInt;
	
	EffectInt = default.EffectMultiplier;
	return Default.ComboNameMessage $ "+ " $ EffectInt $ "HP for " $ Switch $ Default.SecondsMessage;
}

defaultproperties
{
	 bBuff=True
	 ComboNameMessage="Regenerate: "
     EffectxEmitterClass=Class'XEffects.RegenCrosses'
}
