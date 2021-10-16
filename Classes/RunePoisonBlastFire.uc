class RunePoisonBlastFire extends RuneMegaBlastFire
	config(UT2004RPG);
	
var config float MinDrain, MaxDrain, DrainTime;

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
	local Vector HitLocation, HitNormal;
    local PoisonBlastCharger p;
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
		p = Instigator.Spawn(Class'PoisonBlastCharger', Instigator.Controller,, SpawnLocation, Dir);
	if (P != None)
	{
		p.ChargeLoad = ChargeLoad;
		p.MinDrain = MinDrain*ChargeLoad;
		p.MaxDrain = MaxDrain*ChargeLoad;
		p.DrainTIme = DrainTime;
	}
    return None;
}
defaultproperties
{
	 AdrenCost=15
	 MinDrain=5
	 MaxDrain=15
	 DrainTime=5
	 Range=1500.0000000
     ChargeUpRate=0.720000
     MaxChargeLoad=5
     HoldSound=Sound'ONSVehicleSounds-S.PRV.PRVChargeLoop'
     FireSound=SoundGroup'WeaponSounds.RocketLauncher.RocketLauncherFire'
}
