class RuneEnergyStealLanceFire extends RuneInstantFire
	config(DEKWeapons);
	
var config int AdrenAddPerHit;
var int Counter;
var config int Threshold;
var OrangeGlow Glow;

#exec  AUDIO IMPORT NAME="EnergyStealAmbient" FILE="Sounds\EnergyStealPrimary.WAV" GROUP="RuneSounds"

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	Counter = 0;
}

event ModeTick(float dt)
{
	Super.ModeTick(dt);
	if (Instigator != None)
	{
		if (bIsFiring)
		{

			if (Glow == None)
			{
				Glow = Instigator.Spawn(Class'OrangeGlow', Instigator, , Instigator.Location);
				if (Glow != None)
					Glow.SetBase(Instigator);
			}
			if (Instigator.AmbientSound == None)
			{
				Instigator.AmbientSound = Sound'DEKRPG209F.RuneSounds.EnergyStealAmbient';
				Instigator.SoundRadius = 150;
				Instigator.SoundVolume = 150;
			}
		}
		else
		{
			if (Glow != None)
				Glow.Destroy();
			if (Instigator.AmbientSound == Sound'DEKRPG209F.RuneSounds.EnergyStealAmbient')
			{
				Instigator.AmbientSound = None;
			
				Instigator.SoundRadius = Instigator.Default.SoundRadius;
				Instigator.SoundVolume = Instigator.Default.SoundVolume;
			}
		}
	}
}
	
function DoTrace(Vector Start, Rotator Dir)
{
    local Vector X, End, HitLocation, HitNormal;
	local Actor Other;
	local int Damage;
	local AdrenParticle FX;
	
	if (Instigator == None || Instigator.Controller == None)
		return;

	MaxRange();
	X = Vector(Dir);
	End = Start + TraceRange * X;
	Counter++;
	
	Other = Weapon.Trace(HitLocation, HitNormal, End, Start, true);
	if (Other != None)
	{
		if (Pawn(Other) != None && Pawn(Other).Health > 0 && Pawn(Other).GetTeamNum() != Instigator.GetTeamNum())
		{
			Damage = DamageMin;
			if ( (DamageMin != DamageMax) && (FRand() > 0.5) )
				Damage += Rand(1 + DamageMax - DamageMin);
			Damage = Damage * DamageAtten;
			Pawn(Other).TakeDamage(Damage, Instigator, HitLocation, Momentum*X, DamageType);
			
			if (Counter >= Threshold)
			{
				Instigator.Controller.Adrenaline += AdrenAddPerHit;
				Instigator.PlaySound(Sound'PickupSounds.AdrenelinPickup',, 1.5 * Instigator.TransientSoundVolume,, 1.5 * Instigator.TransientSoundRadius);
				FX = Spawn(Class'AdrenParticle', Instigator, , Pawn(Other).Location, RotRand());
				if (FX != None)
					FX.Seeking = Instigator;
				Counter = 0;
			}
		}
	}
}

defaultproperties
{
	 Threshold=3
	 AdrenAddPerHit=2
     bModeExclusive=False
     DamageType=Class'DEKRPG209F.DamTypeRuneEnergySteal'
	 AdrenCost=0
	 DamageMin=5
	 DamageMax=7
     FireRate=0.2000000
     //FireSound=Sound'ONSVehicleSounds-S.LaserSounds.Laser09'
     bReflective=False
     TraceRange=3000.000000
     Momentum=0.000000
     AmmoPerFire=1
     AmmoClass=Class'DEKRPG209F.RuneEnergyAmmo'
}
