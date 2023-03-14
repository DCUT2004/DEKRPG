class FM_DruidSentinel_Fire extends FM_Sentinel_Fire;

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
    // Log("+++++ FM_DruidSentinel_Fire Damage now" @ p.Damage @ "default is" @ p.Default.Damage);	
	
	return p;
}

defaultproperties
{
     TeamProjectileClasses(0)=Class'DEKRPG999X.PROJ_BlasterSent'
     TeamProjectileClasses(1)=Class'DEKRPG999X.PROJ_BlasterSent'
     FireRate=0.500000
}
