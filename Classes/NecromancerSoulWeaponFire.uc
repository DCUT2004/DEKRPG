class NecromancerSoulWeaponFire extends ProjectileFire;

var Pawn Victim;
var config float SoulDamage, Range;

simulated function bool AllowFire()
{
	local Vector FaceDir;
	local Vector BeamEndLocation;
	local vector HitLocation;
	local vector HitNormal;
	local Actor AHit;
	local Pawn  HitPawn;
	local Vector StartTrace;
	
	FaceDir = Vector(Instigator.Controller.GetViewRotation());
	StartTrace = Instigator.Location + Instigator.EyePosition();
	BeamEndLocation = StartTrace + (FaceDir * Range);

	AHit = Trace(HitLocation, HitNormal, BeamEndLocation, StartTrace, true);

	if ((AHit == None) || (Pawn(AHit) == None) || (Pawn(AHit).Controller == None))
	{
		HitPawn = None;
	}
	HitPawn = Pawn(AHit);
	
	if (HitPawn != None)
	{
		Victim = HitPawn;
		return True;
	}
	else
		return False;
	
	return Super.AllowFire();
}

function DoFireEffect()
{
	local SoulParticle SFX, SFX2;
	local vector FX2Radius;
	
	if (Victim != None && Victim.Health > 0)
	{
		Victim.TakeDamage(SoulDamage, Instigator, Victim.Location, vect(0,0,0), class'DamTypeNecromancerSoulWeapon');
		Victim.Spawn(class'EnergyStealFX',,,Victim.Location);
		FX2Radius.X=Victim.Location.X+-5+FRand();
		FX2Radius.Y=Victim.Location.Y+-5+FRand();
		FX2Radius.Z=Victim.Location.Z+-5+FRand();
		SFX = Spawn(class'SoulParticle',,,Victim.Location);
		SFX.Seeking = Instigator;
		SFX2 = Spawn(class'SoulParticle',,,FX2Radius);
		SFX2.Seeking = Instigator;
	}
	if (Instigator != None)
	{
		Instigator.GiveHealth(SoulDamage, Instigator.HealthMax);
	}
}

defaultproperties
{
     SoulDamage=5.000000
     Range=2000.000000
     bModeExclusive=False
     TransientSoundVolume=0.400000
     FireRate=0.200000
     AmmoClass=Class'DEKRPG208AF.NecromancerSoulWeaponAmmo'
     AmmoPerFire=5
     BotRefireRate=0.350000
}
