class ComboRegenerateInv extends ComboEffectInv
	config(UT2004RPG);

var MissionSoloInv MInv;
var config float MaxMultiplier;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	default.EffectMultiplier = EffectMultiplier;	//"Initialize" for static GetLocalString function
	bBuff = True;
	if (Other != None)
	{
		Other.ReceiveLocalizedMessage(MessageClass, Lifespan, None, None, Class);
		MInv = MissionSoloInv(Other.FindInventoryType(class'MissionSoloInv'));
	}
	Super.GiveTo(Other);
}

function Timer()
{
	if (PawnOwner != None)
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
		PawnOwner.GiveHealth(EffectMultiplier, PawnOwner.Health + EffectMultiplier);
		if (PawnOwner.Health > PawnOwner.HealthMax*MaxMultiplier)
			PawnOwner.Health = PawnOwner.HealthMax*MaxMultiplier;
		if (MInv != None && MInv.LifeMendActive)
		{
			MInv.MissionCount += EffectMultiplier;
		}
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
	 MaxMultiplier=2.00000
	 bBuff=True
	 ComboNameMessage="Regenerate: "
     EffectxEmitterClass=Class'XEffects.RegenCrosses'
}
