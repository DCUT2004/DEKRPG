class StatusEffect_DamageReduction extends StatusEffect
	config(UT2004RPG);

var Emitter FX;
var Class<Emitter> EmitterBuffFX, EmitterAilmentFX;

function StartEffect(Pawn Target)
{
	if (Target != None)
	{
		if (Modifier > 0)
			SpawnFX(EmitterBuffFX);
		else if (Modifier < 0)
			SpawnFX(EmitterAilmentFX);
	}
	SetTimer(1, True);
}

function SpawnFX(Class<Emitter> FXClass)
{
	FX = Instigator.Spawn(FXClass, Instigator, , Instigator.Location);
	if (FX != None)
	{
		FX.bHardAttach = True;
		FX.SetBase(Instigator);
	}
}

function Timer()
{
	if (Instigator != None && FX != None)
	{
		if (Modifier > 0 && FX.Class == EmitterAilmentFX)		//Change xEmitter to buff
		{
			FX.Destroy();
			SpawnFX(EmitterBuffFX);
		}
		else if (Modifier < 0 && FX.Class == EmitterBuffFX)	//Change xEmitter to ailment
		{
			FX.Destroy();
			SpawnFX(EmitterAilmentFX);
		}
	}
}

function StopEffect(Pawn Target)
{
	if (FX != None)
	{
		FX.Kill();
		FX.Destroy();
	}
}

defaultproperties
{
	StatusEffectName="Defense"
	MaxModifier=10
	EmitterAilmentFX=Class'DEKRPG999X.ComboDefenseDownEffect'
	EmitterBuffFX=Class'DEKRPG999X.ComboDefenseUpEffect'
}
