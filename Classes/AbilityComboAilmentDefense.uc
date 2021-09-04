class AbilityComboAilmentDefense extends AbilityCombo
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityDefenseAilmentInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityDefenseAilmentInv(Other.FindInventoryType(class'ComboAbilityDefenseAilmentInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityDefenseAilmentInv');
			Inv.GiveTo(Other);
		}
		if (Inv != None)
		{
			Inv.EffectMultiplier = 1 + default.BaseMultiplier*AbilityLevel;
			Inv.bAll = default.All;
			Inv.bSingle = default.Single;
			Inv.ComboLifespan = default.BaseLifespan;
		}
	}
}

defaultproperties
{
    ExcludingAbilities(0)=Class'DEKRPG209A.AbilityComboAilmentBlind'
	ExcludingAbilities(1)=Class'DEKRPG209A.AbilityComboAilmentCurse'
	ExcludingAbilities(2)=Class'DEKRPG209A.AbilityComboAilmentAttack'
	ExcludingAbilities(3)=Class'DEKRPG209A.AbilityComboAilmentFreeze'
	ExcludingAbilities(4)=Class'DEKRPG209A.AbilityComboAilmentJinx'
	ExcludingAbilities(5)=Class'DEKRPG209A.AbilityComboAilmentPoison'
	AbilityName="Ailment: Defense"
	Description="All targets receive -2.5% damage reduction per level for 25 seconds. If a similar ailment is applied, the effect is stacked. Targets with lowered defense have a red orb.||You can only have one type of Ailment combo at a time.||You must be level 90 to purchase this.||REQUIRED MATERIALS:|You need 5 times the ability level of Nali Fruit and Lumber you wish to purchase. Additionally:||Level 5: 10 Fine Leather, 10 Arctic Suit||Level 6: 20 Fine Leather, 20 Arctic Suit||Level 7: 30 Fine Leather, 30 Arctic Suit||Level 8: 40 Fine Leather, 40 Arctic Suit, 10 Nanite Fragment||Level 9: 45 Fine Leather, 45 Arctic Suit, 25 Nanite Fragment||Level 10: 50 Fine Leather, 50 Arctic Suit, 50 Nanite Fragment||Cost(per level): 5, 10, 15, 20...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
	MaxLevel=10
	StartingCost=5
	CostAddPerLevel=5
	BaseMultiplier=0.025000
	MultiplierAddPerStep=25.000000
	MultiplierStep=1.00000
	BaseLifespan=25.000
	Dispellable=True
	All=True
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialNaliFruit'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialNaliFruit'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialNaliFruit'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialNaliFruit'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialLeather',Class'DEKRPG209A.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(25,25,10,10))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialLeather',Class'DEKRPG209A.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(30,30,20,20))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialLeather',Class'DEKRPG209A.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(35,35,30,30))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialLeather',Class'DEKRPG209A.AbilityMaterialArcticSuit',Class'DEKRPG209A.AbilityMaterialNanite'),RequiredMaterialLevels=(40,40,40,40,10))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialLeather',Class'DEKRPG209A.AbilityMaterialArcticSuit',Class'DEKRPG209A.AbilityMaterialNanite'),RequiredMaterialLevels=(45,45,45,45,25))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialLeather',Class'DEKRPG209A.AbilityMaterialArcticSuit',Class'DEKRPG209A.AbilityMaterialNanite'),RequiredMaterialLevels=(50,50,50,50,50))
}