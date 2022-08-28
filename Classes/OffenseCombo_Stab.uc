class OffenseCombo_Stab extends OffenseCombo
	config(UT2004RPG);
	
var config int InitialDamage;
var bool bDoneInitialDamage;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	bDoneInitialDamage = False;
}

function DoDamage(Pawn Target)
{
	local Actor FX;
	if (Target == None || Target.Health <= 0 || Target.Controller == None)
		return;
	
	FX = Target.Spawn(class'RocketExplosion', Target);
	if (FX != None)
		FX.RemoteRole = ROLE_SimulatedProxy;
	Target.PlaySound(sound'WeaponSounds.BExplosion3',,1.5*Target.TransientSoundVolume,,Target.TransientSoundRadius);
	
	if (!bDoneInitialDamage)
	{
		Target.TakeDamage(InitialDamage, Instigator, Target.Location, Vect(0,0,0), DamageType);
		bDoneInitialDamage = True;
	}
	
	Target.TakeDamage(DamagePerHit, Instigator, Target.Location, Vect(0,0,0), DamageType);
}

defaultproperties
{
	InitialDamage=100
}
