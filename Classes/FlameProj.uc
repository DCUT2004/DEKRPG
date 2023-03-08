class FlameProj extends Projectile;

var	Emitter SmokeTrail;

simulated function Destroyed() 
{
	if ( SmokeTrail != None )
        SmokeTrail.Destroy();
		// SmokeTrail.mRegen = False;
	Super.Destroyed();
}

simulated function PostBeginPlay()
{
	Velocity = Speed * vector(Rotation);
	if ( Level.NetMode != NM_DedicatedServer)
	{
		SmokeTrail = Spawn(class'Flamethrower',self);
    	if ( SmokeTrail != None )
    		SmokeTrail.SetBase( Self );
	}
    
	Super.PostBeginPlay();
}

simulated function ClientSideTouch(Actor Other, Vector HitLocation);
simulated function BlowUp(vector HitLocation);
simulated function HitWall(vector HitNormal, Actor Wall);
simulated function Landed( vector HitNormal );

simulated singular function Touch(Actor Other)
{
	local vector HitLocation, HitNormal;

	if (Other == None) // Other just got destroyed in its touch?
		return;

	if (Other.bProjTarget || Other.bBlockActors)
	{
		LastTouched = Other;
		if (Velocity == vect(0,0,0) || Other.IsA('Mover'))
		{
			ProcessTouch(Other, Location);
			LastTouched = None;
			return;
		}

		if (Other.TraceThisActor(HitLocation, HitNormal, Other.Location, Location, vect(1,1,1)))
			HitLocation = Location;

		ProcessTouch(Other, HitLocation);
		LastTouched = None;
		if (Role < ROLE_Authority && Other.Role == ROLE_Authority && Pawn(Other) != None)
			ClientSideTouch(Other, HitLocation);
	}
}


simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
    local int DriverLevel;
    local float old_xp;
    local RPGStatsInv StatsInv;

	if ( Instigator != None && (Other == Instigator) )
		return;

    if (Other == Owner) return;

	if ( !Other.IsA('Projectile') || Other.bProjTarget )
	{
		if ( Role == ROLE_Authority )
		{
			if ( Instigator == None || Instigator.Controller == None )
				Other.SetDelayedDamageInstigatorController( InstigatorController );
                
			if (Lifespan > 0)
            {
    			// find the current dataobject
    			if (FireBallTurret(Instigator) != None && FireBallTurret(Instigator).Driver != None)
    			{
    				StatsInv = RPGStatsInv(FireBallTurret(Instigator).Driver.FindInventoryType(class'RPGStatsInv'));
    				if (StatsInv != None && StatsInv.DataObject != None)
    				{
    					old_xp = StatsInv.DataObject.Experience + StatsInv.DataObject.ExperienceFraction;
    					DriverLevel = StatsInv.DataObject.Level;
    
    					if (Level.TimeSeconds > FireBallTurret(Instigator).LastHealTime + class'EngineerLinkGun'.default.HealTimeDelay && FireBallTurret(Instigator).NumHealers > 0)
    						Damage = Damage * class'RW_EngineerLink'.static.DamageIncreasedByLinkers(FireBallTurret(Instigator).NumHealers);
    				}
    			}

                // Log("+++++++ FlameProj about to do" @ Damage @ "damage to" @ Other @ "LifeSpan" @ LifeSpan @ "time:" @ Level.TimeSeconds);
				Other.TakeDamage(Damage, Instigator, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType);

                class'RW_EngineerLink'.static.DistributeHealingXP(StatsInv, DriverLevel, FireBallTurret(Instigator).Healers, old_xp, FireBallTurret(Instigator).RPGMut);
            }
		}
	}
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
		Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
	Destroy();
}

function bool EncroachingOn(Actor Other)
{
	return False;
}


//=============================================================================
// Default values
//=============================================================================

defaultproperties
{
     Speed=700.000000
     MaxSpeed=700.000000
     Damage=20.000000
     MomentumTransfer=30000.000000
     MyDamageType=Class'DEKRPG999X.DamTypeFireBallTurret'
     LightType=LT_Steady
     LightEffect=LE_Spotlight
     LightHue=20
     LightSaturation=50
     LightBrightness=300.000000
     LightRadius=30.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DEKStaticsMaster209C.fX.SolarWave'
     bDynamicLight=True
     bIgnoreEncroachers=True
     LifeSpan=1.000000
     CollisionRadius=80.000000
     CollisionHeight=50.000000
     PrePivot=(X=210.000000)
	 Skins(0)=Texture'EmitterTextures.MultiFrame.LargeFlames'
     AmbientGlow=254
     bCollideWorld=False
     bIgnoreOutOfWorld=True
     ExplosionDecal=class'RocketMark'
}
