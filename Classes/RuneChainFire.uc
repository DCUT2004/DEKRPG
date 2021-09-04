class RuneChainFire extends RuneInstantFire
	config(DEKWeapons);

var class<xEmitter> HitEmitterClass;
var config float MaxStepRange;
var config int FirstDamage;
var config float StepDamageFraction;
var config int MaxSteps;				// maximum number of steps. 0 means just hit target like beam. 1 means one additional step

var array<Pawn> ChainHitPawn;			// list of those we have hit
var array<int> ChainStepNumber;			// what step number they were hit with
var array<vector> ChainHitLocation;		// location of hit, just in case they are dead
var array<int> ChainActive;				// if 1, this pawn has yet to fire (bool didnt work for some reason)

function DoTrace(Vector Start, Rotator Dir)
{
    local Vector X, End, HitLocation, HitNormal;
    local Actor Other, A;

	MaxRange();

	X = Vector(Dir);
	End = Start + TraceRange * X;

	Other = Weapon.Trace(HitLocation, HitNormal, End, Start, true);

	if ( Other != None && Pawn(Other) != None && Pawn(Other).Health > 0 && Instigator != None && Pawn(Other).GetTeamNum() != Instigator.GetTeamNum())
	{
		ChainHitPawn.length = 0;
		ChainStepNumber.length = 0;
		ChainHitLocation.length = 0;
		ChainActive.length = 0;
		A = spawn(class'BlueSparks',,, Instigator.Location);
		if (A != None)
		{
			A.RemoteRole = ROLE_SimulatedProxy;
			A.PlaySound(Sound'WeaponSounds.LightningGun.LightningGunImpact',,1.5*Instigator.TransientSoundVolume,,Instigator.TransientSoundRadius);
		}
		ChainPawn(Pawn(Other), HitLocation, (Start + Instigator.Location)/2, 0);
	}
	SetTimer(0.2, true);
}

function ChainPawn(Pawn Victim, vector HitLocation, vector StartLocation, int StepNumber)
{
	local Actor A;
	local int DamageToDo;
	local xEmitter HitEmitter;
	local int i;
	local float CurPercent;

	if (StepNumber > MaxSteps)
		return;	// shouldn't have got this far
		
	// now check if Victim is already in the list
	for (i=0; i< ChainHitPawn.length; i++)
		if (ChainHitPawn[i] == Victim)
			return;		// already got.

	if (StepNumber < MaxSteps)
	{
		// add this victim to the list of those chaining
		ChainHitPawn[ChainHitPawn.length] = Victim;
		ChainStepNumber[ChainStepNumber.length] = StepNumber;
		ChainHitLocation[ChainHitLocation.length] = HitLocation;
		ChainActive[ChainActive.length] = 1;
	}

	// first draw the emitter.
	HitEmitter = spawn(HitEmitterClass,,,StartLocation , rotator(HitLocation - StartLocation));
	if (HitEmitter != None)
	{
		HitEmitter.mSpawnVecA = Victim.Location;
	}

	A = spawn(class'BlueSparks',,, Victim.Location);
	if (A != None)
	{
		A.RemoteRole = ROLE_SimulatedProxy;
		A.PlaySound(Sound'WeaponSounds.LightningGun.LightningGunImpact',,1.5*Victim.TransientSoundVolume,,Victim.TransientSoundRadius);
	}

	// work out what factor we are at
	CurPercent = 1.0;
	for (i=0; i<StepNumber; i++)
		CurPercent *= StepDamageFraction;
	// damage it. First limit the damage. Otherwise get instagibs which are not fair
    DamageToDo = FirstDamage * CurPercent;
	Victim.TakeDamage(DamageToDo, Instigator, Victim.Location, vect(0,0,0), DamageType);
}

function Timer()
{
	local Controller C, NextC;
	local vector Ploc;
	local int i, j, besti;
	local bool bGotLive;
	local int minStepNo;
	local float CurPercent;
	local int NumActiveChainEntries;
		
	if (Instigator == None || Instigator.Controller == None || ChainHitPawn.length == 0)
	{
		// not worth continuing
		ChainHitPawn.length = 0;
		ChainStepNumber.length = 0;
		ChainHitLocation.length = 0;
		ChainActive.length = 0;
		SetTimer(0, false);
		return;		
	}
	
	// now see if we have anything left to chain
	bGotLive = false;
	for (i=0;i<ChainActive.length;i++)
		if (ChainActive[i] > 0)
			bGotLive = true;
	if (!bGotLive)
	{
		// not worth continuing
		ChainHitPawn.length = 0;
		ChainStepNumber.length = 0;
		ChainHitLocation.length = 0;
		ChainActive.length = 0;
		SetTimer(0, false);
		return;		
	}

	// lets add one to each step
	for (i=0;i<ChainStepNumber.length;i++)
		ChainStepNumber[i]++;
	NumActiveChainEntries = ChainStepNumber.length;
	
	// ok we have stuff in the chain. Lets hit it.	
	C = Level.ControllerList;
	while (C != None)
	{
		// loop round finding other enemies close by
		NextC = C.NextController;
		if ( C.Pawn != None && C.Pawn != Instigator && C.Pawn.Health > 0 && !C.SameTeamAs(Instigator.Controller) && C.bGodMode == False && PhantomDeathGhostInv(C.Pawn.FindInventoryType(class'PhantomDeathGhostInv')) == None)
		{
			// lets see if already in list
			bGotLive = false;
			for (i=0;i<ChainHitPawn.length;i++)
				if (ChainHitPawn[i] == C.Pawn)
					bGotLive = true;
			
			if (!bGotLive)
			{			
				// could be hit. Lets see if in range of a target
				minStepNo = MaxSteps+1;
				besti = -1;
				for (i=0;i<ChainHitPawn.length;i++)
				{
					if (ChainHitPawn[i] == None)
						Ploc = ChainHitLocation[i];
					else
						Ploc = ChainHitPawn[i].Location;
					if (ChainStepNumber[i] <= MaxSteps &&  C.Pawn.FastTrace(C.Pawn.Location, Ploc))
					{
						// can see it, but is it in range
						// work out what factor we are at
						CurPercent = 1.0;
						for (j=1; j<ChainStepNumber[i]; j++)
							CurPercent *= StepDamageFraction;
						if (VSize(C.Pawn.Location - Ploc) < (MaxStepRange * CurPercent) && minStepNo > ChainStepNumber[i])
						{
							minStepNo = ChainStepNumber[i];
							besti = i;
						}
					}
				}
				if (besti >= 0)
				{
					// we have a new target
					if (ChainHitPawn[besti] == None)
						Ploc = ChainHitLocation[besti];
					else
						Ploc = ChainHitPawn[besti].Location;
					ChainPawn(C.Pawn, C.Pawn.Location, Ploc, minStepNo);
				}
			
			}		
		}

		C = NextC;
	}

	// ok, so we have fired from the ones we already had.		
	for (i=0;i<NumActiveChainEntries;i++)
		ChainActive[i] = 0;
}

defaultproperties
{
	 AdrenCost=10.0000
	 TraceRange=3000.00000
     HitEmitterClass=Class'DEKRPG209A.ChainLightningEmitter'
     DamageType=Class'DEKRPG209A.DamTypeRuneLightningChain'
     MaxStepRange=650.000000
     FirstDamage=180
     StepDamageFraction=0.700000
     MaxSteps=3
     FireRate=2.000000
     FireSound=Sound'WeaponSounds.BaseFiringSounds.BLightningGunFire'
     bReflective=True
     Momentum=0.000000
}
