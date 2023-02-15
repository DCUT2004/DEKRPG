class AbilityMaxTurrets extends CostRPGAbility
	abstract;

static simulated function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local EngineerPointsInv Inv;

	if(Monster(Other) != None)
		return; //Not for pets

	Inv = EngineerPointsInv(Other.FindInventoryType(class'EngineerPointsInv'));

	if(Inv == None)
	{
		Inv = Other.spawn(class'EngineerPointsInv', Other,,, rot(0,0,0));
		if(Inv == None)
			return; //get em next pass I guess?

		Inv.giveTo(Other);
	}
    
	Inv.MaxTurrets = AbilityLevel;
}

defaultproperties
{
     AbilityName="Maximum Number of Turrets"
     Description="Learn turrets to summon. At each level, you can summon more items. You need to have a level six times the ability level you wish to purchase. |Cost (per level): 5"
     StartingCost=5
     MaxLevel=20
}
