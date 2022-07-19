class RuneImmobilizeFire extends RuneInstantFire
	config(DEKWeapons);
	
var config float ImmobilizeLifespan, RegenAmount, ImmobilizeRadius;

//If we hit a pawn, immobilize it
//Otherwise, do a search for nearby pawns that we could potentially immobilize
function DoTrace(Vector Start, Rotator Dir)
{
    local Vector X, End, HitLocation, HitNormal;
    local Actor Other;
	local Pawn Victim;
	local RuneImmobilizeSearchActor A;

	MaxRange();

	X = Vector(Dir);
	End = Start + TraceRange * X;

	Other = Weapon.Trace(HitLocation, HitNormal, End, Start, true);

	if ( Other != None && Other != Instigator)
	{
		if (Pawn(Other) != None && Pawn(Other).Health > 0 && Pawn(Other).GetTeamNum() != Instigator.GetTeamNum())
		{
			GiveImmobilize(Pawn(Other));
		}
		else	//Do a search for nearby pawns. Can't do a ForEach search because this class doesn't extends Object, not Actor. Spawn a dummy actor instead
		{
			A = Instigator.Spawn(Class'RuneImmobilizeSearchActor', Instigator, , HitLocation);
			if (A != None)
			{
				Victim = A.Search(ImmobilizeRadius, HitLocation);
				if (Victim != None)
					GiveImmobilize(Victim);
				A.Destroy();
			}
		}
	}
	else
	{
		HitLocation = End;
		HitNormal = Vect(0,0,0);
		WeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(Other,HitLocation,HitNormal);
	}
}

function GiveImmobilize(Pawn P)
{
	local ImmobilizeInv Inv;
	
	Inv = ImmobilizeInv(P.FindInventoryType(Class'ImmobilizeInv'));
	if (Inv == None)
	{
		Inv = P.Spawn(Class'ImmobilizeInv', Instigator);
		Inv.PawnOwner = Instigator;
		Inv.Lifespan = ImmobilizeLifespan;
		Inv.RegenAmount = RegenAmount;
		Inv.GiveTo(P);
		Instigator.PlaySound(Sound'DEKRPG999X.TurretSounds.SolarTurretAltCharge', SLOT_None, Instigator.TransientSoundVolume*1.75);
	}
}


defaultproperties
{
	 ImmobilizeLifespan=6.000000
	 ImmobilizeRadius=200.00000
	 RegenAmount=1
	 AdrenCost=5
     FireRate=7.0000000
     bReflective=False
     TraceRange=17000.000000
     bModeExclusive=False
}
