class AbilityComboWarmEmbrace extends AbilityCombo
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityWarmEmbraceInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityWarmEmbraceInv(Other.FindInventoryType(class'ComboAbilityWarmEmbraceInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityWarmEmbraceInv');
			Inv.GiveTo(Other);
		}
		if (Inv != None)
		{
			Inv.EffectMultiplier = (default.BaseMultiplier + (default.MultiplierAddPerStep*AbilityLevel/default.MultiplierStep));
			Inv.ComboLifespan = (default.BaseLifespan + (default.LifespanAddPerStep*AbilityLevel/default.LifespanStep));
			Inv.bDispellable = default.Dispellable;
			Inv.bAll = default.All;
			Inv.bSingle = default.Single;
		}
	}
}

defaultproperties
{
	AbilityName="Warm Embrace"
	Description="1) All allies receive +10% damage reduction for 10 seconds.||The effect is increased by 1% per level.|The duration is increased by 1 second per level.|This combo stacks with a similar effect at a diminishing rate.|Use the combo BBFF(back back forward forward) when you have a combo activation available(number at top left of HUD).|You must be level 90 to purchase this.||REQUIRED MATERIALS:|Level 1: 2 Nali Fruit, 2 Gloves, 2 Combat Boots||Level 2: 6 Nali Fruit, 6 Gloves, 6 Combat Boots||Level 3: 10 Nali Fruit, 10 Gloves, 10 Combat Boots||Level 4: 15 Nali Fruit, 15 Gloves, 15 Combat Boots, 5 Fine Leather||Level 5: 20 Nali Fruit, 20 Gloves, 20 Combat Boots, 5 Fine Leather||Level 6: 25 Nali Fruit, 25 Gloves, 25 Combat Boots, 5 Fine Leather, 5 Plated Armor||Level 7: 27 Nali Fruit, 27 Gloves, 27 Combat Boots, 5 Fine Leather, 5 Plated Armor, 5 Honeysuckle Vines||Level 8: 30 Nali Fruit, 30 Gloves, 30 Combat Boots, 7 Fine Leather, 7 Plated Armor, 7 Honeysuckle Vines||Level 9: 33 Nali Fruit, 33 Gloves, 33 Combat Boots, 9 Fine Leather, 9 Plated Armor, 9 Honeysuckle Vines||Level 10: 36 Nali Fruit, 36 Gloves, 36 Combat Boots, 11 Fine Leather, 11 Plated Armor, 11 Honeysuckle Vines||Level 11: 39 Nali Fruit, 39 Gloves, 39 Combat Boots, 13 Fine Leather, 13 Plated Armor, 13 Honeysuckle Vines, 5 Nanite Fragment|| Level 12: 41 Nali Fruit, 41 Gloves, 41 Combat Boots, 15 Fine Leather, 15 Plated Armor, 15 Honeysuckle Vines, 10 Nanite Fragment||Level 13: 43 Nali Fruit, 43 Gloves, 43 Combat Boots, 17 Fine Leather, 17 Plated Armor, 17 Honeysuckle Vines, 15 Nanite Fragment||Level 14: 45 Nali Fruit, 45 Gloves, 45 Combat Boots, 19 Fine Leather, 19 Plated Armor, 19 Honeysuckle Vines, 20 Nanite Fragment||Level 15: 47 Nali Fruit, 47 Gloves, 47 Combat Boots, 21 Fine Leather, 21 Plated Armor, 21 Honeysuckle Vines, 25 Nanite Fragment||Level 16: 50 Nali Fruit, 50 Gloves, 50 Combat Boots, 30 Fine Leather, 30 Plated Armor, 30 Honeysuckle Vines, 30 Nanite Fragment, 10 Universal Translator||Level 17: 50 Nali Fruit, 50 Gloves, 50 Lumb, 35 Fine Leather, 35 Plated Armor, 35 Honeysuckle Vines, 35 Nanite Fragment, 20 Universal Translator||Level 18: 50 Nali Fruit, 50 Gloves, 50 Combat Boots, 40 Fine Leather, 40 Plated Armor, 40 Honeysuckle Vines, 40 Nanite Fragment, 30 Universal Translator||Level 19: 50 Nali Fruit, 50 Gloves, 50 Combat Boots, 45 Fine Leather, 45 Plated Armor, 45 Honeysuckle Vines, 45 Nanite Fragment, 40 Universal Translator||Level 20: 50 Nali Fruit, 50 Gloves, 50 Combat Boots, 50 Fine Leather, 50 Plated Armor, 50 Honeysuckle Vines, 50 Nanite Fragment, 50 Universal Translator||You can have up to 3 combos at a time. Combos are refundable by using the Refund button while the Combos list is open.||Cost(per level): 2, 4, 6, 8, 10..."
	MaxLevel=20
	StartingCost=2
	CostAddPerLevel=2
	BaseMultiplier=0.9000
	MultiplierAddPerStep=-0.010000
	MultiplierStep=1.00000
	BaseLifespan=10.0000
	LifespanAddPerStep=1.0000
	LifespanStep=1.00000
	Dispellable=True
	All=True
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialGloves',Class'DEKRPG208AJ.AbilityMaterialNaliFruit',Class'DEKRPG208AJ.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(2,2,2))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialGloves',Class'DEKRPG208AJ.AbilityMaterialNaliFruit',Class'DEKRPG208AJ.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(6,6,6))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialGloves',Class'DEKRPG208AJ.AbilityMaterialNaliFruit',Class'DEKRPG208AJ.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(10,10,10))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialGloves',Class'DEKRPG208AJ.AbilityMaterialNaliFruit',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialLeather'),RequiredMaterialLevels=(15,15,15,5))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialGloves',Class'DEKRPG208AJ.AbilityMaterialNaliFruit',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialLeather'),RequiredMaterialLevels=(20,20,20,5))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialGloves',Class'DEKRPG208AJ.AbilityMaterialNaliFruit',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialLeather',Class'DEKRPG208AJ.AbilityMaterialPlatedArmor'),RequiredMaterialLevels=(25,25,25,5,5))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialGloves',Class'DEKRPG208AJ.AbilityMaterialNaliFruit',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialLeather',Class'DEKRPG208AJ.AbilityMaterialPlatedArmor',Class'DEKRPG208AJ.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(27,27,27,5,5,5))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialGloves',Class'DEKRPG208AJ.AbilityMaterialNaliFruit',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialLeather',Class'DEKRPG208AJ.AbilityMaterialPlatedArmor',Class'DEKRPG208AJ.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(30,30,30,7,7,7))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialGloves',Class'DEKRPG208AJ.AbilityMaterialNaliFruit',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialLeather',Class'DEKRPG208AJ.AbilityMaterialPlatedArmor',Class'DEKRPG208AJ.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(33,33,33,9,9,9))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialGloves',Class'DEKRPG208AJ.AbilityMaterialNaliFruit',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialLeather',Class'DEKRPG208AJ.AbilityMaterialPlatedArmor',Class'DEKRPG208AJ.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(36,36,36,11,11,11))
	Materials(10)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialGloves',Class'DEKRPG208AJ.AbilityMaterialNaliFruit',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialLeather',Class'DEKRPG208AJ.AbilityMaterialPlatedArmor',Class'DEKRPG208AJ.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AJ.AbilityMaterialNanite'),RequiredMaterialLevels=(39,39,39,13,13,13,5))
	Materials(11)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialGloves',Class'DEKRPG208AJ.AbilityMaterialNaliFruit',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialLeather',Class'DEKRPG208AJ.AbilityMaterialPlatedArmor',Class'DEKRPG208AJ.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AJ.AbilityMaterialNanite'),RequiredMaterialLevels=(41,41,41,15,15,15,10))
	Materials(12)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialGloves',Class'DEKRPG208AJ.AbilityMaterialNaliFruit',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialLeather',Class'DEKRPG208AJ.AbilityMaterialPlatedArmor',Class'DEKRPG208AJ.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AJ.AbilityMaterialNanite'),RequiredMaterialLevels=(43,43,43,17,17,17,15))
	Materials(13)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialGloves',Class'DEKRPG208AJ.AbilityMaterialNaliFruit',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialLeather',Class'DEKRPG208AJ.AbilityMaterialPlatedArmor',Class'DEKRPG208AJ.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AJ.AbilityMaterialNanite'),RequiredMaterialLevels=(45,45,45,19,19,19,20))
	Materials(14)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialGloves',Class'DEKRPG208AJ.AbilityMaterialNaliFruit',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialLeather',Class'DEKRPG208AJ.AbilityMaterialPlatedArmor',Class'DEKRPG208AJ.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AJ.AbilityMaterialNanite'),RequiredMaterialLevels=(47,47,47,21,21,21,25))
	Materials(15)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialGloves',Class'DEKRPG208AJ.AbilityMaterialNaliFruit',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialLeather',Class'DEKRPG208AJ.AbilityMaterialPlatedArmor',Class'DEKRPG208AJ.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AJ.AbilityMaterialNanite',Class'DEKRPG208AJ.AbilityMaterialTranslator'),RequiredMaterialLevels=(50,50,50,30,30,30,30,10))
	Materials(16)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialGloves',Class'DEKRPG208AJ.AbilityMaterialNaliFruit',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialLeather',Class'DEKRPG208AJ.AbilityMaterialPlatedArmor',Class'DEKRPG208AJ.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AJ.AbilityMaterialNanite',Class'DEKRPG208AJ.AbilityMaterialTranslator'),RequiredMaterialLevels=(50,50,50,35,35,35,35,20))
	Materials(17)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialGloves',Class'DEKRPG208AJ.AbilityMaterialNaliFruit',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialLeather',Class'DEKRPG208AJ.AbilityMaterialPlatedArmor',Class'DEKRPG208AJ.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AJ.AbilityMaterialNanite',Class'DEKRPG208AJ.AbilityMaterialTranslator'),RequiredMaterialLevels=(50,50,50,40,40,40,40,30))
	Materials(18)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialGloves',Class'DEKRPG208AJ.AbilityMaterialNaliFruit',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialLeather',Class'DEKRPG208AJ.AbilityMaterialPlatedArmor',Class'DEKRPG208AJ.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AJ.AbilityMaterialNanite',Class'DEKRPG208AJ.AbilityMaterialTranslator'),RequiredMaterialLevels=(50,50,50,45,45,45,45,40))
	Materials(19)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialGloves',Class'DEKRPG208AJ.AbilityMaterialNaliFruit',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialLeather',Class'DEKRPG208AJ.AbilityMaterialPlatedArmor',Class'DEKRPG208AJ.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AJ.AbilityMaterialNanite',Class'DEKRPG208AJ.AbilityMaterialTranslator'),RequiredMaterialLevels=(50,50,50,50,50,50,50,50))
}