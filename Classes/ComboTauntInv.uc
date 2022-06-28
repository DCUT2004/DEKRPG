class ComboTauntInv extends ComboEffectInv;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	default.EffectMultiplier = EffectMultiplier;	//"Initialize" for static GetLocalString function
	
	if (Other != None)
		Other.ReceiveLocalizedMessage(MessageClass, Lifespan, None, None, Class);
	Super.GiveTo(Other);
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	local int EffectInt;
	
	EffectInt = default.EffectMultiplier;
	return Default.ComboNameMessage $ (EffectInt*100) $ " damage for " $ Switch $ Default.SecondsMessage;
}

defaultproperties
{
	 bBuff=True
	 ComboNameMessage="+ Taunt: Absorb "
     EffectEmitterClass=Class'DEKRPG209E.ComboTauntEffect'
}
