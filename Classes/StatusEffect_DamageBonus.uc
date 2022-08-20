class StatusEffect_DamageBonus extends StatusEffect
	config(UT2004RPG);

var xEmitter FX;

function StartEffect(Pawn Target)
{
	if (Target != None)
	{
		if (Modifier > 0)
			SpawnFX(xEmitterBuffFX);
		else if (Modifier < 0)
			SpawnFX(xEmitterAilmentFX);
	}
	SetTimer(1, True);
}

function SpawnFX(Class<xEmitter> FXClass)
{
	FX = Instigator.Spawn(FXClass, Instigator, , Instigator.Location);
	if (FX != None)
	{
		FX.bHardAttach = True;
		FX.SetBase(Instigator);
		FX.mSizeRange[0] = Instigator.CollisionRadius * 0.05;
		FX.mSizeRange[1] =1.571 * Instigator.CollisionRadius * 0.05;
	}
}

function Timer()
{
	if (Instigator != None && FX != None)
	{
		if (Modifier > 0 && FX.Class == xEmitterAilmentFX)		//Change xEmitter to buff
		{
			FX.Destroy();
			SpawnFX(xEmitterBuffFX);
		}
		else if (Modifier < 0 && FX.Class == xEmitterBuffFX)	//Change xEmitter to ailment
		{
			FX.Destroy();
			SpawnFX(xEmitterAilmentFX);
		}
	}
}

function StopEffect(Pawn Target)
{
	if (FX != None)
		FX.Destroy();
}

defaultproperties
{
	StatusEffectName="Attack"
	MaxModifier=10
	xEmitterAilmentFX=Class'DEKRPG999X.ComboAttackDownEffect'
	xEmitterBuffFX=Class'DEKRPG999X.ComboAttackUpEffect'
}
