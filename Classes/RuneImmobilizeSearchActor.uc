class RuneImmobilizeSearchActor extends Actor;

function Pawn Search(float ImmobilizeRadius, Vector HitLocation)
{
	local Controller C, NextC;
	local float ClosestDist;
	local Pawn Target;
	
	C = Level.ControllerList;
	ClosestDist = ImmobilizeRadius;
	
	while (C != None)
	{
		NextC = C.NextController;
		if (C != None && C.Pawn != None && C.Pawn.Health > 0 && C.Pawn.GetTeamNum() != Instigator.GetTeamNum() && VSize(C.Pawn.Location - HitLocation) <= ImmobilizeRadius && FastTrace(C.Pawn.Location, HitLocation))
			if (VSize(C.Pawn.Location - HitLocation) < ClosestDist)
			{
				ClosestDist = VSize(C.Pawn.Location - HitLocation);
				Target = C.Pawn;
			}
		C = NextC;
	}
	
	if (Target != None)
		return Target;
	return None;
}

defaultproperties
{
	bHidden=True
	bAcceptsProjectors=False
	bIgnoreEncroachers=True
	bIgnoreOutOfWorld=True
}
