class AbilityComboBuffCriticalHit extends AbilityCombo
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityCriticalHitInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityCriticalHitInv(Other.FindInventoryType(class'ComboAbilityCriticalHitInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityCriticalHitInv');
			Inv.GiveTo(Other);
		}
		if (Inv != None)
		{
			Inv.EffectMultiplier = default.BaseMultiplier*AbilityLevel;
			Inv.bAll = default.All;
			Inv.bSingle = default.Single;
			Inv.ComboLifespan = default.BaseLifespan;
		}
	}
}

defaultproperties
{
    ExcludingAbilities(0)=Class'DEKRPG208AG.AbilityComboBuffAdrenBoost'
	ExcludingAbilities(1)=Class'DEKRPG208AG.AbilityComboBuffAdrenHeal'
	ExcludingAbilities(2)=Class'DEKRPG208AG.AbilityComboBuffAttack'
	ExcludingAbilities(3)=Class'DEKRPG208AG.AbilityComboBuffWard'
	ExcludingAbilities(4)=Class'DEKRPG208AG.AbilityComboBuffDefense'
	ExcludingAbilities(5)=Class'DEKRPG208AG.AbilityComboBuffHeal'
	ExcludingAbilities(6)=Class'DEKRPG208AG.AbilityComboBuffHPBoost'
	ExcludingAbilities(7)=Class'DEKRPG208AG.AbilityComboBuffRegenerate'
	ExcludingAbilities(8)=Class'DEKRPG208AG.AbilityComboBuffShieldBoost'
	ExcludingAbilities(9)=Class'DEKRPG208AG.AbilityComboBuffShieldHeal'
	AbilityName="Buff: Critical Hit"
	Description="The caster and all allies receive Critical Hit for 25 seconds, which provides a 3.5% chance per level to deal double damage on each hit. A purple flash and sound indicates a critical hit.||You can only have one type of Buff combo at a time.||You must be level 90 to purchase this.||REQUIRED MATERIALS:|You need 5 times the ability level of Tarydium Shard and Lumber you wish to purchase. Additionally:||Level 5: 10 Fine Honeysuckle Vine, 10 Burning Embers||Level 6: 20 Fine Honeysuckle Vine, 20 Burning Embers||Level 7: 30 Fine Honeysuckle Vine, 30 Burning Embers||Level 8: 40 Fine Honeysuckle Vine, 40 Burning Embers, 10 Cosmic Dust||Level 9: 45 Fine Honeysuckle Vine, 45 Burning Embers, 25 Cosmic Dust||Level 10: 50 Fine Honeysuckle Vine, 50 Burning Embers, 50 Cosmic Dust||Cost(per level): 5, 10, 15, 20...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
	MaxLevel=10
	StartingCost=5
	CostAddPerLevel=5
	BaseMultiplier=3.500000
	MultiplierAddPerStep=25.000000
	MultiplierStep=1.00000
	BaseLifespan=25.000
	Dispellable=True
	All=True
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG208AG.AbilityMaterialLumber',Class'DEKRPG208AG.AbilityMaterialTarydiumShards'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG208AG.AbilityMaterialLumber',Class'DEKRPG208AG.AbilityMaterialTarydiumShards'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG208AG.AbilityMaterialLumber',Class'DEKRPG208AG.AbilityMaterialTarydiumShards'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG208AG.AbilityMaterialLumber',Class'DEKRPG208AG.AbilityMaterialTarydiumShards'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG208AG.AbilityMaterialLumber',Class'DEKRPG208AG.AbilityMaterialTarydiumShards',Class'DEKRPG208AG.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AG.AbilityMaterialEmbers'),RequiredMaterialLevels=(25,25,10,10))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG208AG.AbilityMaterialLumber',Class'DEKRPG208AG.AbilityMaterialTarydiumShards',Class'DEKRPG208AG.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AG.AbilityMaterialEmbers'),RequiredMaterialLevels=(30,30,20,20))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG208AG.AbilityMaterialLumber',Class'DEKRPG208AG.AbilityMaterialTarydiumShards',Class'DEKRPG208AG.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AG.AbilityMaterialEmbers'),RequiredMaterialLevels=(35,35,30,30))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG208AG.AbilityMaterialLumber',Class'DEKRPG208AG.AbilityMaterialTarydiumShards',Class'DEKRPG208AG.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AG.AbilityMaterialEmbers',Class'DEKRPG208AG.AbilityMaterialDust'),RequiredMaterialLevels=(40,40,40,40,10))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG208AG.AbilityMaterialLumber',Class'DEKRPG208AG.AbilityMaterialTarydiumShards',Class'DEKRPG208AG.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AG.AbilityMaterialEmbers',Class'DEKRPG208AG.AbilityMaterialDust'),RequiredMaterialLevels=(45,45,45,45,25))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG208AG.AbilityMaterialLumber',Class'DEKRPG208AG.AbilityMaterialTarydiumShards',Class'DEKRPG208AG.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AG.AbilityMaterialEmbers',Class'DEKRPG208AG.AbilityMaterialDust'),RequiredMaterialLevels=(50,50,50,50,50))
}