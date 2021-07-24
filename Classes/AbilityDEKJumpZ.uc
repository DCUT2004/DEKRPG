class AbilityDEKJumpZ extends AbilityJumpZ
	abstract;

//Below equations were re-written so they can be cumulative with other abilities that also affect these values
static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	Other.JumpZ *=  1.0 + 0.1 * float(AbilityLevel);
}

defaultproperties
{
}
