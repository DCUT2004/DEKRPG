class AbilityComboBurn extends AbilityCombo
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityBurnInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityBurnInv(Other.FindInventoryType(class'ComboAbilityBurnInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityBurnInv');
			Inv.GiveTo(Other);
		}
		if (Inv != None)
		{
			Inv.EffectMultiplier = (default.BaseMultiplier + (default.MultiplierAddPerStep*AbilityLevel/default.MultiplierStep));
			Inv.ComboLifespan = (default.BaseLifespan + (default.LifespanAddPerStep*AbilityLevel/default.LifespanStep));
			Inv.bDispellable = default.Dispellable;
			Inv.bAll = default.All;
			Inv.bSingle = default.Single;
		}
	}
}

defaultproperties
{
	AbilityName="Dancing Flames"
	Description="1) All enemies receive burn for 10 seconds.||The burn effect is increased by 1 every 4 levels.||The duration is increased by 1 second per level.||This effect does not stack with similar combos.||Use the combo BBFF(back back forward forward) when you have a combo activation available(number at top left of HUD).||You must be level 90 to purchase this.||REQUIRED MATERIALS:|Level 1: 2 Nali Fruit, 2 Tarydium Shards, 2 Lumber||Level 2: 6 Nali Fruit, 6 Tarydium Shards, 6 Lumber||Level 3: 10 Nali Fruit, 10 Tarydium Shards, 10 Lumber||Level 4: 15 Nali Fruit, 15 Tarydium Shards, 15 Lumber, 5 Fine Leather||Level 5: 20 Nali Fruit, 20 Tarydium Shards, 20 Lumber, 5 Fine Leather||Level 6: 25 Nali Fruit, 25 Tarydium Shards, 25 Lumber, 5 Fine Leather, 5 Plated Armor||Level 7: 27 Nali Fruit, 27 Tarydium Shards, 27 Lumber, 5 Fine Leather, 5 Plated Armor, 5 Burning Embers||Level 8: 30 Nali Fruit, 30 Tarydium Shards, 30 Lumber, 7 Fine Leather, 7 Plated Armor, 7 Burning Embers||Level 9: 33 Nali Fruit, 33 Tarydium Shards, 33 Lumber, 9 Fine Leather, 9 Plated Armor, 9 Burning Embers||Level 10: 36 Nali Fruit, 36 Tarydium Shards, 36 Lumber, 11 Fine Leather, 11 Plated Armor, 11 Burning Embers||Level 11: 39 Nali Fruit, 39 Tarydium Shards, 39 Lumber, 13 Fine Leather, 13 Plated Armor, 13 Burning Embers, 5 Pumice|| Level 12: 41 Nali Fruit, 41 Tarydium Shards, 41 Lumber, 15 Fine Leather, 15 Plated Armor, 15 Burning Embers, 10 Pumice||Level 13: 43 Nali Fruit, 43 Tarydium Shards, 43 Lumber, 17 Fine Leather, 17 Plated Armor, 17 Burning Embers, 15 Pumice||Level 14: 45 Nali Fruit, 45 Tarydium Shards, 45 Lumber, 19 Fine Leather, 19 Plated Armor, 19 Burning Embers, 20 Pumice||Level 15: 47 Nali Fruit, 47 Tarydium Shards, 47 Lumber, 21 Fine Leather, 21 Plated Armor, 21 Burning Embers, 25 Pumice||Level 16: 50 Nali Fruit, 50 Tarydium Shards, 50 Lumber, 30 Fine Leather, 30 Plated Armor, 30 Burning Embers, 30 Pumice, 10 Uranium Pellets||Level 17: 50 Nali Fruit, 50 Tarydium Shards, 50 Lumber, 35 Fine Leather, 35 Plated Armor, 35 Burning Embers, 35 Pumice, 20 Uranium Pellets||Level 18: 50 Nali Fruit, 50 Tarydium Shards, 50 Lumber, 40 Fine Leather, 40 Plated Armor, 40 Burning Embers, 40 Pumice, 30 Uranium Pellets||Level 19: 50 Nali Fruit, 50 Tarydium Shards, 50 Lumber, 45 Fine Leather, 45 Plated Armor, 45 Burning Embers, 45 Pumice, 40 Uranium Pellets||Level 20: 50 Nali Fruit, 50 Tarydium Shards, 50 Lumber, 50 Fine Leather, 50 Plated Armor, 50 Burning Embers, 50 Pumice, 50 Uranium Pellets||You can have up to 3 combos at a time. Combos are refundable by using the Refund button while the Combos list is open.||Cost(per level): 2, 4, 6, 8, 10..."
	MaxLevel=20
	StartingCost=2
	CostAddPerLevel=2
	BaseMultiplier=1.0000
	MultiplierAddPerStep=1.000000
	MultiplierStep=4.00000
	BaseLifespan=10.000
	LifespanAddPerStep=1.0000
	LifespanStep=1.00000
	Dispellable=True
	All=True
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialNaliFruit',Class'DEKRPG999X.AbilityMaterialLumber'),RequiredMaterialLevels=(2,2,2))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialNaliFruit',Class'DEKRPG999X.AbilityMaterialLumber'),RequiredMaterialLevels=(6,6,6))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialNaliFruit',Class'DEKRPG999X.AbilityMaterialLumber'),RequiredMaterialLevels=(10,10,10))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialNaliFruit',Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialLeather'),RequiredMaterialLevels=(15,15,15,5))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialNaliFruit',Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialLeather'),RequiredMaterialLevels=(20,20,20,5))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialNaliFruit',Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor'),RequiredMaterialLevels=(25,25,25,5,5))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialNaliFruit',Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor',Class'DEKRPG999X.AbilityMaterialEmbers'),RequiredMaterialLevels=(27,27,27,5,5,5))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialNaliFruit',Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor',Class'DEKRPG999X.AbilityMaterialEmbers'),RequiredMaterialLevels=(30,30,30,7,7,7))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialNaliFruit',Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor',Class'DEKRPG999X.AbilityMaterialEmbers'),RequiredMaterialLevels=(33,33,33,9,9,9))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialNaliFruit',Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor',Class'DEKRPG999X.AbilityMaterialEmbers'),RequiredMaterialLevels=(36,36,36,11,11,11))
	Materials(10)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialNaliFruit',Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialPumice'),RequiredMaterialLevels=(39,39,39,13,13,13,5))
	Materials(11)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialNaliFruit',Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialPumice'),RequiredMaterialLevels=(41,41,41,15,15,15,10))
	Materials(12)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialNaliFruit',Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialPumice'),RequiredMaterialLevels=(43,43,43,17,17,17,15))
	Materials(13)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialNaliFruit',Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialPumice'),RequiredMaterialLevels=(45,45,45,19,19,19,20))
	Materials(14)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialNaliFruit',Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialPumice'),RequiredMaterialLevels=(47,47,47,21,21,21,25))
	Materials(15)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialNaliFruit',Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialPumice',Class'DEKRPG999X.AbilityMaterialUranium'),RequiredMaterialLevels=(50,50,50,30,30,30,30,10))
	Materials(16)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialNaliFruit',Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialPumice',Class'DEKRPG999X.AbilityMaterialUranium'),RequiredMaterialLevels=(50,50,50,35,35,35,35,20))
	Materials(17)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialNaliFruit',Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialPumice',Class'DEKRPG999X.AbilityMaterialUranium'),RequiredMaterialLevels=(50,50,50,40,40,40,40,30))
	Materials(18)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialNaliFruit',Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialPumice',Class'DEKRPG999X.AbilityMaterialUranium'),RequiredMaterialLevels=(50,50,50,45,45,45,45,40))
	Materials(19)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialNaliFruit',Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialPumice',Class'DEKRPG999X.AbilityMaterialUranium'),RequiredMaterialLevels=(50,50,50,50,50,50,50,50))
}