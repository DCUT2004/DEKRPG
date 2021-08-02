class ComboWardInv extends ComboEffectInv;

#exec  AUDIO IMPORT NAME="Ward" FILE="Sounds\WardFour.WAV" GROUP="ComboSounds"

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

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	local int EffectInt;
	
	EffectInt = default.EffectMultiplier;
	return Default.ComboNameMessage $ "+ " $ EffectInt $ "% to resist new ailments for " $ Switch $ Default.SecondsMessage;
}

defaultproperties
{
	 bBuff=True
	 ComboNameMessage="Ward: "
}
