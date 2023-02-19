class AASentinelFire extends FM_Sentinel_Fire;

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
	local Projectile p;

	if (Instigator.GetTeamNum() == 255)
		p = Weapon.Spawn(TeamProjectileClasses[0], Instigator, , Start, Dir);
	else
		p = Weapon.Spawn(TeamProjectileClasses[Instigator.GetTeamNum()], Instigator, , Start, Dir);
	if ( p == None )
		return None;

	p.Damage *= DamageAtten;
	
	if (Instigator != None && Instigator.Controller != None && AASentinelController(Instigator.Controller) != None)
	{
		p.Damage *= AASentinelController(Instigator.Controller).DamageAdjust;		// set by LoadedEngineer
        if (AARocketProjectile(p) != None)
        {
            AARocketProjectile(p).HomingTarget = AASentinelController(Instigator.Controller).Enemy;
        }
	}
	
	return p;
}

defaultproperties
{
     TeamProjectileClasses(0)=Class'DEKRPG999X.AARocketProjectile'
     TeamProjectileClasses(1)=Class'DEKRPG999X.AARocketProjectile'
     FireRate=0.500000
}
