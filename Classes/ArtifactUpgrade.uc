class ArtifactUpgrade extends EnhancedRPGArtifact;

var class<xEmitter> HitEmitterClass;
var config float MaxRange;

function BotConsider()
{
		return;    // wont know where to aim it
}

function Activate()
{
	local Vehicle V;
	local Vector FaceDir;
	local Vector BeamEndLocation;
	local vector HitLocation;
	local vector HitNormal;
	local Vector StartTrace;
	local xEmitter HitEmitter;
	local Actor A;
	local Actor AHit;
	local Pawn  HitPawn;
	
	Super(EnhancedRPGArtifact).Activate();

	if (Instigator != None)
	{
		if(Instigator.Controller.Adrenaline < AdrenalineRequired)
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, AdrenalineRequired, None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}
		
		V = Vehicle(Instigator);
		if (V != None )
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 3000, None, None, Class);
			bActive = false;
			GotoState('');
			return;	// can't use in a vehicle
		}

		// lets see what we hit then
		FaceDir = Vector(Instigator.Controller.GetViewRotation());
		StartTrace = Instigator.Location + Instigator.EyePosition();
		BeamEndLocation = StartTrace + (FaceDir * MaxRange);

		// See if we hit something.
       	AHit = Trace(HitLocation, HitNormal, BeamEndLocation, StartTrace, true);
		if ((AHit == None) || (Pawn(AHit) == None) || ((Pawn(AHit).Controller == None) && BaseBallTurret(AHit) == None && DruidEnergyTurret(AHit) == None && DruidMinigunTurret(AHit) == None))
		{
			// missed. 
            // Log("++++++ Upgrade Artifact didn't hit the right thing 1" @ HitPawn);
			Instigator.ReceiveLocalizedMessage(MessageClass, 1000, None, None, Class);
			bActive = false;
			GotoState('');
			return;	// didn't hit a valid object
		}

		HitPawn = Pawn(AHit);
		if ( HitPawn != Instigator && HitPawn.Health > 0 
            && ((HitPawn.Controller != None && HitPawn.Controller.SameTeamAs(Instigator.Controller))  
                || ((BaseBallTurret(HitPawn) != None || DruidEnergyTurret(HitPawn) != None || DruidMinigunTurret(HitPawn) != None) && HitPawn.GetTeamNum() == Instigator.GetTeamNum() && Instigator.GetTeamNum() != 255 ) )
		    && VSize(HitPawn.Location - StartTrace) < MaxRange)
		{
			// ok, lets do the work. Give the sentinel/turret a levelup.
			if (BaseFloorSentinel(HitPawn) != None)
            {
                if (BaseFloorSentinel(HitPawn).SentinelLevel >= BaseFloorSentinel(HitPawn).default.MaxSentinelLevel)
                {
        			Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
        			bActive = false;
        			GotoState('');
        			return;	// already maxed
                }
                BaseFloorSentinel(HitPawn).LevelUp();
            }
            else
			if (BaseCeilingSentinel(HitPawn) != None)
            {
                if (BaseCeilingSentinel(HitPawn).SentinelLevel >= BaseCeilingSentinel(HitPawn).default.MaxSentinelLevel)
                {
        			Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
        			bActive = false;
        			GotoState('');
        			return;	// already maxed
                }
                BaseCeilingSentinel(HitPawn).LevelUp();
            }
            else	
			if (BaseTurretSentinel(HitPawn) != None)
            {
                if (BaseTurretSentinel(HitPawn).SentinelLevel >= BaseTurretSentinel(HitPawn).default.MaxSentinelLevel)
                {
        			Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
        			bActive = false;
        			GotoState('');
        			return;	// already maxed
                }
                BaseTurretSentinel(HitPawn).LevelUp();
            }
            else	
			if (Node(HitPawn) != None)
            {
                if (Node(HitPawn).NodeLevel >= Node(HitPawn).default.MaxNodeLevel)
                {
        			Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
        			bActive = false;
        			GotoState('');
        			return;	// already maxed
                }
                Node(HitPawn).LevelUp();
            }
            else	
			if (BaseBallTurret(HitPawn) != None)
            {
                if (BaseBallTurret(HitPawn).TurretLevel >= BaseBallTurret(HitPawn).default.MaxTurretLevel)
                {
        			Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
        			bActive = false;
        			GotoState('');
        			return;	// already maxed
                }
                BaseBallTurret(HitPawn).LevelUp();
            }
            else	
			if (DruidEnergyTurret(HitPawn) != None)
            {
                if (DruidEnergyTurret(HitPawn).TurretLevel >= DruidEnergyTurret(HitPawn).default.MaxTurretLevel)
                {
        			Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
        			bActive = false;
        			GotoState('');
        			return;	// already maxed
                }
                DruidEnergyTurret(HitPawn).LevelUp();
            }
            else	
			if (DruidMinigunTurret(HitPawn) != None)
            {
                if (DruidMinigunTurret(HitPawn).TurretLevel >= DruidMinigunTurret(HitPawn).default.MaxTurretLevel)
                {
        			Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
        			bActive = false;
        			GotoState('');
        			return;	// already maxed
                }
                DruidMinigunTurret(HitPawn).LevelUp();
            }
            else
            {
                // Log("++++++ Upgrade Artifact didn't hit the right thing 2" @ HitPawn);
    			Instigator.ReceiveLocalizedMessage(MessageClass, 1000, None, None, Class);
    			bActive = false;
    			GotoState('');
    			return;	// aim it
            }

			// take off adrenaline, and add xp
			Instigator.Controller.Adrenaline -= AdrenalineRequired;
			if (Instigator.Controller.Adrenaline < 0)
				Instigator.Controller.Adrenaline = 0;

			// got it.
			HitEmitter = spawn(HitEmitterClass,,, (StartTrace + Instigator.Location)/2, rotator(HitLocation - ((StartTrace + Instigator.Location)/2)));
			if (HitEmitter != None)
			{
				HitEmitter.mSpawnVecA = HitPawn.Location;
			}

			A = spawn(class'BlueSparks',,, Instigator.Location);
			if (A != None)
			{
				A.RemoteRole = ROLE_SimulatedProxy;
				A.PlaySound(Sound'WeaponSounds.LightningGun.LightningGunImpact',,1.5*Instigator.TransientSoundVolume,,Instigator.TransientSoundRadius);
			}
			A = spawn(class'BlueSparks',,, HitPawn.Location);
			if (A != None)
			{
				A.RemoteRole = ROLE_SimulatedProxy;
				A.PlaySound(Sound'WeaponSounds.LightningGun.LightningGunImpact',,1.5*HitPawn.TransientSoundVolume,,HitPawn.TransientSoundRadius);
			}
        }
        else
        {
            // Log("++++++ Upgrade Artifact didn't hit the right thing 3" @ HitPawn);
			Instigator.ReceiveLocalizedMessage(MessageClass, 1000, None, None, Class);
			bActive = false;
			GotoState('');
			return;	// can't use in a vehicle
        }
	}
	bActive = false;
	GotoState('');
	return;
}

exec function TossArtifact()
{
	//do nothing. This artifact cant be thrown
}

function DropFrom(vector StartLocation)
{
	if (bActive)
		GotoState('');
	bActive = false;

	Destroy();
	Instigator.NextItem();
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 3000)
		return "Cannot use this artifact inside a vehicle";
	else if (Switch == 2000)
		return "That item is already at the maximum level";
	else if (Switch == 1000)
		return "You need to aim at an upgradable node, sentinel or turret";
	else
		return switch @ "Adrenaline is required to use this artifact";
}

defaultproperties
{
     HitEmitterClass=Class'DEKRPG999X.LightningBeamEmitter'
     AdrenalineRequired=150
     MaxRange=3000.000000
     CostPerSec=1
     MinActivationTime=0.000001
     PickupClass=None
     IconMaterial=Texture'AS_FX_TX.SpaceHUD_HealthIcon'
     ItemName="Upgrade Item"
}
