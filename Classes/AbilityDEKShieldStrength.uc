class AbilityDEKShieldStrength extends AbilityShieldStrength
	abstract
	config(UT2004RPG);

//Below equations were re-written so they can be cumulative with other abilities that also affect these values
static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	if (xPawn(Other) != None)
		xPawn(Other).ShieldStrengthMax += 25 * AbilityLevel;
}

defaultproperties
{
}
