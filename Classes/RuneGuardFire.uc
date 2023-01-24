//Spawn an actor instead of a projectile
//Actor is a force field that blocks hostile projectiles
class RuneGuardFire extends RuneProjectileFire
	config(DEKWeapons);

var RuneGuard Guard;

event ModeTick(float dt)
{
	Super.ModeTick(dt);
	if (Instigator != None)
	{
		if (bIsFiring){
			if (Instigator.Controller != None && Instigator.Controller.Adrenaline <= AdrenCost && Guard != None)
			{
				if (Guard != None)
				{
                    if (RuneLaser_Guard(Weapon) != None)
					   RuneLaser_Guard(Weapon).Guard = None;
					Guard.Destroy();
                    Guard = None;
				}
			}
		}
		else{
			if (Guard != None)
			{
                if (RuneLaser_Guard(Weapon) != None)
				    RuneLaser_Guard(Weapon).Guard = None;
				Guard.Destroy();
                Guard = None;
			}
		}
	}
}

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
	if (Instigator == None || Instigator.Controller == None)
    {
        if (Guard != None)
		{
            if (RuneLaser_Guard(Weapon) != None)
			    RuneLaser_Guard(Weapon).Guard = None;
			Guard.Destroy();
            Guard = None;
		}
        
		return None;
    }

    // take the adrenaline
    if (Instigator.Weapon == None || DEKRPGWeapon(Instigator.Weapon) == None || DEKRPGWeapon(Instigator.Weapon).HasThisAddon(class'InfinityAddonPowerType') == false)
    {
    	//Check if we have enough adren
    	if (Instigator.Controller.Adrenaline < AdrenCost)
        {
            if (Guard != None)
			{
                if (RuneLaser_Guard(Weapon) != None)
				    RuneLaser_Guard(Weapon).Guard = None;
				Guard.Destroy();
                Guard = None;
			}

			return None;
        }
        
		Instigator.Controller.Adrenaline -= AdrenCost;
    }
        
    if (Guard != None)
        return None;    // we have a Guard running
	   
	//We've got enough adrenaline - good to spawn Guard
	Guard = Weapon.Spawn(Class'RuneGuard',,, Start, Instigator.GetViewRotation());
	
	if (Guard != None)
	{
		Guard.PawnOwner = Instigator;
		RuneLaser_Guard(Weapon).Guard = Guard;
	}
	
	//Not spawning a projectile here, but we need to return something
	return None;
}

defaultproperties
{
     ProjSpawnOffset=(X=150.000000,Y=0.0000,Z=0.000000)
	 AdrenCost=1.0
     bModeExclusive=False
     FireSound=SoundGroup'WeaponSounds.RocketLauncher.RocketLauncherFire'
     FireForce="RocketLauncherFire"
     FireRate=0.500000
}
