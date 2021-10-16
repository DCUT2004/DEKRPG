class RuneStreakFire extends RuneProjectileFire
	config(DEKWeapons);
	
var config float LockAim;
var Array < Class <RuneStreakProj> > Projectiles;
var config float TrackRange;
	
function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local RuneStreakProj p;
	local Rotator rot, rotTarget;
	local float BestAim, BestDist;
	local int x;
	
	if (Instigator == None || Instigator.Controller == None)
		return None;
	
	//Check if we have enough adren
	if (Instigator.Controller.Adrenaline < AdrenCost)
		return None;
    
	//We've got enough adrenaline - good to spawn projectile
	rot = Instigator.Controller.GetViewRotation();
	rot.yaw += FRand()*12000-6000;
	rot.roll += FRand()*12000-6000;
	rotTarget = rot;
	rotTarget.pitch -= 10000;
		
	x = RandRange(0, Projectiles.Length);
	p = Weapon.Spawn(Projectiles[x],,,Instigator.Location ,rot);

    if( p == None )
        return None;

	BestAim = LockAim;
	p.Seeking = Instigator.Controller.PickTarget(BestAim, BestDist, vector(rotTarget), Instigator.Location, TrackRange);
    p.Damage *= DamageAtten;
	Instigator.Controller.Adrenaline -= AdrenCost;
    return p;
}

defaultproperties
{
     TrackRange=90000.000000
     LockAim=0.000010
	 AdrenCost=10
     bSplashDamage=True
     bSplashJump=True
     bRecommendSplashDamage=True
     FireSound=Sound'ONSBPSounds.Artillery.ShellAmbient'
     FireForce="RocketLauncherFire"
     FireRate=1.000000
     //ProjectileClass=Class'DEKRPG209B.RuneStreakProj'
	 Projectiles(0)=Class'DEKRPG209B.RuneStreakProjBlue'
	 Projectiles(1)=Class'DEKRPG209B.RuneStreakProjRed'
	 Projectiles(2)=Class'DEKRPG209B.RuneStreakProjGreen'
}
