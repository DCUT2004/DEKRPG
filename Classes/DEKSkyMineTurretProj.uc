class DEKSkyMineTurretProj extends ONSSkyMine;

var class<DEKSkyMineBeamChained> BeamEffectClass;
var DEKSkyMineTurretWeapon OwnerGun;

simulated function PostNetBeginPlay()
{
	Super.PostNetBeginPlay();

	OwnerGun = DEKSkyMineTurretWeapon(Owner);
	if (OwnerGun != None)
		OwnerGun.Projectiles[OwnerGun.Projectiles.length] = self;
}

function SuperExplosion()
{
	local Emitter E;
	local actor HitActor;
	local vector HitLocation, HitNormal;
	local RPGStatsInv StatsInv;
	local float old_xp;
    local int DriverLevel;
	
	if ( Role == ROLE_Authority )
	{
		// find the current dataobject
		if (DEKSkyMineTurret(Instigator) != None && DEKSkyMineTurret(Instigator).Driver != None)
		{
			StatsInv = RPGStatsInv(DEKSkyMineTurret(Instigator).Driver.FindInventoryType(class'RPGStatsInv'));
			if (StatsInv != None && StatsInv.DataObject != None)
			{
				old_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
				DriverLevel = StatsInv.DataObject.Level;

				if (Level.TimeSeconds > DEKSkyMineTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay && DEKSkyMineTurret(Instigator).NumHealers > 0)
						ComboDamage = ComboDamage * class'RW_EngineerLink'.static.DamageIncreasedByLinkers(DEKSkyMineTurret(Instigator).NumHealers);
			}
		}

		HurtRadius(ComboDamage, ComboRadius, class'DamTypeSkyMineCombo', ComboMomentumTransfer, Location );

        if (StatsInv != None)
            class'RW_EngineerLink'.static.DistributeHealingXP(StatsInv, DriverLevel, DEKSkyMineTurret(Instigator).Healers, old_xp, DEKSkyMineTurret(Instigator).RPGMut);
	}

	E = Spawn(class'DEKSkyMineComboEffect');
	if ( Level.NetMode == NM_DedicatedServer )
	{
		if ( E != None )
			E.LifeSpan = 0.25;
	}
	else if ( EffectIsRelevant(Location,false) )
	{
		HitActor = Trace(HitLocation, HitNormal,Location - Vect(0,0,120), Location,false);
		if ( HitActor != None )
			Spawn(class'ComboDecal',self,,HitLocation, rotator(vect(0,0,-1)));
	}
	PlaySound(ComboSound, SLOT_None,1.0,,800);
	DestroyTrails();

	if (bDoChainReaction)
	{
		SetPhysics(PHYS_None);
		SetCollision(false);
		bHidden = true;
		SetTimer(ChainReactionDelay, false);
	}
	else
		Destroy();
}

function Timer()
{
	local int x;
	local DEKSkyMineBeamChained Beam;
	local Projectile ChainTarget;
	local float BestDist;


	if (OwnerGun != None)
	{
		BestDist = MaxChainReactionDist;
		for (x = 0; x < OwnerGun.Projectiles.length; x++)
		{
			if (OwnerGun.Projectiles[x] == None || OwnerGun.Projectiles[x] == self)
			{
				OwnerGun.Projectiles.Remove(x, 1);
				x--;
			}
			else if (VSize(Location - OwnerGun.Projectiles[x].Location) < BestDist)
			{
				ChainTarget = OwnerGun.Projectiles[x];
				BestDist = VSize(Location - OwnerGun.Projectiles[x].Location);
			}
		}

		if (ChainTarget != None)
		{
			Beam = Spawn(BeamEffectClass,,, Location, rotator(ChainTarget.Location - Location));
			Beam.Instigator = None;
			//Beam.AimAt(ChainTarget.Location, Normal(ChainTarget.Location - Location));
			BeamEmitter(Beam.Emitters[0]).BeamDistanceRange.Min = VSize(ChainTarget.Location - Location);
			BeamEmitter(Beam.Emitters[0]).BeamDistanceRange.Max = VSize(ChainTarget.Location - Location);
			BeamEmitter(Beam.Emitters[1]).BeamDistanceRange.Min = VSize(ChainTarget.Location - Location);
			BeamEmitter(Beam.Emitters[1]).BeamDistanceRange.Max = VSize(ChainTarget.Location - Location);
			ChainTarget.TakeDamage(1, Instigator, ChainTarget.Location, vect(0,0,0), ComboDamageType);
		}
	}

	Destroy();
}

simulated function Explode(vector HitLocation,vector HitNormal)
{
	local RPGStatsInv StatsInv;
	local float old_xp;
    local int DriverLevel;
	local DEKSkyMineImpactFX FX_Impact;
	
	if ( Role == ROLE_Authority )
	{
		if (DEKSkyMineTurret(Instigator) != None && DEKSkyMineTurret(Instigator).Driver != None)
		{
			StatsInv = RPGStatsInv(DEKSkyMineTurret(Instigator).Driver.FindInventoryType(class'RPGStatsInv'));
			if (StatsInv != None && StatsInv.DataObject != None)
			{
				old_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
				DriverLevel = StatsInv.DataObject.Level;

				if (Level.TimeSeconds > DEKSkyMineTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay && DEKSkyMineTurret(Instigator).NumHealers > 0)
						Damage = Damage * class'RW_EngineerLink'.static.DamageIncreasedByLinkers(DEKSkyMineTurret(Instigator).NumHealers);
			}
		}

        HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );

        if (StatsInv != None)
            class'RW_EngineerLink'.static.DistributeHealingXP(StatsInv, DriverLevel, DEKSkyMineTurret(Instigator).Healers, old_xp, DEKSkyMineTurret(Instigator).RPGMut);
	}

    if ( EffectIsRelevant(Location, false) )
	{
		FX_Impact = Spawn(class'DEKSkyMineImpactFX',,, HitLocation + HitNormal * 2, rotator(HitNormal));
	}
   	PlaySound(ImpactSound, SLOT_Misc);
	SetCollisionSize(0.0, 0.0);
	Destroy();
}

defaultproperties
{
     BeamEffectClass=Class'DEKRPG999X.DEKSkyMineBeamChained'
     ProjectileEffectClass=Class'DEKRPG999X.DEKSkyMineShockBall'
     ComboDamage=80.000000
     ComboRadius=375.000000
     ComboDamageType=Class'DEKRPG999X.DamTypeSkyMineBeam'
     Damage=12.000000
     DamageRadius=100.000000
     MyDamageType=Class'DEKRPG999X.DamTypeDEKSkyMine'
     ExplosionDecal=None
     LightHue=10
     LightSaturation=30
     DrawType=DT_Sprite
     Texture=Texture'XEffects.PainterDecalMark'
     DrawScale=0.800000
     Skins(0)=Texture'XEffects.PainterDecalMark'
}
