class AbilityComboBuffAdrenHeal extends AbilityCombo
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityAdrenHealInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityAdrenHealInv(Other.FindInventoryType(class'ComboAbilityAdrenHealInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityAdrenHealInv');
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
    ExcludingAbilities(0)=Class'DEKRPG209B.AbilityComboBuffAdrenBoost'
	ExcludingAbilities(1)=Class'DEKRPG209B.AbilityComboBuffWard'
	ExcludingAbilities(2)=Class'DEKRPG209B.AbilityComboBuffAttack'
	ExcludingAbilities(3)=Class'DEKRPG209B.AbilityComboBuffCriticalHit'
	ExcludingAbilities(4)=Class'DEKRPG209B.AbilityComboBuffDefense'
	ExcludingAbilities(5)=Class'DEKRPG209B.AbilityComboBuffHeal'
	ExcludingAbilities(6)=Class'DEKRPG209B.AbilityComboBuffHPBoost'
	ExcludingAbilities(7)=Class'DEKRPG209B.AbilityComboBuffRegenerate'
	ExcludingAbilities(8)=Class'DEKRPG209B.AbilityComboBuffShieldBoost'
	ExcludingAbilities(9)=Class'DEKRPG209B.AbilityComboBuffShieldHeal'
	AbilityName="Buff: Adren Heal"
	MaxLevel=10
	Description="Caster and all allies receive 20 adrenaline per level. Healing over the max adrenaline is added as temporary max adrenaline, up to double the amount of the caster's original max adrenaline.||You can only have one type of Buff combo at a time.||You must be level 90 to purchase this.||REQUIRED MATERIALS:|You need 5 times the ability level of Gloves and Tarydium Shards you wish to purchase. Additionally:||Level 5: 10 Honeysuckle Vine, 10 Burning Embers||Level 6: 20 Honeysuckle Vine, 20 Burning Embers||Level 7: 30 Honeysuckle Vine, 30 Burning Embers||Level 8: 40 Honeysuckle Vine, 40 Burning Embers, 10 Cosmic Dust||Level 9: 45 Honeysuckle Vine, 45 Burning Embers, 25 Cosmic Dust||Level 10: 50 Honeysuckle Vine, 50 Burning Embers, 50 Cosmic Dust||Cost(per level): 5, 10, 15, 20...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
	StartingCost=5
	CostAddPerLevel=5
	BaseMultiplier=25.0000
	MultiplierStep=20.00000
	BaseLifespan=25.000
	Dispellable=True
	All=True
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG209B.AbilityMaterialTarydiumShards',Class'DEKRPG209B.AbilityMaterialGloves'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG209B.AbilityMaterialTarydiumShards',Class'DEKRPG209B.AbilityMaterialGloves'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG209B.AbilityMaterialTarydiumShards',Class'DEKRPG209B.AbilityMaterialGloves'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG209B.AbilityMaterialTarydiumShards',Class'DEKRPG209B.AbilityMaterialGloves'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG209B.AbilityMaterialTarydiumShards',Class'DEKRPG209B.AbilityMaterialGloves',Class'DEKRPG209B.AbilityMaterialHoneysuckleVine',Class'DEKRPG209B.AbilityMaterialEmbers'),RequiredMaterialLevels=(25,25,10,10))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG209B.AbilityMaterialTarydiumShards',Class'DEKRPG209B.AbilityMaterialGloves',Class'DEKRPG209B.AbilityMaterialHoneysuckleVine',Class'DEKRPG209B.AbilityMaterialEmbers'),RequiredMaterialLevels=(30,30,20,20))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG209B.AbilityMaterialTarydiumShards',Class'DEKRPG209B.AbilityMaterialGloves',Class'DEKRPG209B.AbilityMaterialHoneysuckleVine',Class'DEKRPG209B.AbilityMaterialEmbers'),RequiredMaterialLevels=(35,35,30,30))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG209B.AbilityMaterialTarydiumShards',Class'DEKRPG209B.AbilityMaterialGloves',Class'DEKRPG209B.AbilityMaterialHoneysuckleVine',Class'DEKRPG209B.AbilityMaterialEmbers',Class'DEKRPG209B.AbilityMaterialDust'),RequiredMaterialLevels=(40,40,40,40,10))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG209B.AbilityMaterialTarydiumShards',Class'DEKRPG209B.AbilityMaterialGloves',Class'DEKRPG209B.AbilityMaterialHoneysuckleVine',Class'DEKRPG209B.AbilityMaterialEmbers',Class'DEKRPG209B.AbilityMaterialDust'),RequiredMaterialLevels=(45,45,45,45,25))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG209B.AbilityMaterialTarydiumShards',Class'DEKRPG209B.AbilityMaterialGloves',Class'DEKRPG209B.AbilityMaterialHoneysuckleVine',Class'DEKRPG209B.AbilityMaterialEmbers',Class'DEKRPG209B.AbilityMaterialDust'),RequiredMaterialLevels=(50,50,50,50,50))
}