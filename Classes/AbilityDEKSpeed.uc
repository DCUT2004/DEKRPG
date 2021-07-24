class AbilityDEKSpeed extends AbilitySpeed
	abstract;

//Below equations were re-written so they can be cumulative with other abilities that also affect these values
static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	Other.GroundSpeed *= 1.0 + 0.05 * float(AbilityLevel);
	Other.WaterSpeed *= 1.0 + 0.05 * float(AbilityLevel);
	Other.AirSpeed *= 1.0 + 0.05 * float(AbilityLevel);
}

defaultproperties
{
}
