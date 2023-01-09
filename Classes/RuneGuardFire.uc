//Spawn an actor instead of a projectile
//Actor is a force field that blocks hostile projectiles
class RuneGuardFire extends RuneProjectileFire
	config(DEKWeapons);

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local RuneGuard Guard;
	
	if (Instigator == None || Instigator.Controller == None)
		return None;
	
	//Check if we have enough adren
	if (Instigator.Controller.Adrenaline < AdrenCost)
		return None;
    
	//We've got enough adrenaline - good to spawn Guard
	Guard = Weapon.Spawn(Class'RuneGuard',,, Start, Instigator.GetViewRotation());
	
	if (Guard != None)
	{
		Guard.PawnOwner = Instigator;
    if (Instigator.Weapon == None || DEKRPGWeapon(Instigator.Weapon) == None || DEKRPGWeapon(Instigator.Weapon).HasThisAddon(class'InfinityAddonPowerType') == false)
			Instigator.Controller.Adrenaline -= AdrenCost;
	}
	
	//Not spawning a projectile here, but we need to return something
	return None;
}

defaultproperties
{
     ProjSpawnOffset=(X=150.000000,Y=0.0000,Z=0.000000)
	 AdrenCost=7
     bModeExclusive=False
     FireSound=SoundGroup'WeaponSounds.RocketLauncher.RocketLauncherFire'
     FireForce="RocketLauncherFire"
     FireRate=11.000000
}
