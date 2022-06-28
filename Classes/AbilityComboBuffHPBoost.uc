class AbilityComboBuffHPBoost extends AbilityCombo
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityHPBoostInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityHPBoostInv(Other.FindInventoryType(class'ComboAbilityHPBoostInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityHPBoostInv');
			Inv.GiveTo(Other);
		}
		if (Inv != None)
		{
			Inv.EffectMultiplier = default.MultiplierStep*AbilityLevel;
			Inv.bAll = default.All;
			Inv.bSingle = default.Single;
		}
	}
}

defaultproperties
{
    ExcludingAbilities(0)=Class'DEKRPG209D.AbilityComboBuffAdrenBoost'
	ExcludingAbilities(1)=Class'DEKRPG209D.AbilityComboBuffAdrenHeal'
	ExcludingAbilities(2)=Class'DEKRPG209D.AbilityComboBuffAttack'
	ExcludingAbilities(3)=Class'DEKRPG209D.AbilityComboBuffCriticalHit'
	ExcludingAbilities(4)=Class'DEKRPG209D.AbilityComboBuffDefense'
	ExcludingAbilities(5)=Class'DEKRPG209D.AbilityComboBuffHeal'
	ExcludingAbilities(6)=Class'DEKRPG209D.AbilityComboBuffWard'
	ExcludingAbilities(7)=Class'DEKRPG209D.AbilityComboBuffRegenerate'
	ExcludingAbilities(8)=Class'DEKRPG209D.AbilityComboBuffShieldBoost'
	ExcludingAbilities(9)=Class'DEKRPG209D.AbilityComboBuffShieldHeal'
	AbilityName="Buff: HP Boost"
	MaxLevel=10
	Description="Permanently boosts the max health of the caster and all allies.||Each level boosts the max health by 1.5 per level.||You can only have one type of Buff combo at a time.||You must be level 90 to purchase this.||REQUIRED MATERIALS:|You need 5 times the ability level of Nali Fruit and Tarydium Shards you wish to purchase. Additionally:||Level 5: 10 Plated Armor, 10 Honeysuckle Vine||Level 6: 20 Plated Armor, 20 Honeysuckle Vine||Level 7: 30 Plated Armor, 30 Honeysuckle Vine||Level 8: 40 Plated Armor, 40 Honeysuckle Vine, 10 Moss||Level 9: 45 Plated Armor, 45 Honeysuckle Vine, 25 Moss||Level 10: 50 Plated Armor, 50 Honeysuckle Vine, 50 Moss||Cost(per level): 5, 10, 15, 20...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
	StartingCost=5
	CostAddPerLevel=5
	BaseMultiplier=25.0000
	MultiplierAddPerStep=1.000000
	MultiplierStep=1.50000
	BaseLifespan=10.000
	LifespanAddPerStep=1.0000
	LifespanStep=1.00000
	Dispellable=True
	All=True
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG209D.AbilityMaterialTarydiumShards',Class'DEKRPG209D.AbilityMaterialNaliFruit'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG209D.AbilityMaterialTarydiumShards',Class'DEKRPG209D.AbilityMaterialNaliFruit'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG209D.AbilityMaterialTarydiumShards',Class'DEKRPG209D.AbilityMaterialNaliFruit'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG209D.AbilityMaterialTarydiumShards',Class'DEKRPG209D.AbilityMaterialNaliFruit'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG209D.AbilityMaterialTarydiumShards',Class'DEKRPG209D.AbilityMaterialNaliFruit',Class'DEKRPG209D.AbilityMaterialPlatedArmor',Class'DEKRPG209D.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(25,25,10,10))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG209D.AbilityMaterialTarydiumShards',Class'DEKRPG209D.AbilityMaterialNaliFruit',Class'DEKRPG209D.AbilityMaterialPlatedArmor',Class'DEKRPG209D.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(30,30,20,20))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG209D.AbilityMaterialTarydiumShards',Class'DEKRPG209D.AbilityMaterialNaliFruit',Class'DEKRPG209D.AbilityMaterialPlatedArmor',Class'DEKRPG209D.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(35,35,30,30))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG209D.AbilityMaterialTarydiumShards',Class'DEKRPG209D.AbilityMaterialNaliFruit',Class'DEKRPG209D.AbilityMaterialPlatedArmor',Class'DEKRPG209D.AbilityMaterialHoneysuckleVine',Class'DEKRPG209D.AbilityMaterialMoss'),RequiredMaterialLevels=(40,40,40,40,10))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG209D.AbilityMaterialTarydiumShards',Class'DEKRPG209D.AbilityMaterialNaliFruit',Class'DEKRPG209D.AbilityMaterialPlatedArmor',Class'DEKRPG209D.AbilityMaterialHoneysuckleVine',Class'DEKRPG209D.AbilityMaterialMoss'),RequiredMaterialLevels=(45,45,45,45,25))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG209D.AbilityMaterialTarydiumShards',Class'DEKRPG209D.AbilityMaterialNaliFruit',Class'DEKRPG209D.AbilityMaterialPlatedArmor',Class'DEKRPG209D.AbilityMaterialHoneysuckleVine',Class'DEKRPG209D.AbilityMaterialMoss'),RequiredMaterialLevels=(50,50,50,50,50))
}