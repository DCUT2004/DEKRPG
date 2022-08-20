class StatusEffect_Parasite extends StatusEffect
	config(UT2004RPG);
	
var int Health;
var int HealthMax;
var config int StartingHealth;

function StartEffect(Pawn Target)
{
	if (Target != None)
		SetHealthMax(Target);
	Health = HealthMax;
}

function SetHealthMax(Pawn Target)
{
	HealthMax = (abs(Modifier) + 3 )/10.0 * Target.HealthMax;
}

function AddHealth(int Amount)
{
	SetHealthMax(Instigator);
	Health = Min(HealthMax, Health+Amount);
}

function RemoveHealth(int Amount)
{
	Health = Max(0, Health-Amount);
	if (Health <= 0)
		Destroy();
}

function StopEffect(Pawn Target)
{

}

defaultproperties
{
	MaxModifier=10
	StatusEffectName="Parasite"
	StartingHealth=200
	bOnlyNegativeModifier=True
}
