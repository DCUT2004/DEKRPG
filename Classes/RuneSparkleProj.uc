class RuneSparkleProj extends DEKLightningTurretProj
	config(DEKWeapons);

simulated function Timer()
{
    local float Distance, BeamLength;
    local vector Momentum, Direction;
    local DEKLightningTurretMiniBolt Bolt;
	local int MostHealth;
    local Controller C, BestC;
	
	if (Rand(100) <= DischargeChance)
	{
		// Zap all nearby targets.
		C = Level.ControllerList;
		BestC = None;
		MostHealth = 0;
		while (C != None)
		{
			// loop round finding strongest enemy to attack
			if ( C.Pawn != None && C.Pawn != Instigator && C.Pawn.Health > 0 && !C.SameTeamAs(Instigator.Controller)
				&& VSize(C.Pawn.Location - Location) < MiniboltRadius && FastTrace(C.Pawn.Location, Location) && C.bGodMode == False && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow'))
			{
				if (C.Pawn.Health > MostHealth)
				{
					MostHealth = C.Pawn.Health;
					BestC = C;
				}
			}
			C = C.NextController;
		}
		if (MostHealth > 0 && BestC != None && BestC.Pawn != None)
		{
            Direction = BestC.Pawn.Location - Location;
            Distance = FMax(1, VSize(Direction));
            Direction = Direction / Distance;
            Momentum = Direction * MomentumTransfer;

            BeamLength = VSize(BestC.Pawn.Location - Location);

            Bolt = Spawn(class'DEKLightningTurretMinibolt',,, Location, rotator(BestC.Pawn.Location - Location));
			if (Bolt != None)
			{
				BeamEmitter(Bolt.Emitters[0]).BeamDistanceRange.Min = BeamLength;
				BeamEmitter(Bolt.Emitters[0]).BeamDistanceRange.Max = BeamLength;
				Bolt.RemoteRole = Role_SimulatedProxy;
				Bolt.SpawnEffects(BestC.Pawn, Location, Direction * -1);
				Bolt.SetBase(self);
				Bolt.RemoteRole = ROLE_SimulatedProxy;
				Spawn(class'DEKLightningTurretProjSparks',,, BestC.Pawn.Location);
			}

            // Deal damage.
			if ( Instigator != None && (BestC.Pawn == Instigator) )
				return;

			if ( Instigator == None || Instigator.Controller == None )
				BestC.Pawn.SetDelayedDamageInstigatorController( InstigatorController );

			BestC.Pawn.TakeDamage(MiniboltDamage, Instigator, BestC.Pawn.Location, Momentum, MiniboltDamageType);
		}
	}
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
	if ( Role == ROLE_Authority )
	{
		HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
	}

	PlaySound(Sound'ONSBPSounds.ShieldActivate',,3.5*TransientSoundVolume);
	if ( EffectIsRelevant(Location,false) )
	{
	    Spawn(class'DEKLightningTurretProjSparks',,, Location);
	}
    SetCollisionSize(0.0, 0.0);
	Destroy();
}

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
	Super(Projectile).TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
}

defaultproperties
{
     MiniboltInterval=0.200000
     MiniboltDamage=14
     MiniboltRadius=600
     MiniboltClass=Class'DEKRPG999X.DEKLightningTurretMinibolt'
     MiniboltDamageType=Class'DEKRPG999X.DamTypeRuneSparkle'
     DischargeChance=40
     Speed=3000.000000
     MaxSpeed=3000.000000
     Damage=50.000000
     DamageRadius=60.000000
     MomentumTransfer=1000.000000
     MyDamageType=Class'DEKRPG999X.DamTypeRuneSparkle'
}
