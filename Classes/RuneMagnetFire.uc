class RuneMagnetFire extends RuneInstantFire
	config(DEKWeapons);
	
#exec  AUDIO IMPORT NAME="MagnetAltFire" FILE="Sounds\MagnetAltFire1.WAV" GROUP="RuneSounds"
	
var RuneMagnet Magnet;
var PurpleGlow Glow;

event ModeTick(float dt)
{
	Super.ModeTick(dt);
	if (Instigator != None)
	{
		if (bIsFiring){
			Instigator.AmbientSound = Sound'DEKRPG999X.RuneSounds.MagnetAltFire';
			Instigator.SoundRadius = 150;
			Instigator.SoundVolume = 1000;
			
			if (Glow == None){
				Glow = Instigator.Spawn(Class'PurpleGlow', Instigator, , Instigator.Location);
				if (Glow != None)
					Glow.SetBase(Instigator);
			}
			
			if (Instigator.Controller != None && Instigator.Controller.Adrenaline <= AdrenCost && Magnet != None)
			{
				if (Magnet != None)
				{
					Magnet.Destroy();
					RuneFlurry_Magnet(Weapon).Magnet = None;
				}
				if (Glow != None)
					Glow.Destroy();
			}
		}
		else{
			if (Magnet != None)
			{
				Magnet.Destroy();
				RuneFlurry_Magnet(Weapon).Magnet = None;
			}
			if (Glow != None)
				Glow.Destroy();
			if (Instigator.AmbientSound == Sound'DEKRPG999X.RuneSounds.MagnetAltFire'){
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
	
	if (Magnet != None)
		return;

	MaxRange();

	X = Vector(Dir);
	End = Start + TraceRange * X;
	
	Other = Weapon.Trace(HitLocation, HitNormal, End, Start, true);
	
	if (Other != None)
		Magnet = Weapon.Spawn(Class'RuneMagnet', Instigator, , HitLocation);
	else
		Magnet = Weapon.Spawn(Class'RuneMagnet', Instigator, , End);
		
	if (Magnet != None)
		RuneFlurry_Magnet(Weapon).Magnet = Magnet;
}

simulated function DestroyEffects()
{
	Super.DestroyEffects();
	if (Glow != None)
		Glow.Destroy();
}

defaultproperties
{
	 AdrenCost=2.5
	 bModeExclusive=False
     FireRate=0.500000
	 TraceRange=500.00000
}
