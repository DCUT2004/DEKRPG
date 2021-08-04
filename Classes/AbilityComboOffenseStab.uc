class AbilityComboOffenseStab extends AbilityCombo
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityStabInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityStabInv(Other.FindInventoryType(class'ComboAbilityStabInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityStabInv');
			Inv.GiveTo(Other);
		}
		if (Inv != None)
		{
			Inv.ComboDamage = default.BaseMultiplier;
			Inv.ComboLifespan = default.BaseLifespan;
			Inv.EffectMultiplier = default.MultiplierStep*AbilityLevel;
			Inv.bAll = default.All;
			Inv.bSingle = default.Single;
		}
	}
}

defaultproperties
{
    ExcludingAbilities(0)=Class'DEKRPG208AF.AbilityComboOffensePurifyingStrike'
	ExcludingAbilities(1)=Class'DEKRPG208AF.AbilityComboOffenseRecklessStrike'
	ExcludingAbilities(2)=Class'DEKRPG208AF.AbilityComboOffenseHealingStrike'
	ExcludingAbilities(3)=Class'DEKRPG208AF.AbilityComboOffenseStrike'
	AbilityName="Offense: Stab"
	Description="Deals 100 damage to all targets. Deals an additional 15 damage per second per level to all enemies for 10 seconds. The damage is affected by buffs and ailments.||You can only have one type of Offense combo at a time.||You must be level 90 to purchase this.||REQUIRED MATERIALS:|You need 5 times the ability level of Honeysuckle Vine and Plated Armor you wish to purchase. Additionally:||Level 5: 10 Moss, 10 Pumice||Level 6: 20 Moss, 20 Pumice||Level 7: 30 Moss, 30 Pumice||Level 8: 40 Moss, 40 Pumice||Level 9: 45 Moss, 45 Pumice||Level 10: 50 Moss, 50 Pumice||Cost(per level): 5, 10, 15, 20...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
	MaxLevel=10
	StartingCost=5
	CostAddPerLevel=5
	BaseMultiplier=100.000000
	MultiplierStep=15.00000000
	BaseLifespan=10.000000000
	All=True
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialPlatedArmor',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialPlatedArmor',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialPlatedArmor',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialPlatedArmor',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialPlatedArmor',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialMoss',Class'DEKRPG208AF.AbilityMaterialPumice'),RequiredMaterialLevels=(25,25,10,10))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialPlatedArmor',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialMoss',Class'DEKRPG208AF.AbilityMaterialPumice'),RequiredMaterialLevels=(30,30,20,20))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialPlatedArmor',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialMoss',Class'DEKRPG208AF.AbilityMaterialPumice'),RequiredMaterialLevels=(35,35,30,30))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialPlatedArmor',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialMoss',Class'DEKRPG208AF.AbilityMaterialPumice'),RequiredMaterialLevels=(40,40,40,40))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialPlatedArmor',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialMoss',Class'DEKRPG208AF.AbilityMaterialPumice'),RequiredMaterialLevels=(45,45,45,45))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialPlatedArmor',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialMoss',Class'DEKRPG208AF.AbilityMaterialPumice'),RequiredMaterialLevels=(50,50,50,50))
}