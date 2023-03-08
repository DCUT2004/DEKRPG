class DruidEnergyWeapon extends ONSManualGun;

function TraceFire(Vector Start, Rotator Dir)
{
    local Vector X, End, HitLocation, HitNormal;
    local Actor Other;
    local int Damage;
    local RPGStatsInv StatsInv;
    local float old_xp;
    local int DriverLevel;

    X = Vector(Dir);
    End = Start + TraceRange * X;

    //skip past vehicle driver
    if (ONSVehicle(Instigator) != None && ONSVehicle(Instigator).Driver != None)
    {
      	ONSVehicle(Instigator).Driver.bBlockZeroExtentTraces = False;
       	Other = Trace(HitLocation, HitNormal, End, Start, True);
       	ONSVehicle(Instigator).Driver.bBlockZeroExtentTraces = true;
    }
    else
       	Other = Trace(HitLocation, HitNormal, End, Start, True);

    if (Other != None)
    {
		if (!Other.bWorldGeometry)
		{
			Damage = (DamageMin + Rand(DamageMax - DamageMin));

			// find the current dataobject
			if (DruidEnergyTurret(Instigator) != None && DruidEnergyTurret(Instigator).Driver != None)
			{
				StatsInv = RPGStatsInv(DruidEnergyTurret(Instigator).Driver.FindInventoryType(class'RPGStatsInv'));
				if (StatsInv != None && StatsInv.DataObject != None)
				{
					old_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
					DriverLevel = StatsInv.DataObject.Level;

					if (Level.TimeSeconds > DruidEnergyTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay && DruidEnergyTurret(Instigator).NumHealers > 0)
						Damage = Damage * class'RW_EngineerLink'.static.DamageIncreasedByLinkers(DruidEnergyTurret(Instigator).NumHealers);
				}
			}
	
	
			if (ONSPowerCore(Other) == None && ONSPowerNodeEnergySphere(Other) == None)  // Sweet Hackaliciousness
				Other.TakeDamage(Damage, Instigator, HitLocation, Momentum*X, DamageType);
			HitNormal = vect(0,0,0);
	
            class'RW_EngineerLink'.static.DistributeHealingXP(StatsInv, DriverLevel, DruidEnergyTurret(Instigator).Healers, old_xp, DruidEnergyTurret(Instigator).RPGMut);

        }
    }
    else
    {
        HitLocation = End;
        HitNormal = Vect(0,0,0);
    }

    HitCount++;
    LastHitLocation = HitLocation;
    SpawnHitEffects(Other, HitLocation, HitNormal);
}

defaultproperties
{
     DamageMin=28
}
