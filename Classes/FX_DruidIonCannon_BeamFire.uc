class FX_DruidIonCannon_BeamFire extends FX_Turret_IonCannon_BeamFire;

simulated function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
	local actor Victims;
	local float damageScale, dist;
	local vector dir;
	local RPGStatsInv StatsInv;
	local float old_xp;
    local int DriverLevel;
	local Pawn P;
	local bool bSameTeam;

	if( bHurtEntry )
		return;

	if ( Role != ROLE_Authority )
		return;

	bHurtEntry = true;

	// find the current dataobject
	if (DruidIonCannon(Instigator) != None && DruidIonCannon(Instigator).Driver != None)
	{
		StatsInv = RPGStatsInv(DruidIonCannon(Instigator).Driver.FindInventoryType(class'RPGStatsInv'));
		if (StatsInv != None && StatsInv.DataObject != None)
		{
			old_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
			DriverLevel = StatsInv.DataObject.Level;
			
			if (Level.TimeSeconds > DruidIonCannon(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay && DruidIonCannon(Instigator).NumHealers > 0)
				DamageAmount *= class'RW_EngineerLink'.static.DamageIncreasedByLinkers(DruidIonCannon(Instigator).NumHealers);
		}
	}
		
	foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
	{
		// don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
		if( (Victims != instigator) && (Victims != self) && (Victims.Role == ROLE_Authority) && (!Victims.IsA('FluidSurfaceInfo')) )
		{
			dir = Victims.Location - HitLocation;
			dist = FMax(1,VSize(dir));
			dir = dir/dist;
			damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
			bSameTeam = false;
			P = Pawn(Victims);
			if (P != None && P.Controller != None && P.Health > 0 && Instigator != None && P.Controller.SameTeamAs(Instigator.Controller))
			    bSameTeam = true;
			if (!bSameTeam)
			{
				Victims.TakeDamage
				(
					damageScale * DamageAmount,
					Instigator,
					Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
					(damageScale * Momentum * dir),
					DamageType
				);
	//			Log("****Ion Beam Fire hitting:" $ Victims @ "for damage:" $ (damageScale * DamageAmount));
				if (Instigator != None && Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
					Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, Instigator.Controller, DamageType, Momentum, HitLocation);
			}
		}
	}

    if (StatsInv != None)
        class'RW_EngineerLink'.static.DistributeHealingXP(StatsInv, DriverLevel, DruidIonCannon(Instigator).Healers, old_xp, DruidIonCannon(Instigator).RPGMut);

	bHurtEntry = false;
}

defaultproperties
{
     MinRange=700.000000
     Damage=120
     DamageRadius=1700.000000
}
