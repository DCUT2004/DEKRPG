class OffenseCombo_Strike extends OffenseCombo
	config(UT2004RPG);

function DoDamage(Pawn Target)
{
	local Actor FX;
	if (Target == None || Target.Health <= 0 || Target.Controller == None)
		return;
	
	FX = Target.Spawn(class'RocketExplosion', Target);
	if (FX != None)
		FX.RemoteRole = ROLE_SimulatedProxy;
	Target.PlaySound(sound'WeaponSounds.BExplosion3',,1.5*Target.TransientSoundVolume,,Target.TransientSoundRadius);
	Target.TakeDamage(DamagePerHit, Instigator, Target.Location, Vect(0,0,0), DamageType);
}

defaultproperties
{
}
