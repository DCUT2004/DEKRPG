class AbilityComboBuffRegenerate extends AbilityCombo
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityRegenerateInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityRegenerateInv(Other.FindInventoryType(class'ComboAbilityRegenerateInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityRegenerateInv');
			Inv.GiveTo(Other);
		}
		if (Inv != None)
		{
			Inv.EffectMultiplier = default.MultiplierStep*AbilityLevel;
			Inv.bAll = default.All;
			Inv.bSingle = default.Single;
			Inv.ComboLifespan = default.BaseLifespan;
		}
	}
}

defaultproperties
{
    ExcludingAbilities(0)=Class'DEKRPG208AH.AbilityComboBuffAdrenBoost'
	ExcludingAbilities(1)=Class'DEKRPG208AH.AbilityComboBuffAdrenHeal'
	ExcludingAbilities(2)=Class'DEKRPG208AH.AbilityComboBuffAttack'
	ExcludingAbilities(3)=Class'DEKRPG208AH.AbilityComboBuffCriticalHit'
	ExcludingAbilities(4)=Class'DEKRPG208AH.AbilityComboBuffDefense'
	ExcludingAbilities(5)=Class'DEKRPG208AH.AbilityComboBuffHeal'
	ExcludingAbilities(6)=Class'DEKRPG208AH.AbilityComboBuffHPBoost'
	ExcludingAbilities(7)=Class'DEKRPG208AH.AbilityComboBuffWard'
	ExcludingAbilities(8)=Class'DEKRPG208AH.AbilityComboBuffShieldBoost'
	ExcludingAbilities(9)=Class'DEKRPG208AH.AbilityComboBuffShieldHeal'
	AbilityName="Buff: Regenerate"
	MaxLevel=10
	Description="Caster and all allies receive Regeneration. Regeneration heals 1 health per second per level for 25 seconds. Regeneration over the max health is added as temporary max health.||You can only have one type of Buff combo at a time.||You must be level 90 to purchase this.||REQUIRED MATERIALS:|You need 5 times the ability level of Nali Fruit and Tarydium Shards you wish to purchase. Additionally:||Level 5: 10 Plated Armor, 10 Fine Leather||Level 6: 20 Plated Armor, 20 Fine Leather||Level 7: 30 Plated Armor, 30 Fine Leather||Level 8: 40 Plated Armor, 40 Fine Leather, 10 Moss||Level 9: 45 Plated Armor, 45 Fine Leather, 25 Moss||Level 10: 50 Plated Armor, 50 Fine Leather, 50 Moss||Cost(per level): 5, 10, 15, 20...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
	StartingCost=5
	CostAddPerLevel=5
	BaseMultiplier=25.0000
	MultiplierStep=1.00000
	BaseLifespan=25.000
	Dispellable=True
	All=True
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG208AH.AbilityMaterialTarydiumShards',Class'DEKRPG208AH.AbilityMaterialNaliFruit'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG208AH.AbilityMaterialTarydiumShards',Class'DEKRPG208AH.AbilityMaterialNaliFruit'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG208AH.AbilityMaterialTarydiumShards',Class'DEKRPG208AH.AbilityMaterialNaliFruit'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG208AH.AbilityMaterialTarydiumShards',Class'DEKRPG208AH.AbilityMaterialNaliFruit'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG208AH.AbilityMaterialTarydiumShards',Class'DEKRPG208AH.AbilityMaterialNaliFruit',Class'DEKRPG208AH.AbilityMaterialPlatedArmor',Class'DEKRPG208AH.AbilityMaterialLeather'),RequiredMaterialLevels=(25,25,10,10))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG208AH.AbilityMaterialTarydiumShards',Class'DEKRPG208AH.AbilityMaterialNaliFruit',Class'DEKRPG208AH.AbilityMaterialPlatedArmor',Class'DEKRPG208AH.AbilityMaterialLeather'),RequiredMaterialLevels=(30,30,20,20))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG208AH.AbilityMaterialTarydiumShards',Class'DEKRPG208AH.AbilityMaterialNaliFruit',Class'DEKRPG208AH.AbilityMaterialPlatedArmor',Class'DEKRPG208AH.AbilityMaterialLeather'),RequiredMaterialLevels=(35,35,30,30))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG208AH.AbilityMaterialTarydiumShards',Class'DEKRPG208AH.AbilityMaterialNaliFruit',Class'DEKRPG208AH.AbilityMaterialPlatedArmor',Class'DEKRPG208AH.AbilityMaterialLeather',Class'DEKRPG208AH.AbilityMaterialMoss'),RequiredMaterialLevels=(40,40,40,40,10))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG208AH.AbilityMaterialTarydiumShards',Class'DEKRPG208AH.AbilityMaterialNaliFruit',Class'DEKRPG208AH.AbilityMaterialPlatedArmor',Class'DEKRPG208AH.AbilityMaterialLeather',Class'DEKRPG208AH.AbilityMaterialMoss'),RequiredMaterialLevels=(45,45,45,45,25))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG208AH.AbilityMaterialTarydiumShards',Class'DEKRPG208AH.AbilityMaterialNaliFruit',Class'DEKRPG208AH.AbilityMaterialPlatedArmor',Class'DEKRPG208AH.AbilityMaterialLeather',Class'DEKRPG208AH.AbilityMaterialMoss'),RequiredMaterialLevels=(50,50,50,50,50))
}