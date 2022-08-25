class StatusEffect_Regeneration extends StatusEffect
	config(UT2004RPG);
	
var xEmitter FX;
var config int AdditionalHealthMax;

function StartEffect(Pawn Target)
{
	SetTimer(1, True);
	FX = Instigator.Spawn(xEmitterBuffFX, Instigator,, Instigator.Location);
	if (FX != None)
	{
		FX.bHardAttach = True;
		FX.SetBase(Instigator);
	}
}

function Timer()
{
	if (Instigator != None)
	{
		if (Instigator.IsA('Monster'))
			Instigator.GiveHealth(Modifier*2, Instigator.HealthMax + AdditionalHealthMax);
		else
			Instigator.GiveHealth(Modifier, Instigator.HealthMax + AdditionalHealthMax);
	}
	if (Instigator.Controller != None && PlayerController(Instigator.Controller) != None)
		PlayerController(Instigator.Controller).ClientPlaySound(Sound'PickupSounds.HealthPack');
}

function StopEffect(Pawn Target)
{
	SetTimer(0, False);
	if (FX != None)
		FX.Destroy();
}

defaultproperties
{
	AdditionalHealthMax=100
	StatusEffectName="Regeneration"
	MaxModifier=10
	xEmitterBuffFX=Class'XEffects.RegenCrosses'
	bOnlyPositiveModifier=True
}
