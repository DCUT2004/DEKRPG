class ComboRegenerateAdrenInv extends ComboEffectInv;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	
	default.EffectMultiplier = EffectMultiplier;	//"Initialize" for static GetLocalString function
	bBuff = True;
	
	Other.ReceiveLocalizedMessage(MessageClass, Lifespan, None, None, Class);

	Super.GiveTo(Other);
}

function Timer()
{
	if (PawnOwner != None && PawnOwner.Controller != None)
	{
		/*if(EffectxEmitter == None)
		{
			EffectxEmitter = PawnOwner.Spawn(EffectxEmitterClass, PawnOwner,,PawnOwner.Location);
			if (EffectxEmitter != None)
			{
				EffectxEmitter.bHardAttach = True;
				EffectxEmitter.SetBase(PawnOwner);
				EffectxEmitter.mSizeRange[0] = (PawnOwner.CollisionRadius*0.3);
				EffectxEmitter.mSizeRange[1] = (PawnOwner.CollisionRadius*0.3);
			}
		}*/
		PawnOwner.Controller.AwardAdrenaline(EffectMultiplier);
		if (PlayerController(PawnOwner.Controller) != None)
		PlayerController(PawnOwner.Controller).ClientPlaySound(Sound'AdrenelinPickup');
	}
	Super.Timer();
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	local int EffectInt;
	
	EffectInt = default.EffectMultiplier;
	return Default.ComboNameMessage $ " for " $ Switch $ " seconds";
}

defaultproperties
{
	 bBuff=True
	 ComboNameMessage="+ Adren Drip"
     EffectxEmitterClass=Class'DEKRPG208AA.ComboRegenerateAdrenEffect'
}
