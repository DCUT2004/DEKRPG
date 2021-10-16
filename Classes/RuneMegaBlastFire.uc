class RuneMegaBlastFire extends RuneProjectileFire
	config(DEKWeapons);
	
var Sound HoldSound;
var config float MaxChargeLoad;
var float ChargeLoad;
var float ChargeUpRate;
var float EOFireRate;
var bool bBerserkStarted;
var config float Range;
	
function ModeHoldFire()
{
	Super.ModeHoldFire();
	GotoState('Hold');
}

state Hold
{
    simulated function BeginState()
    {
		ChargeLoad = 0;
        SetTimer(ChargeUpRate, true);
        Weapon.PlayOwnedSound(Sound'ONSVehicleSounds-S.PRV.PRVChargeUp',SLOT_Interact,TransientSoundVolume);
        Timer();
    }

    simulated function Timer()
    {
		ChargeLoad = ChargeLoad + 1.000;
        
		Instigator.Controller.Adrenaline -= AdrenCost;

		if (ChargeLoad == MaxChargeLoad || Instigator.Controller.Adrenaline < AdrenCost) //holding a max charge now.
        {
            SetTimer(0.0, false);
			Instigator.AmbientSound = Sound'ONSVehicleSounds-S.PRV.PRVChargeLoop';
			Instigator.SoundRadius = 150;
			Instigator.SoundVolume = 150;
			FireSound = Sound'ONSVehicleSounds-S.PRV.PRVFire04';
        }
		else
			FireSound = Default.FireSound;
    }

    simulated function EndState()
    {
		if ( (Instigator != None) && (Instigator.AmbientSound == Sound'ONSVehicleSounds-S.PRV.PRVChargeLoop') )
			Instigator.AmbientSound = None;
		
		Instigator.SoundRadius = Instigator.Default.SoundRadius;
		Instigator.SoundVolume = Instigator.Default.SoundVolume;
    }
}

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
	local Vector HitLocation, HitNormal;
    local MegaCharger p;
	local vector End;
	local Actor Other;
	local Vector SpawnLocation;
	
	if (Instigator == None || Instigator.Controller == None)
		return None;
		
	GotoState('');
	
	End = Start + Vector(Dir)*Range;
	
	Other = Weapon.Trace(HitLocation, HitNormal, End, Start, true);
	if (Other != None)
		SpawnLocation = HitLocation;
	else
		SpawnLocation = End;
	//No need to check for adrenaline, or reduce adrenaline, since that was consumed while charging up
    
	if (ChargeLoad > 0)
		p = Spawn(Class'MegaCharger', Instigator.Controller,, SpawnLocation, Dir);
	if (P != None)
	{
		p.ChargeLoad = ChargeLoad;
		p.Damage *= ChargeLoad;
		p.DamageRadius *= ChargeLoad;
		Log("In RuneMegaBlastFire: ChargeLoad is " $ ChargeLoad);
	}
    return None;
}

function StartBerserk()
{
    if ( !bBerserkStarted )
	{
		EOFireRate = FireRate;
	
		FireRate = FireRate * 0.75;
		FireAnimRate = default.FireAnimRate/0.75;
		ReloadAnimRate = default.ReloadAnimRate/0.75;
		bBerserkStarted = true;
	}
}

function StopBerserk()
{
    super.StopBerserk();
    if ( EOFireRate != 0 )
		FireRate = EOFireRate;

	bBerserkStarted = false;
}

function StartSuperBerserk()
{
    FireRate = FireRate/Level.GRI.WeaponBerserk;
    FireAnimRate = default.FireAnimRate * Level.GRI.WeaponBerserk;
    ReloadAnimRate = default.ReloadAnimRate * Level.GRI.WeaponBerserk;
}

defaultproperties
{
	 AdrenCost=25
	 Range=1500.0000000
     ChargeUpRate=0.720000
     MaxChargeLoad=5
     HoldSound=Sound'ONSVehicleSounds-S.PRV.PRVChargeLoop'
     bFireOnRelease=True
     FireSound=SoundGroup'WeaponSounds.RocketLauncher.RocketLauncherFire'
     FireForce="RocketLauncherFire"
     FireRate=1.000000
}
