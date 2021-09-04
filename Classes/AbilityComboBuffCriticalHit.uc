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
    ExcludingAbilities(0)=Class'DEKRPG209A.AbilityComboBuffAdrenBoost'
	ExcludingAbilities(1)=Class'DEKRPG209A.AbilityComboBuffAdrenHeal'
	ExcludingAbilities(2)=Class'DEKRPG209A.AbilityComboBuffAttack'
	ExcludingAbilities(3)=Class'DEKRPG209A.AbilityComboBuffWard'
	ExcludingAbilities(4)=Class'DEKRPG209A.AbilityComboBuffDefense'
	ExcludingAbilities(5)=Class'DEKRPG209A.AbilityComboBuffHeal'
	ExcludingAbilities(6)=Class'DEKRPG209A.AbilityComboBuffHPBoost'
	ExcludingAbilities(7)=Class'DEKRPG209A.AbilityComboBuffRegenerate'
	ExcludingAbilities(8)=Class'DEKRPG209A.AbilityComboBuffShieldBoost'
	ExcludingAbilities(9)=Class'DEKRPG209A.AbilityComboBuffShieldHeal'
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
	Materials(0)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialTarydiumShards'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialTarydiumShards'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialTarydiumShards'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialTarydiumShards'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialTarydiumShards',Class'DEKRPG209A.AbilityMaterialHoneysuckleVine',Class'DEKRPG209A.AbilityMaterialEmbers'),RequiredMaterialLevels=(25,25,10,10))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialTarydiumShards',Class'DEKRPG209A.AbilityMaterialHoneysuckleVine',Class'DEKRPG209A.AbilityMaterialEmbers'),RequiredMaterialLevels=(30,30,20,20))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialTarydiumShards',Class'DEKRPG209A.AbilityMaterialHoneysuckleVine',Class'DEKRPG209A.AbilityMaterialEmbers'),RequiredMaterialLevels=(35,35,30,30))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialTarydiumShards',Class'DEKRPG209A.AbilityMaterialHoneysuckleVine',Class'DEKRPG209A.AbilityMaterialEmbers',Class'DEKRPG209A.AbilityMaterialDust'),RequiredMaterialLevels=(40,40,40,40,10))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialTarydiumShards',Class'DEKRPG209A.AbilityMaterialHoneysuckleVine',Class'DEKRPG209A.AbilityMaterialEmbers',Class'DEKRPG209A.AbilityMaterialDust'),RequiredMaterialLevels=(45,45,45,45,25))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG209A.AbilityMaterialLumber',Class'DEKRPG209A.AbilityMaterialTarydiumShards',Class'DEKRPG209A.AbilityMaterialHoneysuckleVine',Class'DEKRPG209A.AbilityMaterialEmbers',Class'DEKRPG209A.AbilityMaterialDust'),RequiredMaterialLevels=(50,50,50,50,50))
}