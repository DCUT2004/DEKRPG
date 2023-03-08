class PROJ_FireBallTurretSmall extends GasBagBelch;

var Emitter Flames;
var class<Emitter> FlamesClass;

simulated function PostBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer)
	{
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
	local RPGStatsInv StatsInv;
	local float old_xp;
	local int DriverLevel;

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

		HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);

        class'RW_EngineerLink'.static.DistributeHealingXP(StatsInv, DriverLevel, BaseBallTurret(Instigator).Healers, old_xp, BaseBallTurret(Instigator).RPGMut);
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
