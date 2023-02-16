class AbilityBuildingPoints extends CostRPGAbility
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
    
	Inv.TotalBuildingPoints = AbilityLevel;
   	Inv.MaxBuildings = AbilityLevel;    // a bit of a fudge, but we don't want a separate 20 level MaxBuildings ability

}

defaultproperties
{
     AbilityName="Building Points"
     RequiredAbilities(0)=Class'DEKRPG999X.AbilityLoadedEngineer'
     Description="Allows you to summon more blocks with the Loaded Engineer skill. |Cost (per level): 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21...."
     StartingCost=1
     CostAddPerLevel=1
     MaxLevel=30
}
