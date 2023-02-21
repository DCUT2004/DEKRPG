class FM_DruidAutoGun_Fire extends FM_Sentinel_Fire;

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
    // Log("+++++ FM_DruidAutoGun_Fire Damage now" @ p.Damage @ "default is" @ p.Default.Damage);	
	
	return p;
}

defaultproperties
{
     TeamProjectileClasses(0)=Class'DEKRPG999X.PROJ_AutoGun_Laser_Red'
     TeamProjectileClasses(1)=Class'DEKRPG999X.PROJ_AutoGun_Laser'
     FireRate=0.450000
}
