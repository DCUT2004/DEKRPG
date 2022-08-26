class StatusEffect_MagicalWard extends StatusEffect
	config(UT2004RPG);

var config int WardChancePerModifier;
var Emitter FX;
var Class<Emitter> FXClass;

function StartEffect(Pawn Target)
{
	if (Target != None)
	{
		FX = Target.Spawn(FXClass, Target,,Target.Location);
		if (FX != None)
			FX.SetBase(Target);
	}
}

//Called by owning Pawn's StatusEffectInventory when successfully warded an ailment
function PlayWardEffect()
{
	if (Instigator != None && Instigator.Controller != None && PlayerController(Instigator.Controller) != None)
		PlayerController(Instigator.Controller).ClientPlaySound(Sound'DEKRPG999X.ComboSounds.Ward');
}

function StopEffect(Pawn Target)
{
	if (FX != None)
		FX.Destroy();
}

defaultproperties
{
	FXClass=Class'DEKRPG999X.GenomeProjectNodeFX'
	WardChancePerModifier=10
	bOnlyPositiveModifier=True
	MaxModifier=10
}
