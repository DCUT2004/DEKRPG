class AbilityComboOffenseStrike extends AbilityCombo
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityStrikeInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityStrikeInv(Other.FindInventoryType(class'ComboAbilityStrikeInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityStrikeInv');
			Inv.GiveTo(Other);
		}
		if (Inv != None)
		{
			Inv.ComboDamage = default.BaseMultiplier*AbilityLevel;
			Inv.bAll = default.All;
			Inv.bSingle = default.Single;
		}
	}
}

defaultproperties
{
    ExcludingAbilities(0)=Class'DEKRPG209C.AbilityComboOffensePurifyingStrike'
	ExcludingAbilities(1)=Class'DEKRPG209C.AbilityComboOffenseRecklessStrike'
	ExcludingAbilities(2)=Class'DEKRPG209C.AbilityComboOffenseStab'
	ExcludingAbilities(3)=Class'DEKRPG209C.AbilityComboOffenseHealingStrike'
	AbilityName="Offense: Strike"
	Description="Deals 30 damage per level to all targets. The damage is affected by buffs and ailments.||You can only have one type of Offense combo at a time.||You must be level 90 to purchase this.||REQUIRED MATERIALS:|You need 5 times the ability level of Honeysuckle Vine and Fine Leather you wish to purchase. Additionally:||Level 5: 10 Moss, 10 Pumice||Level 6: 20 Moss, 20 Pumice||Level 7: 30 Moss, 30 Pumice||Level 8: 40 Moss, 40 Pumice||Level 9: 45 Moss, 45 Pumice||Level 10: 50 Moss, 50 Pumice||Cost(per level): 5, 10, 15, 20...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
	MaxLevel=10
	StartingCost=5
	CostAddPerLevel=5
	BaseMultiplier=20.000000
	All=True
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG209C.AbilityMaterialLeather',Class'DEKRPG209C.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG209C.AbilityMaterialLeather',Class'DEKRPG209C.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG209C.AbilityMaterialLeather',Class'DEKRPG209C.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG209C.AbilityMaterialLeather',Class'DEKRPG209C.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG209C.AbilityMaterialLeather',Class'DEKRPG209C.AbilityMaterialHoneysuckleVine',Class'DEKRPG209C.AbilityMaterialMoss',Class'DEKRPG209C.AbilityMaterialPumice'),RequiredMaterialLevels=(25,25,10,10))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG209C.AbilityMaterialLeather',Class'DEKRPG209C.AbilityMaterialHoneysuckleVine',Class'DEKRPG209C.AbilityMaterialMoss',Class'DEKRPG209C.AbilityMaterialPumice'),RequiredMaterialLevels=(30,30,20,20))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG209C.AbilityMaterialLeather',Class'DEKRPG209C.AbilityMaterialHoneysuckleVine',Class'DEKRPG209C.AbilityMaterialMoss',Class'DEKRPG209C.AbilityMaterialPumice'),RequiredMaterialLevels=(35,35,30,30))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG209C.AbilityMaterialLeather',Class'DEKRPG209C.AbilityMaterialHoneysuckleVine',Class'DEKRPG209C.AbilityMaterialMoss',Class'DEKRPG209C.AbilityMaterialPumice'),RequiredMaterialLevels=(40,40,40,40))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG209C.AbilityMaterialLeather',Class'DEKRPG209C.AbilityMaterialHoneysuckleVine',Class'DEKRPG209C.AbilityMaterialMoss',Class'DEKRPG209C.AbilityMaterialPumice'),RequiredMaterialLevels=(45,45,45,45))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG209C.AbilityMaterialLeather',Class'DEKRPG209C.AbilityMaterialHoneysuckleVine',Class'DEKRPG209C.AbilityMaterialMoss',Class'DEKRPG209C.AbilityMaterialPumice'),RequiredMaterialLevels=(50,50,50,50))
}