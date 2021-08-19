class TutorialDroneProtector extends Actor;

var float TimeBetweenShots;
var float TargetRadius;
var float HealthHealingAmount;
var float ShieldHealingAmount;
var float ResupplyAmount;

var TutorialDrone Drone;
var class<xEmitter> HitEmitterClass;        // for standard defense sentinel
var class<xEmitter> ResupplyEmitterClass, HealthEmitterClass, ShieldEmitterClass;
var bool CanDefend;
var int DoHealCount;
var config int HealFreq;        // how often to go through the healing loop. 2 means every other time.

var Material HealingOverlay;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		Drone;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
    SetTimer(TimeBetweenShots, true);
}

function Timer()
{
	// lets target some enemies
	local Projectile P;
	local xEmitter HitEmitter;
	local Projectile ClosestP;
	local Projectile BestGuidedP;
	local Projectile BestP;
	local int ClosestPdist;
	local int BestGuidedPdist;

	if (Drone == None || Drone.protPawn == None || Drone.protPawn.Health <= 0)
		return;		// going to die soon.

	// look for projectiles in range
	if (CanDefend)
	{
		ClosestP = None;
		BestGuidedP = None;
		ClosestPdist = TargetRadius+1;
		BestGuidedPdist = TargetRadius+1;
		ForEach DynamicActors(class'Projectile',P)
		{
			if (P != None && FastTrace(P.Location, Drone.Location) && TranslocatorBeacon(P) == None && UntargetedProjectile(P) == None && UntargetedSeekerProjectile(P) == None && DEKLightningTurretProj(P) == None && VSize(Drone.Location - P.Location) <= TargetRadius)
			{
				if ((P.InstigatorController == None ||
					(P.InstigatorController != None &&
						((TeamGame(Level.Game) != None && !P.InstigatorController.SameTeamAs(Drone.protPawn.Controller))	// not same team
						 || (TeamGame(Level.Game) == None && P.InstigatorController != Drone.protPawn.Controller)))))	// or just not me
				{
					// its an enemy projectile
					// we prefer to target a server guided projectile, so it can be destroyed client side as well
					// otherwise just go for the closest
					if ( BestGuidedPdist > VSize(Drone.Location - P.Location) && P.bNetTemporary == false && !P.bDeleteMe)
					{
						BestGuidedP = P;
						BestGuidedPdist = VSize(Drone.Location - P.Location);
					}
					if ( ClosestPdist > VSize(Drone.Location - P.Location) && !P.bDeleteMe)
					{
						ClosestP = P;
						ClosestPdist = VSize(Drone.Location - P.Location);
					}

				}
			}
		}
		if (BestGuidedP != None)
			BestP = BestGuidedP;
		else
			BestP = ClosestP;

		if (BestP != None && !BestP.bDeleteMe)
		{
			HitEmitter = spawn(HitEmitterClass,,, Drone.Location, rotator(BestP.Location - Drone.Location));
			if (HitEmitter != None)
				HitEmitter.mSpawnVecA = BestP.Location;

			BestP.NetUpdateTime = Level.TimeSeconds - 1;
			BestP.bHidden = true;
			if (BestP.Physics != PHYS_None)	// to stop attacking an exploding redeemer
			{
				// destroy it
				BestP.Explode(BestP.Location,vect(0,0,0));
				
			}
		}
	}

	DoHealCount++;
	if (DoHealCount >= HealFreq)
	{
		DoHealCount = 0;    // reset
		DoHealing();
	}
}

function DoHealing()
{
	local xEmitter HitEmitter;

	if (Drone == None || Drone.protPawn == None || Drone.protPawn.Health <= 0)
		Destroy();
		
	//Health Healing	
	if (Drone.protPawn.Health < (Drone.protPawn.HealthMax + 100))
	{
		// can add some health
		Drone.protPawn.GiveHealth(HealthHealingAmount, Drone.protPawn.HealthMax + 100);
		Drone.protPawn.SetOverlayMaterial(HealingOverlay, 1.0, false);

		HitEmitter = spawn(HealthEmitterClass,,, Drone.Location, rotator(Drone.protPawn.Location - Drone.Location));
		if (HitEmitter != None)
			HitEmitter.mSpawnVecA = Drone.protPawn.Location;
	}
	
	//Shield Healing
	else if (Drone.protPawn.GetShieldStrength() < Drone.protPawn.GetShieldStrengthMax())
	{
		// can add some shield
		Drone.protPawn.AddShieldStrength(ShieldHealingAmount);

		HitEmitter = spawn(ShieldEmitterClass,,, Drone.Location, rotator(Drone.protPawn.Location - Drone.Location));
		if (HitEmitter != None)
			HitEmitter.mSpawnVecA = Drone.protPawn.Location;
	}
	//Resupply
	else if (Drone.protPawn.Weapon != None && Drone.protPawn.Weapon.AmmoClass[0] != None && !class'MutUT2004RPG'.static.IsSuperWeaponAmmo(Drone.protPawn.Weapon.AmmoClass[0])
		&& !Drone.protPawn.Weapon.AmmoMaxed(0))
	{
		// can add some ammo
		Drone.protPawn.Weapon.AddAmmo(max(1,(ResupplyAmount* Drone.protPawn.Weapon.AmmoClass[0].default.MaxAmmo)/100.0), 0);

		HitEmitter = spawn(ResupplyEmitterClass,,, Drone.Location, rotator(Drone.protPawn.Location - Drone.Location));
		if (HitEmitter != None)
			HitEmitter.mSpawnVecA = Drone.protPawn.Location;
	}
}

defaultproperties
{
     TimeBetweenShots=0.400000
     TargetRadius=750.000000
	 HealthHealingAmount=5
	 ShieldHealingAmount=10
	 ResupplyAmount=3
     HitEmitterClass=Class'DEKRPG208AH.DefenseBoltEmitter'
     ShieldEmitterClass=Class'DEKRPG208AH.GoldBoltEmitter'
     HealthEmitterClass=Class'DEKRPG208AH.BlueBoltEmitter'
     ResupplyEmitterClass=Class'DEKRPG208AH.RedBoltEmitter'
     HealingOverlay=Shader'UTRPGTextures2.Overlays.PulseBlueShader1'
     HealFreq=2
     bHidden=True
     Physics=PHYS_Trailer
     bHardAttach=True
}
