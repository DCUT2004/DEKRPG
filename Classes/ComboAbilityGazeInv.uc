//The combo that the player has purchased
class ComboAbilityGazeInv extends ComboAbilityInv
	config(UT2004RPG);
	
var config float GazeDistance;
var bool bDefenseDown;
var Pawn HitPawn;
var float CheckInterval;
var xEmitter Chain;
var float TempLifespan;

function DoEffect()
{
	HitPawn = None;
	bDefenseDown = False;
	TempLifespan = ComboLifespan;
	SetTimer(CheckInterval, True);
}

function Timer()
{
	local Actor AHit, A;
	local Vector FaceDir;
	local Vector StartTrace;
	local Vector BeamEndLocation;
	local vector HitLocation;
	local vector HitNormal;
	
	//HitPawn is whoever we look at
	
	TempLifespan -= (1.00000000*CheckInterval);
	if (TempLifespan < 0)
	{
		if (HitPawn != None)
		{
			if( HitPawn.Physics == PHYS_NONE)
				HitPawn.setPhysics(PHYS_FALLING);
			HitPawn = None;
		}
		if (Chain != None)
			Chain.Destroy();
		SetTimer(0, False);
		return;
	}
	
	if (HitPawn == None || (HitPawn != None && HitPawn.Health <= 0))
	{
		bDefenseDown = False;
		if (Chain != None)
			Chain.Destroy();
	}
	if (HitPawn != None && HitPawn.Health <= 0)
	{
		HitPawn = None;
		if (Chain != None)
			Chain.Destroy();
	}
	
	if (Pawn(Owner) != None)
	{
		FaceDir = Vector(Instigator.Controller.GetViewRotation());
		StartTrace = Instigator.Location + Instigator.EyePosition();
		BeamEndLocation = StartTrace + (FaceDir * GazeDistance);
	}
	
	// See if we hit something.
	AHit = Trace(HitLocation, HitNormal, BeamEndLocation, StartTrace, true);
	if (AHit != None)
	{
		if (HitPawn == None && Pawn(AHit) != None && Pawn(AHit).Controller != None && Pawn(AHit).Health > 0 && !Pawn(AHit).Controller.SameTeamAs(Pawn(Owner).Controller) && !Pawn(AHit).IsA('HealerNali') && !Pawn(AHit).IsA('MissionCow'))
		{
			HitPawn = Pawn(AHit);
		}
	}
	if (HitPawn != None)
	{
		if(HitPawn.Physics != PHYS_NONE)
			HitPawn.setPhysics(PHYS_NONE);
		if (!bDefenseDown)
		{
			if (Combo != None)
			{
				Combo.AddAilment(Pawn(Owner), False, False, False, ComboLifespan, class'ComboDefenseGazeInv', EffectMultiplier, bDispellable, HitPawn);
				//Combo.AddAilment(Pawn(Owner), bAll, False, bSingle, ComboLifespan, class'ComboVampireTargetInv', 0.5000, bDispellable, HitPawn);
			}
			bDefenseDown = True;
		}
		if (Pawn(Owner) != None && Chain == None)
		{
			Chain = Spawn(class'ComboAbilityGazeChain',Pawn(Owner),,Pawn(Owner).Location, Rotator(Pawn(Owner).Location - HitPawn.Location));
			Chain.SetBase(Pawn(Owner));
			Pawn(Owner).PlaySound(sound'ONSBPSounds.ShockTank.ShieldOff',,800.00);
			HitPawn.PlaySound(sound'ONSBPSounds.ShockTank.ShieldOff',,800.00);
			A = HitPawn.Spawn(class'ShockComboFlash',,, HitPawn.Location, HitPawn.Rotation);
			if (A != None)
				A.RemoteRole = ROLE_SimulatedProxy;
		}
		if(Chain != None && Pawn(Owner) != None && HitPawn != None)
		{
			Chain.mSpawnVecA = HitPawn.Location;
			Chain.SetRotation(rotator(Pawn(Owner).Location - HitPawn.Location));
		}
	}
}

simulated function Destroyed()
{
	if (Chain != None)
		Chain.Destroy();
	Super.Destroyed();
}

defaultproperties
{
	CheckInterval=0.0500000
	GazeDistance=1200.000
}
