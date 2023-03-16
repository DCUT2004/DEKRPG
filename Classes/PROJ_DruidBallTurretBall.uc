class PROJ_DruidBallTurretBall extends Projectile;

#exec  AUDIO IMPORT NAME="PlasmaTurretBallAmb" FILE="Sounds\PlasmaTurretBallAmb.WAV" GROUP="TurretSounds"
#exec  AUDIO IMPORT NAME="PlasmaTurretBallExplode" FILE="Sounds\PlasmaTurretBallExplode.WAV" GROUP="TurretSounds"

var vector initialDir;
var class<Emitter>  ProjectileEffectClass;
var Emitter         ProjectileEffect;
var class<xEmitter> HitEmitterClass;
var class<Emitter>  ExplosionEmitterClass;
var bool bEffects;
//var byte Team;

simulated function PostBeginPlay()
{
    local Rotator R;

    if (Level.NetMode != NM_DedicatedServer)
    {
        ProjectileEffect = spawn(ProjectileEffectClass, self,, Location, Rotation);
        ProjectileEffect.SetBase(self);
    }

    Super.PostBeginPlay();

    Velocity = Speed * Vector(Rotation);
    R = Rotation;
    R.Roll = 32768;
    SetRotation(R);
    Velocity.z += TossZ;
    initialDir = Velocity;
    
    /*
    if (Instigator != None)
       Team = Instigator.GetTeamNum();
    */

    bEffects = false;
}

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
	if ( Other != Instigator )
	{
		SpawnEffects(HitLocation, -1 * Normal(Velocity) );
		Explode(HitLocation,Normal(HitLocation-Other.Location));
	}
}

simulated function Landed( vector HitNormal )
{
	SpawnEffects( Location, HitNormal );
	Explode(Location,HitNormal);
}

simulated function HitWall (vector HitNormal, actor Wall)
{
    Landed(HitNormal);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local RPGStatsInv StatsInv;
	local float old_xp;
    local int DriverLevel;

	if ( Role == ROLE_Authority )
	{

		// find the current dataobject
		if (DruidBallTurret(Instigator) != None && DruidBallTurret(Instigator).Driver != None)
		{
			StatsInv = RPGStatsInv(DruidBallTurret(Instigator).Driver.FindInventoryType(class'RPGStatsInv'));
			if (StatsInv != None && StatsInv.DataObject != None)
			{
				old_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
				DriverLevel = StatsInv.DataObject.Level;

				if (Level.TimeSeconds > DruidBallTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay && DruidBallTurret(Instigator).NumHealers > 0)
				{
					Damage = Damage * class'RW_EngineerLink'.static.DamageIncreasedByLinkers(DruidBallTurret(Instigator).NumHealers);
					DamageRadius = DamageRadius * class'RW_EngineerLink'.static.DamageIncreasedByLinkers(DruidBallTurret(Instigator).NumHealers);
				}
			}
		}

		//Other.TakeDamage(Damage, Instigator, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType);
		HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );

        if (StatsInv != None)
            class'RW_EngineerLink'.static.DistributeHealingXP(StatsInv, DriverLevel, DruidBallTurret(Instigator).Healers, old_xp, DruidBallTurret(Instigator).RPGMut);
	}
    
	Destroy();
}


simulated function Destroyed()
{
    if (ProjectileEffect != None)
        ProjectileEffect.Destroy();

    Super.Destroyed();
}

simulated function SpawnEffects( vector HitLocation, vector HitNormal )
{
	local PlayerController PC;
	
	PlaySound(ImpactSound,,3.5*TransientSoundVolume);
	
    if ( EffectIsRelevant(Location,false) )
    {
		PC = Level.GetLocalPlayerController();
		if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 3000 )
		{
			spawn(ExplosionEmitterClass,,,Location);
			spawn(class'ShockComboFlash',,,Location);
		}

        if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
            Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
    }
}

defaultproperties
{
     ProjectileEffectClass=Class'DEKRPG999X.DEKPlasmaTurretBallFX'
     ExplosionEmitterClass=Class'Onslaught.ONSPlasmaHitPurple'
     Speed=1200.000000
     TossZ=225.000000
     Damage=200.000000
     DamageRadius=330.000000
     MomentumTransfer=50000.000000
     MyDamageType=Class'DEKRPG999X.DamTypeDruidBallTurret'
     ImpactSound=Sound'DEKRPG999X.TurretSounds.PlasmaTurretBallExplode'
     ExplosionDecal=Class'Onslaught.ONSRocketScorch'
     CullDistance=4000.000000
     Physics=PHYS_Falling
     AmbientSound=Sound'DEKRPG999X.TurretSounds.PlasmaTurretBallAmb'
     LifeSpan=3.000000
     DrawScale=0.300000
     AmbientGlow=100
     SoundVolume=255
     SoundRadius=100.000000
     bProjTarget=True
     bFixedRotationDir=True
     DesiredRotation=(Pitch=12000,Yaw=5666,Roll=2334)
     ForceType=FT_Constant
     ForceRadius=60.000000
     ForceScale=5.000000
}
