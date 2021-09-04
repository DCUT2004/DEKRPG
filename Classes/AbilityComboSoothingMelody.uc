class AbilityComboSoothingMelody extends AbilityCombo
	config(UT2004RPG)
	abstract;
	
var config float BaseAdrenMultiplier, MultiplierAdrenAddPerStep, MultiplierAdrenStep;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilitySoothingMelodyInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilitySoothingMelodyInv(Other.FindInventoryType(class'ComboAbilitySoothingMelodyInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilitySoothingMelodyInv');
			Inv.GiveTo(Other);
		}
		if (Inv != None)
		{
			Inv.EffectMultiplier = (default.BaseMultiplier + (default.MultiplierAddPerStep*AbilityLevel/default.MultiplierStep));
			Inv.AdrenEffectMultiplier = (default.BaseAdrenMultiplier + (default.MultiplieradrenAddPerStep*AbilityLevel/default.MultiplierAdrenStep));
			Inv.ComboLifespan = (default.BaseLifespan + (default.LifespanAddPerStep*AbilityLevel/default.LifespanStep));
			Inv.bDispellable = default.Dispellable;
			Inv.bAll = default.All;
			Inv.bSingle = default.Single;
		}
	}
}

defaultproperties
{
	AbilityName="Soothing Melody"
	Description="1) All allies regenerate 1 health per second for 10 seconds.|2) All allies regenerate 1 adrenaline per second for 10 seconds.||The amount of health regenerated increases by 1 per level.||The amount of adrenaline regenerated increases by 1 every 4 levels.||The duration is increased by 1 second per level.||This effect stacks with similar combos.||Use the combo BBFF(back back forward forward) when you have a combo activation available(number at top left of HUD).||You must be level 90 to purchase this.||REQUIRED MATERIALS:|Level 1: 2 Nali Fruit, 2 Lumber, 2 Combat Boots||Level 2: 6 Nali Fruit, 6 Lumber, 6 Combat Boots||Level 3: 10 Nali Fruit, 10 Lumber, 10 Combat Boots||Level 4: 15 Nali Fruit, 15 Lumber, 15 Combat Boots, 5 Honeysuckle Vines||Level 5: 20 Nali Fruit, 20 Lumber, 20 Combat Boots, 5 Honeysuckle Vines||Level 6: 25 Nali Fruit, 25 Lumber, 25 Combat Boots, 5 Honeysuckle Vines, 5 Fine Leather||Level 7: 27 Nali Fruit, 27 Lumber, 27 Combat Boots, 5 Honeysuckle Vines, 5 Fine Leather, 5 Burning Embers||Level 8: 30 Nali Fruit, 30 Lumber, 30 Combat Boots, 7 Honeysuckle Vines, 7 Fine Leather, 7 Burning Embers||Level 9: 33 Nali Fruit, 33 Lumber, 33 Combat Boots, 9 Honeysuckle Vines, 9 Fine Leather, 9 Burning Embers||Level 10: 36 Nali Fruit, 36 Lumber, 36 Combat Boots, 11 Honeysuckle Vines, 11 Fine Leather, 11 Burning Embers||Level 11: 39 Nali Fruit, 39 Lumber, 39 Combat Boots, 13 Honeysuckle Vines, 13 Fine Leather, 13 Burning Embers, 5 Cosmic Dust|| Level 12: 41 Nali Fruit, 41 Lumber, 41 Combat Boots, 15 Honeysuckle Vines, 15 Fine Leather, 15 Burning Embers, 10 Cosmic Dust||Level 13: 43 Nali Fruit, 43 Lumber, 43 Combat Boots, 17 Honeysuckle Vines, 17 Fine Leather, 17 Burning Embers, 15 Cosmic Dust||Level 14: 45 Nali Fruit, 45 Lumber, 45 Combat Boots, 19 Honeysuckle Vines, 19 Fine Leather, 19 Burning Embers, 20 Cosmic Dust||Level 15: 47 Nali Fruit, 47 Lumber, 47 Combat Boots, 21 Honeysuckle Vines, 21 Fine Leather, 21 Burning Embers, 25 Cosmic Dust||Level 16: 50 Nali Fruit, 50 Lumber, 50 Combat Boots, 30 Honeysuckle Vines, 30 Fine Leather, 30 Burning Embers, 30 Cosmic Dust, 10 Uranium Pellets||Level 17: 50 Nali Fruit, 50 Lumber, 50 Combat Boots, 35 Honeysuckle Vines, 35 Fine Leather, 35 Burning Embers, 35 Cosmic Dust, 20 Uranium Pellets||Level 18: 50 Nali Fruit, 50 Lumber, 50 Combat Boots, 40 Honeysuckle Vines, 40 Fine Leather, 40 Burning Embers, 40 Cosmic Dust, 30 Uranium Pellets||Level 19: 50 Nali Fruit, 50 Lumber, 50 Combat Boots, 45 Honeysuckle Vines, 45 Fine Leather, 45 Burning Embers, 45 Cosmic Dust, 40 Uranium Pellets||Level 20: 50 Nali Fruit, 50 Lumber, 50 Combat Boots, 50 Honeysuckle Vines, 50 Fine Leather, 50 Burning Embers, 50 Cosmic Dust, 50 Uranium Pellets||You can have up to 3 combos at a time. Combos are refundable by using the Refund button while the Combos list is open.||Cost(per level): 2, 4, 6, 8, 10..."
	MaxLevel=20
	StartingCost=2
	CostAddPerLevel=2
	BaseMultiplier=1.0000
	MultiplierAddPerStep=1.000000
	MultiplierStep=1.00000
	BaseAdrenMultiplier=1.00000
	MultiplierAdrenAddPerStep=1.00000
	MultiplierAdrenStep=4.0000
	BaseLifespan=9.000
	LifespanAddPerStep=1.0000
	LifespanStep=1.00000
	Dispellable=True
	All=True
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(2,2,2))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(6,6,6))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(10,10,10))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialCombatBoots',Class'DEKRPG209A.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(15,15,15,5))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialCombatBoots',Class'DEKRPG209A.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(20,20,20,5))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialCombatBoots',Class'DEKRPG209A.AbilityMaterialHoneysuckleVine',Class'DEKRPG209A.AbilityMaterialLeather'),RequiredMaterialLevels=(25,25,25,5,5))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialCombatBoots',Class'DEKRPG209A.AbilityMaterialHoneysuckleVine',Class'DEKRPG209A.AbilityMaterialLeather',Class'DEKRPG209A.AbilityMaterialEmbers'),RequiredMaterialLevels=(27,27,27,5,5,5))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialCombatBoots',Class'DEKRPG209A.AbilityMaterialHoneysuckleVine',Class'DEKRPG209A.AbilityMaterialLeather',Class'DEKRPG209A.AbilityMaterialEmbers'),RequiredMaterialLevels=(30,30,30,7,7,7))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialCombatBoots',Class'DEKRPG209A.AbilityMaterialHoneysuckleVine',Class'DEKRPG209A.AbilityMaterialLeather',Class'DEKRPG209A.AbilityMaterialEmbers'),RequiredMaterialLevels=(33,33,33,9,9,9))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialCombatBoots',Class'DEKRPG209A.AbilityMaterialHoneysuckleVine',Class'DEKRPG209A.AbilityMaterialLeather',Class'DEKRPG209A.AbilityMaterialEmbers'),RequiredMaterialLevels=(36,36,36,11,11,11))
	Materials(10)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialCombatBoots',Class'DEKRPG209A.AbilityMaterialHoneysuckleVine',Class'DEKRPG209A.AbilityMaterialLeather',Class'DEKRPG209A.AbilityMaterialEmbers',Class'DEKRPG209A.AbilityMaterialDust'),RequiredMaterialLevels=(39,39,39,13,13,13,5))
	Materials(11)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialCombatBoots',Class'DEKRPG209A.AbilityMaterialHoneysuckleVine',Class'DEKRPG209A.AbilityMaterialLeather',Class'DEKRPG209A.AbilityMaterialEmbers',Class'DEKRPG209A.AbilityMaterialDust'),RequiredMaterialLevels=(41,41,41,15,15,15,10))
	Materials(12)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialCombatBoots',Class'DEKRPG209A.AbilityMaterialHoneysuckleVine',Class'DEKRPG209A.AbilityMaterialLeather',Class'DEKRPG209A.AbilityMaterialEmbers',Class'DEKRPG209A.AbilityMaterialDust'),RequiredMaterialLevels=(43,43,43,17,17,17,15))
	Materials(13)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialCombatBoots',Class'DEKRPG209A.AbilityMaterialHoneysuckleVine',Class'DEKRPG209A.AbilityMaterialLeather',Class'DEKRPG209A.AbilityMaterialEmbers',Class'DEKRPG209A.AbilityMaterialDust'),RequiredMaterialLevels=(45,45,45,19,19,19,20))
	Materials(14)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialCombatBoots',Class'DEKRPG209A.AbilityMaterialHoneysuckleVine',Class'DEKRPG209A.AbilityMaterialLeather',Class'DEKRPG209A.AbilityMaterialEmbers',Class'DEKRPG209A.AbilityMaterialDust'),RequiredMaterialLevels=(47,47,47,21,21,21,25))
	Materials(15)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialCombatBoots',Class'DEKRPG209A.AbilityMaterialHoneysuckleVine',Class'DEKRPG209A.AbilityMaterialLeather',Class'DEKRPG209A.AbilityMaterialEmbers',Class'DEKRPG209A.AbilityMaterialDust',Class'DEKRPG209A.AbilityMaterialUranium'),RequiredMaterialLevels=(50,50,50,30,30,30,30,10))
	Materials(16)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialCombatBoots',Class'DEKRPG209A.AbilityMaterialHoneysuckleVine',Class'DEKRPG209A.AbilityMaterialLeather',Class'DEKRPG209A.AbilityMaterialEmbers',Class'DEKRPG209A.AbilityMaterialDust',Class'DEKRPG209A.AbilityMaterialUranium'),RequiredMaterialLevels=(50,50,50,35,35,35,35,20))
	Materials(17)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialCombatBoots',Class'DEKRPG209A.AbilityMaterialHoneysuckleVine',Class'DEKRPG209A.AbilityMaterialLeather',Class'DEKRPG209A.AbilityMaterialEmbers',Class'DEKRPG209A.AbilityMaterialDust',Class'DEKRPG209A.AbilityMaterialUranium'),RequiredMaterialLevels=(50,50,50,40,40,40,40,30))
	Materials(18)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialCombatBoots',Class'DEKRPG209A.AbilityMaterialHoneysuckleVine',Class'DEKRPG209A.AbilityMaterialLeather',Class'DEKRPG209A.AbilityMaterialEmbers',Class'DEKRPG209A.AbilityMaterialDust',Class'DEKRPG209A.AbilityMaterialUranium'),RequiredMaterialLevels=(50,50,50,45,45,45,45,40))
	Materials(19)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialCombatBoots',Class'DEKRPG209A.AbilityMaterialHoneysuckleVine',Class'DEKRPG209A.AbilityMaterialLeather',Class'DEKRPG209A.AbilityMaterialEmbers',Class'DEKRPG209A.AbilityMaterialDust',Class'DEKRPG209A.AbilityMaterialUranium'),RequiredMaterialLevels=(50,50,50,50,50,50,50,50))
}