class AbilityComboBuffAdrenBoost extends AbilityCombo
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityAdrenBoostInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityAdrenBoostInv(Other.FindInventoryType(class'ComboAbilityAdrenBoostInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityAdrenBoostInv');
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
    ExcludingAbilities(0)=Class'DEKRPG209A.AbilityComboBuffWard'
	ExcludingAbilities(1)=Class'DEKRPG209A.AbilityComboBuffAdrenHeal'
	ExcludingAbilities(2)=Class'DEKRPG209A.AbilityComboBuffAttack'
	ExcludingAbilities(3)=Class'DEKRPG209A.AbilityComboBuffCriticalHit'
	ExcludingAbilities(4)=Class'DEKRPG209A.AbilityComboBuffDefense'
	ExcludingAbilities(5)=Class'DEKRPG209A.AbilityComboBuffHeal'
	ExcludingAbilities(6)=Class'DEKRPG209A.AbilityComboBuffHPBoost'
	ExcludingAbilities(7)=Class'DEKRPG209A.AbilityComboBuffRegenerate'
	ExcludingAbilities(8)=Class'DEKRPG209A.AbilityComboBuffShieldBoost'
	ExcludingAbilities(9)=Class'DEKRPG209A.AbilityComboBuffShieldHeal'
	AbilityName="Buff: Adren Boost"
	MaxLevel=10
	Description="Permanently boosts the max adrenaline of the caster and all allies.||Each level boosts the max adrenaline by 1.5 per level.||You can only have one type of Buff combo at a time.||You must be level 90 to purchase this.||REQUIRED MATERIALS:|You need 5 times the ability level of Nali Fruit and Tarydium Shards you wish to purchase. Additionally:||Level 5: 10 Plated Armor, 10 Arctic Suit||Level 6: 20 Plated Armor, 20 Arctic Suit||Level 7: 30 Plated Armor, 30 Arctic Suit||Level 8: 40 Plated Armor, 40 Arctic Suit, 10 Moss||Level 9: 45 Plated Armor, 45 Arctic Suit, 25 Moss||Level 10: 50 Plated Armor, 50 Arctic Suit, 50 Moss||Cost(per level): 5, 10, 15, 20...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
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
	Materials(0)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialTarydiumShards',Class'DEKRPG209A.AbilityMaterialNaliFruit'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialTarydiumShards',Class'DEKRPG209A.AbilityMaterialNaliFruit'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialTarydiumShards',Class'DEKRPG209A.AbilityMaterialNaliFruit'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialTarydiumShards',Class'DEKRPG209A.AbilityMaterialNaliFruit'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialTarydiumShards',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialPlatedArmor',Class'DEKRPG209A.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(25,25,10,10))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialTarydiumShards',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialPlatedArmor',Class'DEKRPG209A.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(30,30,20,20))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialTarydiumShards',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialPlatedArmor',Class'DEKRPG209A.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(35,35,30,30))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialTarydiumShards',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialPlatedArmor',Class'DEKRPG209A.AbilityMaterialArcticSuit',Class'DEKRPG209A.AbilityMaterialMoss'),RequiredMaterialLevels=(40,40,40,40,10))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialTarydiumShards',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialPlatedArmor',Class'DEKRPG209A.AbilityMaterialArcticSuit',Class'DEKRPG209A.AbilityMaterialMoss'),RequiredMaterialLevels=(45,45,45,45,25))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialTarydiumShards',Class'DEKRPG209A.AbilityMaterialNaliFruit',Class'DEKRPG209A.AbilityMaterialPlatedArmor',Class'DEKRPG209A.AbilityMaterialArcticSuit',Class'DEKRPG209A.AbilityMaterialMoss'),RequiredMaterialLevels=(50,50,50,50,50))
}