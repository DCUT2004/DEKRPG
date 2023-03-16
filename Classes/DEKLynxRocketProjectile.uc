class DEKLynxRocketProjectile extends ONSMASRocketProjectile;

function BlowUp(vector HitLocation)
{
	local RPGStatsInv StatsInv;
	local float old_xp;
    local int DriverLevel;
	
	if ( Role == ROLE_Authority )
	{
		if (DEKLynxTurret(Instigator) != None && DEKLynxTurret(Instigator).Driver != None)
		{
			StatsInv = RPGStatsInv(DEKLynxTurret(Instigator).Driver.FindInventoryType(class'RPGStatsInv'));
			if (StatsInv != None && StatsInv.DataObject != None)
			{
				old_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
				DriverLevel = StatsInv.DataObject.Level;

				if (Level.TimeSeconds > DEKLynxTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay && DEKLynxTurret(Instigator).NumHealers > 0)
					Damage = Damage * class'RW_EngineerLink'.static.DamageIncreasedByLinkers(DEKLynxTurret(Instigator).NumHealers);
			}
		}
		HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );

        if (StatsInv != None)
            class'RW_EngineerLink'.static.DistributeHealingXP(StatsInv, DriverLevel, DEKLynxTurret(Instigator).Healers, old_xp, DEKLynxTurret(Instigator).RPGMut);
	}
}

defaultproperties
{
     Speed=2000.000000
     MaxSpeed=2000.000000
     Damage=62.000000
     DamageRadius=120.000000
     MyDamageType=Class'DEKRPG999X.DamTypeLynxRocket'
}
