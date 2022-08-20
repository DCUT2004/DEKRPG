class StatusEffect_Regeneration extends StatusEffect
	config(UT2004RPG);
	
var xEmitter FX;

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
			Instigator.GiveHealth(Modifier*2, Instigator.Healthmax);
		else
			Instigator.GiveHealth(Modifier, Instigator.Healthmax);
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
	StatusEffectName="Regeneration"
	MaxModifier=10
	xEmitterBuffFX=Class'XEffects.RegenCrosses'
	bOnlyPositiveModifier=True
}
