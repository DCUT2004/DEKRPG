class AbilityComboBuffHeal extends AbilityCombo
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityHealInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityHealInv(Other.FindInventoryType(class'ComboAbilityHealInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityHealInv');
			Inv.GiveTo(Other);
		}
		if (Inv != None)
		{
			Inv.EffectMultiplier = default.BaseMultiplier*AbilityLevel;
			Inv.bAll = default.All;
			Inv.bSingle = default.Single;
		}
	}
}

defaultproperties
{
    ExcludingAbilities(0)=Class'DEKRPG209E.AbilityComboBuffAdrenBoost'
	ExcludingAbilities(1)=Class'DEKRPG209E.AbilityComboBuffAdrenHeal'
	ExcludingAbilities(2)=Class'DEKRPG209E.AbilityComboBuffAttack'
	ExcludingAbilities(3)=Class'DEKRPG209E.AbilityComboBuffCriticalHit'
	ExcludingAbilities(4)=Class'DEKRPG209E.AbilityComboBuffDefense'
	ExcludingAbilities(5)=Class'DEKRPG209E.AbilityComboBuffWard'
	ExcludingAbilities(6)=Class'DEKRPG209E.AbilityComboBuffHPBoost'
	ExcludingAbilities(7)=Class'DEKRPG209E.AbilityComboBuffRegenerate'
	ExcludingAbilities(8)=Class'DEKRPG209E.AbilityComboBuffShieldBoost'
	ExcludingAbilities(9)=Class'DEKRPG209E.AbilityComboBuffShieldHeal'
	AbilityName="Buff: Heal"
	Description="Heals the caster and all allies. Healing over the max health is added as temporary max health, up to double the amount of the caster's original max health.||Each level adds 25 health per level.||You can only have one type of Buff combo at a time.||You must be level 90 to purchase this.||REQUIRED MATERIALS:|You need 5 times the ability level of Nali Fruit and Tarydium Shards you wish to purchase. Additionally:||Level 5: 10 Fine Leather, 10 Honeysuckle Vine||Level 6: 20 Fine Leather, 20 Honeysuckle Vine||Level 7: 30 Fine Leather, 30 Honeysuckle Vine||Level 8: 40 Fine Leather, 40 Honeysuckle Vine, 10 Moss||Level 9: 45 Fine Leather, 45 Honeysuckle Vine, 25 Moss||Level 10: 50 Fine Leather, 50 Honeysuckle Vine, 50 Moss||Cost(per level): 5, 10, 15, 20...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
	MaxLevel=10
	StartingCost=5
	CostAddPerLevel=5
	BaseMultiplier=25.0000
	MultiplierAddPerStep=25.000000
	MultiplierStep=1.00000
	BaseLifespan=10.000
	LifespanAddPerStep=1.0000
	LifespanStep=1.00000
	Dispellable=True
	All=True
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG209E.AbilityMaterialTarydiumShards',Class'DEKRPG209E.AbilityMaterialNaliFruit'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG209E.AbilityMaterialTarydiumShards',Class'DEKRPG209E.AbilityMaterialNaliFruit'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG209E.AbilityMaterialTarydiumShards',Class'DEKRPG209E.AbilityMaterialNaliFruit'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG209E.AbilityMaterialTarydiumShards',Class'DEKRPG209E.AbilityMaterialNaliFruit'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG209E.AbilityMaterialTarydiumShards',Class'DEKRPG209E.AbilityMaterialNaliFruit',Class'DEKRPG209E.AbilityMaterialLeather',Class'DEKRPG209E.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(25,25,10,10))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG209E.AbilityMaterialTarydiumShards',Class'DEKRPG209E.AbilityMaterialNaliFruit',Class'DEKRPG209E.AbilityMaterialLeather',Class'DEKRPG209E.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(30,30,20,20))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG209E.AbilityMaterialTarydiumShards',Class'DEKRPG209E.AbilityMaterialNaliFruit',Class'DEKRPG209E.AbilityMaterialLeather',Class'DEKRPG209E.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(35,35,30,30))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG209E.AbilityMaterialTarydiumShards',Class'DEKRPG209E.AbilityMaterialNaliFruit',Class'DEKRPG209E.AbilityMaterialLeather',Class'DEKRPG209E.AbilityMaterialHoneysuckleVine',Class'DEKRPG209E.AbilityMaterialMoss'),RequiredMaterialLevels=(40,40,40,40,10))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG209E.AbilityMaterialTarydiumShards',Class'DEKRPG209E.AbilityMaterialNaliFruit',Class'DEKRPG209E.AbilityMaterialLeather',Class'DEKRPG209E.AbilityMaterialHoneysuckleVine',Class'DEKRPG209E.AbilityMaterialMoss'),RequiredMaterialLevels=(45,45,45,45,25))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG209E.AbilityMaterialTarydiumShards',Class'DEKRPG209E.AbilityMaterialNaliFruit',Class'DEKRPG209E.AbilityMaterialLeather',Class'DEKRPG209E.AbilityMaterialHoneysuckleVine',Class'DEKRPG209E.AbilityMaterialMoss'),RequiredMaterialLevels=(50,50,50,50,50))
}