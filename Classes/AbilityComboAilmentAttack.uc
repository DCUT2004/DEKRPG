class AbilityComboAilmentAttack extends AbilityCombo
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityAttackAilmentInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityAttackAilmentInv(Other.FindInventoryType(class'ComboAbilityAttackAilmentInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityAttackAilmentInv');
			Inv.GiveTo(Other);
		}
		if (Inv != None)
		{
			Inv.EffectMultiplier = abs((default.BaseMultiplier*AbilityLevel) - 1);
			Inv.bAll = default.All;
			Inv.bSingle = default.Single;
			Inv.ComboLifespan = default.BaseLifespan;
		}
	}
}

defaultproperties
{
    ExcludingAbilities(0)=Class'DEKRPG999X.AbilityComboAilmentBlind'
	ExcludingAbilities(1)=Class'DEKRPG999X.AbilityComboAilmentCurse'
	ExcludingAbilities(2)=Class'DEKRPG999X.AbilityComboAilmentDefense'
	ExcludingAbilities(3)=Class'DEKRPG999X.AbilityComboAilmentFreeze'
	ExcludingAbilities(4)=Class'DEKRPG999X.AbilityComboAilmentJinx'
	ExcludingAbilities(5)=Class'DEKRPG999X.AbilityComboAilmentPoison'
	AbilityName="Ailment: Attack"
	Description="All targets receive -2.5% damage bonus per level for 25 seconds. If a similar ailment is applied, the effect is stacked. Targets with lowered attack have a red berserk ring.||You can only have one type of Ailment combo at a time.||You must be level 90 to purchase this.||REQUIRED MATERIALS:|You need 5 times the ability level of Nali Fruit and Steel you wish to purchase. Additionally:||Level 5: 10 Fine Leather, 10 Burning Embers||Level 6: 20 Fine Leather, 20 Burning Embers||Level 7: 30 Fine Leather, 30 Burning Embers||Level 8: 40 Fine Leather, 40 Burning Embers, 10 Nanite Fragment||Level 9: 45 Fine Leather, 45 Burning Embers, 25 Nanite Fragment||Level 10: 50 Fine Leather, 50 Burning Embers, 50 Nanite Fragment||Cost(per level): 5, 10, 15, 20...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
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
	Materials(0)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialNaliFruit'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialNaliFruit'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialNaliFruit'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialNaliFruit'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialNaliFruit',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialEmbers'),RequiredMaterialLevels=(25,25,10,10))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialNaliFruit',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialEmbers'),RequiredMaterialLevels=(30,30,20,20))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialNaliFruit',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialEmbers'),RequiredMaterialLevels=(35,35,30,30))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialNaliFruit',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialNanite'),RequiredMaterialLevels=(40,40,40,40,10))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialNaliFruit',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialNanite'),RequiredMaterialLevels=(45,45,45,45,25))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialNaliFruit',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialNanite'),RequiredMaterialLevels=(50,50,50,50,50))
}