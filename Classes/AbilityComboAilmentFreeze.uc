class AbilityComboAilmentFreeze extends AbilityComboAilment
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityFreezeInv FreezeInv;
	local ComboAbilityGazeInv GazeInv;

	if (Other != None)
	{
		FreezeInv = ComboAbilityFreezeInv(Other.FindInventoryType(class'ComboAbilityFreezeInv'));
		GazeInv = ComboAbilityGazeInv(Other.FindInventoryType(class'ComboAbilityGazeInv'));
		if (FreezeInv == None)
		{
			FreezeInv = Other.Spawn(class'ComboAbilityFreezeInv');
			FreezeInv.GiveTo(Other);
		}
		if (FreezeInv != None)
		{
			FreezeInv.EffectMultiplier = 5;
			FreezeInv.bAll = default.All;
			FreezeInv.bSingle = default.Single;
			FreezeInv.ComboLifespan = default.BaseLifespan;
		}
		if (GazeInv == None)
		{
			GazeInv = Other.Spawn(class'ComboAbilityGazeInv');
			GazeInv.GiveTo(Other);
		}
		if (GazeInv != None)
		{
			GazeInv.EffectMultiplier = 1 + default.BaseMultiplier*AbilityLevel;
			GazeInv.ComboLifespan = default.BaseLifespan;
		}
	}
}

defaultproperties
{
	AbilityName="Ailment: Freeze"
	Description="All targets receive Freeze for 25 seconds. Additionally for 25 seconds, the target you look at receives Null Entropy and -1% defense per level for 15 seconds. You can only apply Null and lowered defense to one target at a time. If another defense ailment is applied on the target you look at, the effect is stacked.||You can only have one type of Ailment combo at a time.||You must be level 90 to purchase this.||REQUIRED MATERIALS:|You need 5 times the ability level of Gloves and Combat Boots you wish to purchase. Additionally:||Level 5: 10 Fine Leather, 10 Arctic Suit||Level 6: 20 Fine Leather, 20 Arctic Suit||Level 7: 30 Fine Leather, 30 Arctic Suit||Level 8: 40 Fine Leather, 40 Arctic Suit, 10 Icicles||Level 9: 45 Fine Leather, 45 Arctic Suit, 25 Icicles||Level 10: 50 Fine Leather, 50 Arctic Suit, 50 Icicles||Cost(per level): 5, 10, 15, 20...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
	MaxLevel=10
	StartingCost=5
	CostAddPerLevel=5
	BaseMultiplier=0.01000
	MultiplierAddPerStep=25.000000
	MultiplierStep=1.00000
	BaseLifespan=25.000
	Dispellable=True
	All=True
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialCombatBoots',Class'DEKRPG999X.AbilityMaterialGloves'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialCombatBoots',Class'DEKRPG999X.AbilityMaterialGloves'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialCombatBoots',Class'DEKRPG999X.AbilityMaterialGloves'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialCombatBoots',Class'DEKRPG999X.AbilityMaterialGloves'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialCombatBoots',Class'DEKRPG999X.AbilityMaterialGloves',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(25,25,10,10))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialCombatBoots',Class'DEKRPG999X.AbilityMaterialGloves',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(30,30,20,20))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialCombatBoots',Class'DEKRPG999X.AbilityMaterialGloves',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(35,35,30,30))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialCombatBoots',Class'DEKRPG999X.AbilityMaterialGloves',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialArcticSuit',Class'DEKRPG999X.AbilityMaterialIcicle'),RequiredMaterialLevels=(40,40,40,40,10))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialCombatBoots',Class'DEKRPG999X.AbilityMaterialGloves',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialArcticSuit',Class'DEKRPG999X.AbilityMaterialIcicle'),RequiredMaterialLevels=(45,45,45,45,25))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialCombatBoots',Class'DEKRPG999X.AbilityMaterialGloves',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialArcticSuit',Class'DEKRPG999X.AbilityMaterialIcicle'),RequiredMaterialLevels=(50,50,50,50,50))
}