class PROJ_DruidBallTurretPlasma extends PROJ_TurretSkaarjPlasma;

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
			if (DruidBallTurret(Instigator) != None && DruidBallTurret(Instigator).Driver != None)
			{
				StatsInv = RPGStatsInv(DruidBallTurret(Instigator).Driver.FindInventoryType(class'RPGStatsInv'));
				if (StatsInv != None && StatsInv.DataObject != None)
				{
					old_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
					DriverLevel = StatsInv.DataObject.Level;

					if (Level.TimeSeconds > DruidBallTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay && DruidBallTurret(Instigator).NumHealers > 0)
						Damage = Damage * class'RW_EngineerLink'.static.DamageIncreasedByLinkers(DruidBallTurret(Instigator).NumHealers);
				}
			}

			Other.TakeDamage(Damage, Instigator, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType);

            class'RW_EngineerLink'.static.DistributeHealingXP(StatsInv, DriverLevel, BaseBallTurret(Instigator).Healers, old_xp, BaseBallTurret(Instigator).RPGMut);
		}

		Explode(HitLocation, -Normal(Velocity));
	}
}

defaultproperties
{
     MaxSpeed=8000.000000
     Damage=44.250000
     MyDamageType=Class'DEKRPG999X.DamTypeDruidBallTurret'
}
