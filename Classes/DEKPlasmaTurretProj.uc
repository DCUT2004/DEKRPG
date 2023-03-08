class DEKPlasmaTurretProj extends ONSHoverBikePlasmaProjectile;

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	local RPGStatsInv StatsInv;
	local float old_xp;
    local int DriverLevel;

	if ( Instigator != None && (Other == Instigator) )
		return;

    if (Other == Owner) return;

	if ( !Other.IsA('Projectile') || Other.bProjTarget )
	{
		if ( Role == ROLE_Authority )
		{
			if ( Instigator == None || Instigator.Controller == None )
				Other.SetDelayedDamageInstigatorController( InstigatorController );

			// find the current dataobject
			if (DEKPlasmaTurret(Instigator) != None && DEKPlasmaTurret(Instigator).Driver != None)
			{
				StatsInv = RPGStatsInv(DEKPlasmaTurret(Instigator).Driver.FindInventoryType(class'RPGStatsInv'));
				if (StatsInv != None && StatsInv.DataObject != None)
				{
					old_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
					DriverLevel = StatsInv.DataObject.Level;

					if (Level.TimeSeconds > DEKPlasmaTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay && DEKPlasmaTurret(Instigator).NumHealers > 0)
						Damage = Damage * class'RW_EngineerLink'.static.DamageIncreasedByLinkers(DEKPlasmaTurret(Instigator).NumHealers);
				}
			}

			Other.TakeDamage(Damage, Instigator, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType);

            class'RW_EngineerLink'.static.DistributeHealingXP(StatsInv, DriverLevel, DEKPlasmaTurret(Instigator).Healers, old_xp, DEKPlasmaTurret(Instigator).RPGMut);
		}
		Explode(HitLocation, -Normal(Velocity));
	}
}

defaultproperties
{
     Damage=39.000000
     DamageRadius=0.000000
     MyDamageType=Class'DEKRPG999X.DamTypePlasmaTurret'
}
