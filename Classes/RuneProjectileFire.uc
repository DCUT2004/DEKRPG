class RuneProjectileFire extends ProjectileFire
	config(DEKWeapons);

var config int AdrenCost;

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile p;
	
	if (Instigator == None || Instigator.Controller == None)
		return None;
	
	//Check if we have enough adren
	if (Instigator.Controller.Adrenaline < AdrenCost)
		return None;
    
	//We've got enough adrenaline - good to spawn projectile
    if( ProjectileClass != None )
        p = Weapon.Spawn(ProjectileClass,,, Start, Dir);

    if( p == None )
        return None;

    p.Damage *= DamageAtten;
	Instigator.Controller.Adrenaline -= AdrenCost;
    return p;
}

defaultproperties
{
     ProjSpawnOffset=(X=25.000000,Y=6.000000,Z=-6.000000)
     TweenTime=0.000000
     AmmoClass=Class'DEKRPG209A.RuneAmmo'
     AmmoPerFire=0
}
