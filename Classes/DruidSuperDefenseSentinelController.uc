class DruidSuperDefenseSentinelController extends DruidDefenseSentinelController
	config(UT2004RPG);

simulated function Timer()
{
	// lets target some enemies
	local Projectile P, TitanRock;
	local xEmitter HitEmitter;
	local Mutator m;
	Local DruidDefenseSentinel DefPawn;
	local ONSMineProjectile Mine;
    local bool HitProjectile, bIgnoreProjectile;
	local int x;

	if (PlayerSpawner == None || PlayerSpawner.Pawn == None || Pawn == None || Pawn.Health <= 0 || DruidDefenseSentinel(Pawn) == None)
		return;		// going to die soon.

	DefPawn = DruidDefenseSentinel(Pawn);
    HitProjectile = false;

	// look for projectiles in range and take them all out
	ForEach DynamicActors(class'Projectile',P)
	{
		if (P != None && FastTrace(P.Location, Pawn.Location) && VSize(Pawn.Location - P.Location) <= DefPawn.TargetRadius)
		{
			for (x = 0; x < Class'Utility_RPG'.default.IgnoredProjectiles.Length; x++)
			{
				if (ClassIsChildOf(P.Class, Class'Utility_RPG'.default.IgnoredProjectiles[x]))
				{
					bIgnoreProjectile = True;
					break;
				}
			}
			if (bIgnoreProjectile)
				continue;
			if ((P.InstigatorController == None ||
				(P.InstigatorController != None &&
					((TeamGame(Level.Game) != None && !P.InstigatorController.SameTeamAs(PlayerSpawner))	// not same team
					 || (TeamGame(Level.Game) == None && P.InstigatorController != PlayerSpawner)))))	// or just not me
			{
			    // its an enemy projectile
            	TitanRock = SMPTitanBigRock(P);
            	if (!P.bDeleteMe && (TitanRock == None || TitanRock != None && TitanRock.Drawscale > 2) )	//Ignore the small chunks of Titan rocks
            	{
                    HitProjectile = true;
                    
                    if (TitanRock == None || VSize(P.Velocity) > 0)
                    {
                		HitEmitter = spawn(HitEmitterClass,,, Pawn.Location, rotator(P.Location - Pawn.Location));
                		if (HitEmitter != None)
                			HitEmitter.mSpawnVecA = P.Location;
                    }
            		
            		if (bDestroyProjs)
            		{
            			P.NetUpdateTime = Level.TimeSeconds - 1;
            			P.bHidden = true;
            		}
            		if (P.Physics != PHYS_None)	// to stop attacking an exploding redeemer
            		{
            			if (bDestroyProjs)
            				P.Explode(P.Location,vect(0,0,0));
            			else
            			{
            				if (P.Damage >= P.default.Damage)
            				{
            					P.Damage *= DamageMultiplier;
            					P.MomentumTransfer *= DamageMultiplier;
            				}
            				if (P.IsA('SMPTitanBigRock'))
            				{
            					P.SetDrawScale(4.5);
            					P.TakeDamage(10, PlayerSpawner.Pawn, P.Location, Vect(0,0,0), class'DamageType');
            				}
            				if (P.Damage < MinimumDamage)
            					P.Damage = MinimumDamage;
            			}
            			
            			// ok, lets see if the initiator gets any xp
                   		if (StatsInv == None && PlayerSpawner != None && PlayerSpawner.Pawn != None)
            	            StatsInv = RPGStatsInv(PlayerSpawner.Pawn.FindInventoryType(class'RPGStatsInv'));
                    	// quick check to make sure we got the RPGMut set
                    	if (RPGMut == None && Level.Game != None)
                    	{
                    		for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
                    			if (MutUT2004RPG(m) != None)
                    			{
                    				RPGMut = MutUT2004RPG(m);
                    				break;
                    			}
                    	}
            			if ((DefPawn.XPPerHit > 0) && (StatsInv != None) && (StatsInv.DataObject != None) && (RPGMut != None) && (PlayerSpawner != None) && (PlayerSpawner.Pawn != None))
            			{
            					StatsInv.DataObject.AddExperienceFraction(DefPawn.XPPerHit, RPGMut, PlayerSpawner.Pawn.PlayerReplicationInfo);
            			}
            		}
            	}
			}
			else
			{
			    // its a friendly projectile. Lets see if it is a mine and we can boost it
				if (DefPawn.SpiderBoostLevel > 0 && DefPawn.ResupplyLevel > 0 && ONSMineProjectile(P) != None)
				{
					Mine = ONSMineProjectile(P);
					if (Mine.Damage < ((1 + DefPawn.SpiderBoostLevel) * Mine.default.Damage))
					{
                        HitProjectile = true;
					    class'EngineerLinkFire'.static.BoostMine(Mine,(10.0 + DefPawn.ResupplyLevel)/10.0);      // increase by 1.1 to 1.5 depending on how much resupply
						HitEmitter = spawn(ResupplyEmitterClass,,, DefPawn.Location, rotator(P.Location - DefPawn.Location));
						if (HitEmitter != None)
							HitEmitter.mSpawnVecA = P.Location;
					}
				}
			}
		}
	}
    
	if (HitProjectile == false)
	{
	    // no projectile to shoot down. Let's see if there is anything else we can do. Try healing - but only in teamgames
	    if ((TeamGame(Level.Game) != None))
	    {
	        DoHealCount++;
	        if (DoHealCount >= HealFreq)
	        {
	            DoHealCount = 0;    // reset
	    		DoHealing();
			}
		}
	}

}
defaultproperties
{
     TimeBetweenShots=2.000000
     TargetRadius=600.000000
}
