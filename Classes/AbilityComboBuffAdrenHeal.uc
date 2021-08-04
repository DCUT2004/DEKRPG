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
    ExcludingAbilities(0)=Class'DEKRPG208AF.AbilityComboBuffAdrenBoost'
	ExcludingAbilities(1)=Class'DEKRPG208AF.AbilityComboBuffWard'
	ExcludingAbilities(2)=Class'DEKRPG208AF.AbilityComboBuffAttack'
	ExcludingAbilities(3)=Class'DEKRPG208AF.AbilityComboBuffCriticalHit'
	ExcludingAbilities(4)=Class'DEKRPG208AF.AbilityComboBuffDefense'
	ExcludingAbilities(5)=Class'DEKRPG208AF.AbilityComboBuffHeal'
	ExcludingAbilities(6)=Class'DEKRPG208AF.AbilityComboBuffHPBoost'
	ExcludingAbilities(7)=Class'DEKRPG208AF.AbilityComboBuffRegenerate'
	ExcludingAbilities(8)=Class'DEKRPG208AF.AbilityComboBuffShieldBoost'
	ExcludingAbilities(9)=Class'DEKRPG208AF.AbilityComboBuffShieldHeal'
	AbilityName="Buff: Adren Heal"
	MaxLevel=10
	Description="Caster and all allies receive 20 adrenaline per level. Healing over the max adrenaline is added as temporary max adrenaline.||You can only have one type of Buff combo at a time.||You must be level 90 to purchase this.||REQUIRED MATERIALS:|You need 5 times the ability level of Gloves and Tarydium Shards you wish to purchase. Additionally:||Level 5: 10 Honeysuckle Vine, 10 Burning Embers||Level 6: 20 Honeysuckle Vine, 20 Burning Embers||Level 7: 30 Honeysuckle Vine, 30 Burning Embers||Level 8: 40 Honeysuckle Vine, 40 Burning Embers, 10 Cosmic Dust||Level 9: 45 Honeysuckle Vine, 45 Burning Embers, 25 Cosmic Dust||Level 10: 50 Honeysuckle Vine, 50 Burning Embers, 50 Cosmic Dust||Cost(per level): 5, 10, 15, 20...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
	StartingCost=5
	CostAddPerLevel=5
	BaseMultiplier=25.0000
	MultiplierStep=20.00000
	BaseLifespan=25.000
	Dispellable=True
	All=True
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialTarydiumShards',Class'DEKRPG208AF.AbilityMaterialGloves'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialTarydiumShards',Class'DEKRPG208AF.AbilityMaterialGloves'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialTarydiumShards',Class'DEKRPG208AF.AbilityMaterialGloves'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialTarydiumShards',Class'DEKRPG208AF.AbilityMaterialGloves'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialTarydiumShards',Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialEmbers'),RequiredMaterialLevels=(25,25,10,10))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialTarydiumShards',Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialEmbers'),RequiredMaterialLevels=(30,30,20,20))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialTarydiumShards',Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialEmbers'),RequiredMaterialLevels=(35,35,30,30))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialTarydiumShards',Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialEmbers',Class'DEKRPG208AF.AbilityMaterialDust'),RequiredMaterialLevels=(40,40,40,40,10))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialTarydiumShards',Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialEmbers',Class'DEKRPG208AF.AbilityMaterialDust'),RequiredMaterialLevels=(45,45,45,45,25))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialTarydiumShards',Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialEmbers',Class'DEKRPG208AF.AbilityMaterialDust'),RequiredMaterialLevels=(50,50,50,50,50))
}