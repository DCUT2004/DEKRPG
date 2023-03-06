class PROJ_FireBallTurretSmall extends GasBagBelch;

var Emitter Flames;
var class<Emitter> FlamesClass;

simulated function PostBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer)
	{
		if ( !Level.bDropDetail )
			spawn(class'RocketSmokeRing',,,Location, Rotation );
		Flames = Spawn(FlamesClass,self);
    	if ( Flames != None )
    		Flames.SetBase( Self );
	}
	Dir = vector(Rotation);
	Velocity = speed * Dir;

	if ( Level.bDropDetail )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}
	Super(Projectile).PostBeginPlay();
}

function BlowUp(vector HitLocation)
{
	local RPGStatsInv StatsInv, HealerStatsInv;
	local float old_xp,cur_xp,xp_each,xp_diff,xp_given_away;
	local int i;
	local int DriverLevel;
	local Controller C;

	if ( Role == ROLE_Authority )
	{
		// find the current dataobject
		if (BaseBallTurret(Instigator) != None && BaseBallTurret(Instigator).Driver != None)
		{
			StatsInv = RPGStatsInv(BaseBallTurret(Instigator).Driver.FindInventoryType(class'RPGStatsInv'));
			if (StatsInv != None && StatsInv.DataObject != None)
			{
				old_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
				DriverLevel = StatsInv.DataObject.Level;

				if (Level.TimeSeconds > BaseBallTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay && BaseBallTurret(Instigator).NumHealers > 0)
				{
					Damage = Damage * class'RW_EngineerLink'.static.DamageIncreasedByLinkers(BaseBallTurret(Instigator).NumHealers);
					DamageRadius = DamageRadius * class'RW_EngineerLink'.static.DamageIncreasedByLinkers(BaseBallTurret(Instigator).NumHealers);
				}
			}
		}

		HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );

		if (StatsInv != None && StatsInv.DataObject != None && DriverLevel == StatsInv.DataObject.Level)		// if the driver has levelled, then do not share xp
		{
			cur_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
			xp_diff = cur_xp - old_xp;
			if (xp_diff > 0 && BaseBallTurret(Instigator).NumHealers > 0)
//			if (xp_diff > 0 && Level.TimeSeconds > BaseBallTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay && BaseBallTurret(Instigator).NumHealers > 0)
			{
				// split the xp amongst the healers
				xp_each = class'RW_EngineerLink'.static.XPForLinker(xp_diff , BaseBallTurret(Instigator).Healers.length);
				xp_given_away = 0;

				for(i = 0; i < BaseBallTurret(Instigator).Healers.length; i++)
				{
					if (BaseBallTurret(Instigator).Healers[i].Pawn != None && BaseBallTurret(Instigator).Healers[i].Pawn.Health >0)
					{
						   C = BaseBallTurret(Instigator).Healers[i];
						   if (DruidLinkSentinelController(C) != None)
							HealerStatsInv = DruidLinkSentinelController(C).StatsInv;
						   else
							HealerStatsInv = RPGStatsInv(C.Pawn.FindInventoryType(class'RPGStatsInv'));
						if (HealerStatsInv != None && HealerStatsInv.DataObject != None)
							HealerStatsInv.DataObject.AddExperienceFraction(xp_each, BaseBallTurret(Instigator).RPGMut, BaseBallTurret(Instigator).Healers[i].Pawn.PlayerReplicationInfo);
						xp_given_away += xp_each;
					}
				}
				// now adjust the turret operator
				if (xp_given_away > 0)
				{
					StatsInv.DataObject.ExperienceFraction -= xp_given_away;
					while (StatsInv.DataObject.ExperienceFraction < 0)
					{
						StatsInv.DataObject.ExperienceFraction += 1.0;
						StatsInv.DataObject.Experience -= 1;
					}
				}
			}
			// BaseBallTurret(Instigator).Healers.length = 0;	// we have just paid them, so scrub their names
		}
	}
	MakeNoise(1.0);
}

simulated function Destroyed() 
{
	if ( Flames != None )
		Flames.Destroy();
	Super.Destroyed();
}

defaultproperties
{
     FlamesClass=class'FX_FireBallSmall'
     MaxSpeed=8000.000000
     Speed=8000.0000
     Damage=45.0000
     MyDamageType=Class'DEKRPG999X.DamTypeFireBallTurret'
     DrawScale=1.0
     LifeSpan=10.0
}
