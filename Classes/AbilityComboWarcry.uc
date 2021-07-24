class AbilityComboWarcry extends AbilityCombo
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityWarcryInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityWarCryInv(Other.FindInventoryType(class'ComboAbilityWarcryInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityWarCryInv');
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
	AbilityName="Warcry"
	Description="1) All allies receive +10% damage bonus for 10 seconds.||The effect is increased by 1% per level.|The duration is increased by 1 second per level.|This combo stacks with a similar effect at a diminishing rate.|Use the combo BBFF(back back forward forward) when you have a combo activation available(number at top left of HUD).|You must be level 90 to purchase this.||REQUIRED MATERIALS:|Level 1: 2 Nali Fruit, 2 Steel, 2 Lumber||Level 2: 6 Nali Fruit, 6 Steel, 6 Lumber||Level 3: 10 Nali Fruit, 10 Steel, 10 Lumber||Level 4: 15 Nali Fruit, 15 Steel, 15 Lumber, 5 Fine Leather||Level 5: 20 Nali Fruit, 20 Steel, 20 Lumber, 5 Fine Leather||Level 6: 25 Nali Fruit, 25 Steel, 25 Lumber, 5 Fine Leather, 5 Arctic Suit||Level 7: 27 Nali Fruit, 27 Steel, 27 Lumber, 5 Fine Leather, 5 Arctic Suit, 5 Honeysuckle Vines||Level 8: 30 Nali Fruit, 30 Steel, 30 Lumber, 7 Fine Leather, 7 Arctic Suit, 7 Honeysuckle Vines||Level 9: 33 Nali Fruit, 33 Steel, 33 Lumber, 9 Fine Leather, 9 Arctic Suit, 9 Honeysuckle Vines||Level 10: 36 Nali Fruit, 36 Steel, 36 Lumber, 11 Fine Leather, 11 Arctic Suit, 11 Honeysuckle Vines||Level 11: 39 Nali Fruit, 39 Steel, 39 Lumber, 13 Fine Leather, 13 Arctic Suit, 13 Honeysuckle Vines, 5 Cosmic Dust|| Level 12: 41 Nali Fruit, 41 Steel, 41 Lumber, 15 Fine Leather, 15 Arctic Suit, 15 Honeysuckle Vines, 10 Cosmic Dust||Level 13: 43 Nali Fruit, 43 Steel, 43 Lumber, 17 Fine Leather, 17 Arctic Suit, 17 Honeysuckle Vines, 15 Cosmic Dust||Level 14: 45 Nali Fruit, 45 Steel, 45 Lumber, 19 Fine Leather, 19 Arctic Suit, 19 Honeysuckle Vines, 20 Cosmic Dust||Level 15: 47 Nali Fruit, 47 Steel, 47 Lumber, 21 Fine Leather, 21 Arctic Suit, 21 Honeysuckle Vines, 25 Cosmic Dust||Level 16: 50 Nali Fruit, 50 Steel, 50 Lumber, 30 Fine Leather, 30 Arctic Suit, 30 Honeysuckle Vines, 30 Cosmic Dust, 10 Arcane Hourglass||Level 17: 50 Nali Fruit, 50 Steel, 50 Lumb, 35 Fine Leather, 35 Arctic Suit, 35 Honeysuckle Vines, 35 Cosmic Dust, 20 Arcane Hourglass||Level 18: 50 Nali Fruit, 50 Steel, 50 Lumber, 40 Fine Leather, 40 Arctic Suit, 40 Honeysuckle Vines, 40 Cosmic Dust, 30 Arcane Hourglass||Level 19: 50 Nali Fruit, 50 Steel, 50 Lumber, 45 Fine Leather, 45 Arctic Suit, 45 Honeysuckle Vines, 45 Cosmic Dust, 40 Arcane Hourglass||Level 20: 50 Nali Fruit, 50 Steel, 50 Lumber, 50 Fine Leather, 50 Arctic Suit, 50 Honeysuckle Vines, 50 Cosmic Dust, 50 Arcane Hourglass||You can have up to 3 combos at a time. Combos are refundable by using the Refund button while the Combos list is open.||Cost(per level): 2, 4, 6, 8, 10..."
	MaxLevel=20
	StartingCost=2
	CostAddPerLevel=2
	BaseMultiplier=1.1000
	MultiplierAddPerStep=0.010000
	MultiplierStep=1.00000
	BaseLifespan=10.0000
	LifespanAddPerStep=1.0000
	LifespanStep=1.00000
	Dispellable=True
	All=True
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG208AA.AbilityMaterialSteel',Class'DEKRPG208AA.AbilityMaterialNaliFruit',Class'DEKRPG208AA.AbilityMaterialLumber'),RequiredMaterialLevels=(2,2,2))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG208AA.AbilityMaterialSteel',Class'DEKRPG208AA.AbilityMaterialNaliFruit',Class'DEKRPG208AA.AbilityMaterialLumber'),RequiredMaterialLevels=(6,6,6))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG208AA.AbilityMaterialSteel',Class'DEKRPG208AA.AbilityMaterialNaliFruit',Class'DEKRPG208AA.AbilityMaterialLumber'),RequiredMaterialLevels=(10,10,10))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG208AA.AbilityMaterialSteel',Class'DEKRPG208AA.AbilityMaterialNaliFruit',Class'DEKRPG208AA.AbilityMaterialLumber',Class'DEKRPG208AA.AbilityMaterialLeather'),RequiredMaterialLevels=(15,15,15,5))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG208AA.AbilityMaterialSteel',Class'DEKRPG208AA.AbilityMaterialNaliFruit',Class'DEKRPG208AA.AbilityMaterialLumber',Class'DEKRPG208AA.AbilityMaterialLeather'),RequiredMaterialLevels=(20,20,20,5))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG208AA.AbilityMaterialSteel',Class'DEKRPG208AA.AbilityMaterialNaliFruit',Class'DEKRPG208AA.AbilityMaterialLumber',Class'DEKRPG208AA.AbilityMaterialLeather',Class'DEKRPG208AA.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(25,25,25,5,5))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG208AA.AbilityMaterialSteel',Class'DEKRPG208AA.AbilityMaterialNaliFruit',Class'DEKRPG208AA.AbilityMaterialLumber',Class'DEKRPG208AA.AbilityMaterialLeather',Class'DEKRPG208AA.AbilityMaterialArcticSuit',Class'DEKRPG208AA.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(27,27,27,5,5,5))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG208AA.AbilityMaterialSteel',Class'DEKRPG208AA.AbilityMaterialNaliFruit',Class'DEKRPG208AA.AbilityMaterialLumber',Class'DEKRPG208AA.AbilityMaterialLeather',Class'DEKRPG208AA.AbilityMaterialArcticSuit',Class'DEKRPG208AA.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(30,30,30,7,7,7))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG208AA.AbilityMaterialSteel',Class'DEKRPG208AA.AbilityMaterialNaliFruit',Class'DEKRPG208AA.AbilityMaterialLumber',Class'DEKRPG208AA.AbilityMaterialLeather',Class'DEKRPG208AA.AbilityMaterialArcticSuit',Class'DEKRPG208AA.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(33,33,33,9,9,9))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG208AA.AbilityMaterialSteel',Class'DEKRPG208AA.AbilityMaterialNaliFruit',Class'DEKRPG208AA.AbilityMaterialLumber',Class'DEKRPG208AA.AbilityMaterialLeather',Class'DEKRPG208AA.AbilityMaterialArcticSuit',Class'DEKRPG208AA.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(36,36,36,11,11,11))
	Materials(10)=(RequiredMaterials=(Class'DEKRPG208AA.AbilityMaterialSteel',Class'DEKRPG208AA.AbilityMaterialNaliFruit',Class'DEKRPG208AA.AbilityMaterialLumber',Class'DEKRPG208AA.AbilityMaterialLeather',Class'DEKRPG208AA.AbilityMaterialArcticSuit',Class'DEKRPG208AA.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AA.AbilityMaterialDust'),RequiredMaterialLevels=(39,39,39,13,13,13,5))
	Materials(11)=(RequiredMaterials=(Class'DEKRPG208AA.AbilityMaterialSteel',Class'DEKRPG208AA.AbilityMaterialNaliFruit',Class'DEKRPG208AA.AbilityMaterialLumber',Class'DEKRPG208AA.AbilityMaterialLeather',Class'DEKRPG208AA.AbilityMaterialArcticSuit',Class'DEKRPG208AA.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AA.AbilityMaterialDust'),RequiredMaterialLevels=(41,41,41,15,15,15,10))
	Materials(12)=(RequiredMaterials=(Class'DEKRPG208AA.AbilityMaterialSteel',Class'DEKRPG208AA.AbilityMaterialNaliFruit',Class'DEKRPG208AA.AbilityMaterialLumber',Class'DEKRPG208AA.AbilityMaterialLeather',Class'DEKRPG208AA.AbilityMaterialArcticSuit',Class'DEKRPG208AA.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AA.AbilityMaterialDust'),RequiredMaterialLevels=(43,43,43,17,17,17,15))
	Materials(13)=(RequiredMaterials=(Class'DEKRPG208AA.AbilityMaterialSteel',Class'DEKRPG208AA.AbilityMaterialNaliFruit',Class'DEKRPG208AA.AbilityMaterialLumber',Class'DEKRPG208AA.AbilityMaterialLeather',Class'DEKRPG208AA.AbilityMaterialArcticSuit',Class'DEKRPG208AA.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AA.AbilityMaterialDust'),RequiredMaterialLevels=(45,45,45,19,19,19,20))
	Materials(14)=(RequiredMaterials=(Class'DEKRPG208AA.AbilityMaterialSteel',Class'DEKRPG208AA.AbilityMaterialNaliFruit',Class'DEKRPG208AA.AbilityMaterialLumber',Class'DEKRPG208AA.AbilityMaterialLeather',Class'DEKRPG208AA.AbilityMaterialArcticSuit',Class'DEKRPG208AA.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AA.AbilityMaterialDust'),RequiredMaterialLevels=(47,47,47,21,21,21,25))
	Materials(15)=(RequiredMaterials=(Class'DEKRPG208AA.AbilityMaterialSteel',Class'DEKRPG208AA.AbilityMaterialNaliFruit',Class'DEKRPG208AA.AbilityMaterialLumber',Class'DEKRPG208AA.AbilityMaterialLeather',Class'DEKRPG208AA.AbilityMaterialArcticSuit',Class'DEKRPG208AA.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AA.AbilityMaterialDust',Class'DEKRPG208AA.AbilityMaterialHourglass'),RequiredMaterialLevels=(50,50,50,30,30,30,30,10))
	Materials(16)=(RequiredMaterials=(Class'DEKRPG208AA.AbilityMaterialSteel',Class'DEKRPG208AA.AbilityMaterialNaliFruit',Class'DEKRPG208AA.AbilityMaterialLumber',Class'DEKRPG208AA.AbilityMaterialLeather',Class'DEKRPG208AA.AbilityMaterialArcticSuit',Class'DEKRPG208AA.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AA.AbilityMaterialDust',Class'DEKRPG208AA.AbilityMaterialHourglass'),RequiredMaterialLevels=(50,50,50,35,35,35,35,20))
	Materials(17)=(RequiredMaterials=(Class'DEKRPG208AA.AbilityMaterialSteel',Class'DEKRPG208AA.AbilityMaterialNaliFruit',Class'DEKRPG208AA.AbilityMaterialLumber',Class'DEKRPG208AA.AbilityMaterialLeather',Class'DEKRPG208AA.AbilityMaterialArcticSuit',Class'DEKRPG208AA.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AA.AbilityMaterialDust',Class'DEKRPG208AA.AbilityMaterialHourglass'),RequiredMaterialLevels=(50,50,50,40,40,40,40,30))
	Materials(18)=(RequiredMaterials=(Class'DEKRPG208AA.AbilityMaterialSteel',Class'DEKRPG208AA.AbilityMaterialNaliFruit',Class'DEKRPG208AA.AbilityMaterialLumber',Class'DEKRPG208AA.AbilityMaterialLeather',Class'DEKRPG208AA.AbilityMaterialArcticSuit',Class'DEKRPG208AA.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AA.AbilityMaterialDust',Class'DEKRPG208AA.AbilityMaterialHourglass'),RequiredMaterialLevels=(50,50,50,45,45,45,45,40))
	Materials(19)=(RequiredMaterials=(Class'DEKRPG208AA.AbilityMaterialSteel',Class'DEKRPG208AA.AbilityMaterialNaliFruit',Class'DEKRPG208AA.AbilityMaterialLumber',Class'DEKRPG208AA.AbilityMaterialLeather',Class'DEKRPG208AA.AbilityMaterialArcticSuit',Class'DEKRPG208AA.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AA.AbilityMaterialDust',Class'DEKRPG208AA.AbilityMaterialHourglass'),RequiredMaterialLevels=(50,50,50,50,50,50,50,50))
}