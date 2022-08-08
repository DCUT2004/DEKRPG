class ComboRegenerateInv extends ComboEffectInv
	config(UT2004RPG);
const LIFEMEND = "Life Mend";
var MissionInvBETA MissionInv;
var config float MaxMultiplier;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	default.EffectMultiplier = EffectMultiplier;	//"Initialize" for static GetLocalString function
	bBuff = True;
	if (Other != None)
	{
		Other.ReceiveLocalizedMessage(MessageClass, Lifespan, None, None, Class);
		if (Other.Controller != None)
			MissionInv = Class'MissionInvBETA'.static.GetMissionInv(Other.Controller);
	}
	Super.GiveTo(Other);
}

function Timer()
{
	if (PawnOwner != None)
	{
		PawnOwner.GiveHealth(EffectMultiplier, PawnOwner.Health + EffectMultiplier);
		if (PawnOwner.Health > PawnOwner.HealthMax*MaxMultiplier)
			PawnOwner.Health = PawnOwner.HealthMax*MaxMultiplier;
		if (MissionInv != None && MissionInv.IsMissionActive(LIFEMEND))
			MissionInv.TickMission(MissionInv.GetMissionIndex(LIFEMEND), 1);
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
