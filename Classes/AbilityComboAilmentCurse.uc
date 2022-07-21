class AbilityComboAilmentCurse extends AbilityComboAilment
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityCurseInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityCurseInv(Other.FindInventoryType(class'ComboAbilityCurseInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityCurseInv');
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
	AbilityName="Ailment: Curse"
	Description="A single target receives Curse. While cursed, the caster steals 0.5% of the target's health per second per level. If the target dies, the curse moves to a new target, and will continue this process for 25 seconds. This ailment can not be stacked. Cursed targets have an orange glow.||You can only have one type of Ailment combo at a time.||You must be level 90 to purchase this.||REQUIRED MATERIALS:|You need 5 times the ability level of Tarydium Shards and Lumber you wish to purchase. Additionally:||Level 5: 10 Fine Leather, 10 Plated Armor||Level 6: 20 Fine Leather, 20 Plated Armor||Level 7: 30 Fine Leather, 30 Plated Armor||Level 8: 40 Fine Leather, 40 Plated Armor, 10 Nanite Fragments||Level 9: 45 Fine Leather, 45 Plated Armor, 25 Nanite Fragments||Level 10: 50 Fine Leather, 50 Plated Armor, 50 Nanite Fragments||Cost(per level): 5, 10, 15, 20...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
	MaxLevel=10
	StartingCost=5
	CostAddPerLevel=5
	BaseMultiplier=0.0050000
	MultiplierAddPerStep=25.000000
	MultiplierStep=1.00000
	BaseLifespan=25.000
	Dispellable=True
	All=False
	Single=True
	Materials(0)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialTarydiumShards'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialTarydiumShards'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialTarydiumShards'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialTarydiumShards'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor'),RequiredMaterialLevels=(25,25,10,10))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor'),RequiredMaterialLevels=(30,30,20,20))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor'),RequiredMaterialLevels=(35,35,30,30))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor',Class'DEKRPG999X.AbilityMaterialNanite'),RequiredMaterialLevels=(40,40,40,40,10))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor',Class'DEKRPG999X.AbilityMaterialNanite'),RequiredMaterialLevels=(45,45,45,45,25))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor',Class'DEKRPG999X.AbilityMaterialNanite'),RequiredMaterialLevels=(50,50,50,50,50))
}