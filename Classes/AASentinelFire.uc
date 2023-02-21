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
    p.Damage = class'BaseInstantFire'.static.UpdateDamageDueToLevel(Instigator, p.Damage);
    // Log("+++++ AASentinelFire Damage now" @ p.Damage @ "default is" @ p.Default.Damage);	
	
	if (Instigator != None && Instigator.Controller != None && AASentinelController(Instigator.Controller) != None)
	{
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
