class ComboCriticalHitInv extends ComboEffectInv;

var class<xEmitter> EffectDownxEmitterClass;
var xEmitter EffectDownxEmitter;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	if (Other != None)
		PawnOwner = Other;
	
	bBuff = True;	//Always a buff
		
	default.EffectMultiplier = EffectMultiplier;	//"Initialize" for static GetLocalString function
	if (Other != None)
		Other.ReceiveLocalizedMessage(MessageClass, Lifespan, None, None, Class);
	Super.GiveTo(Other);
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	local int Percent;
	
	Percent = abs((default.EffectMultiplier - 1)*100);
	return Default.ComboNameMessage $ "+ " $ Percent $ "% chance to deal double damage for " $ Switch $ Default.SecondsMessage;
}

defaultproperties
{
	 ComboNameMessage="Critical Hit: "
     EffectDownxEmitterClass=Class'DEKRPG208AC.ComboAttackDownEffect'
     EffectxEmitterClass=Class'DEKRPG208AC.ComboAttackUpEffect'
}
