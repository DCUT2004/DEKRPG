class AbilityComboFrailty extends AbilityCombo
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityFrailtyInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityFrailtyInv(Other.FindInventoryType(class'ComboAbilityFrailtyInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityFrailtyInv');
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
	AbilityName="Frailty"
	Description="1) All enemies receive -10% defense for 10 seconds.||The effect further reduces damage reduction by 1% per level.|The duration is increased by 1 second per level.|This combo stacks with a similar effect at a diminishing rate.|Use the combo BBFF(back back forward forward) when you have a combo activation available(number at top left of HUD).|You must be level 90 to purchase this.||REQUIRED MATERIALS:|Level 1: 2 Nali Fruit, 2 Tarydium Shards, 2 Combat Boots||Level 2: 6 Nali Fruit, 6 Tarydium Shards, 6 Combat Boots||Level 3: 10 Nali Fruit, 10 Tarydium Shards, 10 Combat Boots||Level 4: 15 Nali Fruit, 15 Tarydium Shards, 15 Combat Boots, 5 Burning Embers||Level 5: 20 Nali Fruit, 20 Tarydium Shards, 20 Combat Boots, 5 Burning Embers||Level 6: 25 Nali Fruit, 25 Tarydium Shards, 25 Combat Boots, 5 Burning Embers, 5 Plated Armor||Level 7: 27 Nali Fruit, 27 Tarydium Shards, 27 Combat Boots, 5 Burning Embers, 5 Plated Armor, 5 Honeysuckle Vines||Level 8: 30 Nali Fruit, 30 Tarydium Shards, 30 Combat Boots, 7 Burning Embers, 7 Plated Armor, 7 Honeysuckle Vines||Level 9: 33 Nali Fruit, 33 Tarydium Shards, 33 Combat Boots, 9 Burning Embers, 9 Plated Armor, 9 Honeysuckle Vines||Level 10: 36 Nali Fruit, 36 Tarydium Shards, 36 Combat Boots, 11 Burning Embers, 11 Plated Armor, 11 Honeysuckle Vines||Level 11: 39 Nali Fruit, 39 Tarydium Shards, 39 Combat Boots, 13 Burning Embers, 13 Plated Armor, 13 Honeysuckle Vines, 5 Nanite Fragment|| Level 12: 41 Nali Fruit, 41 Tarydium Shards, 41 Combat Boots, 15 Burning Embers, 15 Plated Armor, 15 Honeysuckle Vines, 10 Nanite Fragment||Level 13: 43 Nali Fruit, 43 Tarydium Shards, 43 Combat Boots, 17 Burning Embers, 17 Plated Armor, 17 Honeysuckle Vines, 15 Nanite Fragment||Level 14: 45 Nali Fruit, 45 Tarydium Shards, 45 Combat Boots, 19 Burning Embers, 19 Plated Armor, 19 Honeysuckle Vines, 20 Nanite Fragment||Level 15: 47 Nali Fruit, 47 Tarydium Shards, 47 Combat Boots, 21 Burning Embers, 21 Plated Armor, 21 Honeysuckle Vines, 25 Nanite Fragment||Level 16: 50 Nali Fruit, 50 Tarydium Shards, 50 Combat Boots, 30 Burning Embers, 30 Plated Armor, 30 Honeysuckle Vines, 30 Nanite Fragment, 10 Moonlit Stone||Level 17: 50 Nali Fruit, 50 Tarydium Shards, 50 Lumb, 35 Burning Embers, 35 Plated Armor, 35 Honeysuckle Vines, 35 Nanite Fragment, 20 Moonlit Stone||Level 18: 50 Nali Fruit, 50 Tarydium Shards, 50 Combat Boots, 40 Burning Embers, 40 Plated Armor, 40 Honeysuckle Vines, 40 Nanite Fragment, 30 Moonlit Stone||Level 19: 50 Nali Fruit, 50 Tarydium Shards, 50 Combat Boots, 45 Burning Embers, 45 Plated Armor, 45 Honeysuckle Vines, 45 Nanite Fragment, 40 Moonlit Stone||Level 20: 50 Nali Fruit, 50 Tarydium Shards, 50 Combat Boots, 50 Burning Embers, 50 Plated Armor, 50 Honeysuckle Vines, 50 Nanite Fragment, 50 Moonlit Stone||You can have up to 3 combos at a time. Combos are refundable by using the Refund button while the Combos list is open.||Cost(per level): 2, 4, 6, 8, 10..."
	MaxLevel=20
	StartingCost=2
	CostAddPerLevel=2
	BaseMultiplier=1.09000
	MultiplierAddPerStep=0.010000
	MultiplierStep=1.00000
	BaseLifespan=10.0000
	LifespanAddPerStep=1.0000
	LifespanStep=1.00000
	Dispellable=True
	All=True
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG208AC.AbilityMaterialTarydiumShards',Class'DEKRPG208AC.AbilityMaterialNaliFruit',Class'DEKRPG208AC.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(2,2,2))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG208AC.AbilityMaterialTarydiumShards',Class'DEKRPG208AC.AbilityMaterialNaliFruit',Class'DEKRPG208AC.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(6,6,6))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG208AC.AbilityMaterialTarydiumShards',Class'DEKRPG208AC.AbilityMaterialNaliFruit',Class'DEKRPG208AC.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(10,10,10))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG208AC.AbilityMaterialTarydiumShards',Class'DEKRPG208AC.AbilityMaterialNaliFruit',Class'DEKRPG208AC.AbilityMaterialCombatBoots',Class'DEKRPG208AC.AbilityMaterialEmbers'),RequiredMaterialLevels=(15,15,15,5))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG208AC.AbilityMaterialTarydiumShards',Class'DEKRPG208AC.AbilityMaterialNaliFruit',Class'DEKRPG208AC.AbilityMaterialCombatBoots',Class'DEKRPG208AC.AbilityMaterialEmbers'),RequiredMaterialLevels=(20,20,20,5))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG208AC.AbilityMaterialTarydiumShards',Class'DEKRPG208AC.AbilityMaterialNaliFruit',Class'DEKRPG208AC.AbilityMaterialCombatBoots',Class'DEKRPG208AC.AbilityMaterialEmbers',Class'DEKRPG208AC.AbilityMaterialPlatedArmor'),RequiredMaterialLevels=(25,25,25,5,5))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG208AC.AbilityMaterialTarydiumShards',Class'DEKRPG208AC.AbilityMaterialNaliFruit',Class'DEKRPG208AC.AbilityMaterialCombatBoots',Class'DEKRPG208AC.AbilityMaterialEmbers',Class'DEKRPG208AC.AbilityMaterialPlatedArmor',Class'DEKRPG208AC.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(27,27,27,5,5,5))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG208AC.AbilityMaterialTarydiumShards',Class'DEKRPG208AC.AbilityMaterialNaliFruit',Class'DEKRPG208AC.AbilityMaterialCombatBoots',Class'DEKRPG208AC.AbilityMaterialEmbers',Class'DEKRPG208AC.AbilityMaterialPlatedArmor',Class'DEKRPG208AC.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(30,30,30,7,7,7))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG208AC.AbilityMaterialTarydiumShards',Class'DEKRPG208AC.AbilityMaterialNaliFruit',Class'DEKRPG208AC.AbilityMaterialCombatBoots',Class'DEKRPG208AC.AbilityMaterialEmbers',Class'DEKRPG208AC.AbilityMaterialPlatedArmor',Class'DEKRPG208AC.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(33,33,33,9,9,9))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG208AC.AbilityMaterialTarydiumShards',Class'DEKRPG208AC.AbilityMaterialNaliFruit',Class'DEKRPG208AC.AbilityMaterialCombatBoots',Class'DEKRPG208AC.AbilityMaterialEmbers',Class'DEKRPG208AC.AbilityMaterialPlatedArmor',Class'DEKRPG208AC.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(36,36,36,11,11,11))
	Materials(10)=(RequiredMaterials=(Class'DEKRPG208AC.AbilityMaterialTarydiumShards',Class'DEKRPG208AC.AbilityMaterialNaliFruit',Class'DEKRPG208AC.AbilityMaterialCombatBoots',Class'DEKRPG208AC.AbilityMaterialEmbers',Class'DEKRPG208AC.AbilityMaterialPlatedArmor',Class'DEKRPG208AC.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AC.AbilityMaterialNanite'),RequiredMaterialLevels=(39,39,39,13,13,13,5))
	Materials(11)=(RequiredMaterials=(Class'DEKRPG208AC.AbilityMaterialTarydiumShards',Class'DEKRPG208AC.AbilityMaterialNaliFruit',Class'DEKRPG208AC.AbilityMaterialCombatBoots',Class'DEKRPG208AC.AbilityMaterialEmbers',Class'DEKRPG208AC.AbilityMaterialPlatedArmor',Class'DEKRPG208AC.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AC.AbilityMaterialNanite'),RequiredMaterialLevels=(41,41,41,15,15,15,10))
	Materials(12)=(RequiredMaterials=(Class'DEKRPG208AC.AbilityMaterialTarydiumShards',Class'DEKRPG208AC.AbilityMaterialNaliFruit',Class'DEKRPG208AC.AbilityMaterialCombatBoots',Class'DEKRPG208AC.AbilityMaterialEmbers',Class'DEKRPG208AC.AbilityMaterialPlatedArmor',Class'DEKRPG208AC.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AC.AbilityMaterialNanite'),RequiredMaterialLevels=(43,43,43,17,17,17,15))
	Materials(13)=(RequiredMaterials=(Class'DEKRPG208AC.AbilityMaterialTarydiumShards',Class'DEKRPG208AC.AbilityMaterialNaliFruit',Class'DEKRPG208AC.AbilityMaterialCombatBoots',Class'DEKRPG208AC.AbilityMaterialEmbers',Class'DEKRPG208AC.AbilityMaterialPlatedArmor',Class'DEKRPG208AC.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AC.AbilityMaterialNanite'),RequiredMaterialLevels=(45,45,45,19,19,19,20))
	Materials(14)=(RequiredMaterials=(Class'DEKRPG208AC.AbilityMaterialTarydiumShards',Class'DEKRPG208AC.AbilityMaterialNaliFruit',Class'DEKRPG208AC.AbilityMaterialCombatBoots',Class'DEKRPG208AC.AbilityMaterialEmbers',Class'DEKRPG208AC.AbilityMaterialPlatedArmor',Class'DEKRPG208AC.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AC.AbilityMaterialNanite'),RequiredMaterialLevels=(47,47,47,21,21,21,25))
	Materials(15)=(RequiredMaterials=(Class'DEKRPG208AC.AbilityMaterialTarydiumShards',Class'DEKRPG208AC.AbilityMaterialNaliFruit',Class'DEKRPG208AC.AbilityMaterialCombatBoots',Class'DEKRPG208AC.AbilityMaterialEmbers',Class'DEKRPG208AC.AbilityMaterialPlatedArmor',Class'DEKRPG208AC.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AC.AbilityMaterialNanite',Class'DEKRPG208AC.AbilityMaterialMoonlitStone'),RequiredMaterialLevels=(50,50,50,30,30,30,30,10))
	Materials(16)=(RequiredMaterials=(Class'DEKRPG208AC.AbilityMaterialTarydiumShards',Class'DEKRPG208AC.AbilityMaterialNaliFruit',Class'DEKRPG208AC.AbilityMaterialCombatBoots',Class'DEKRPG208AC.AbilityMaterialEmbers',Class'DEKRPG208AC.AbilityMaterialPlatedArmor',Class'DEKRPG208AC.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AC.AbilityMaterialNanite',Class'DEKRPG208AC.AbilityMaterialMoonlitStone'),RequiredMaterialLevels=(50,50,50,35,35,35,35,20))
	Materials(17)=(RequiredMaterials=(Class'DEKRPG208AC.AbilityMaterialTarydiumShards',Class'DEKRPG208AC.AbilityMaterialNaliFruit',Class'DEKRPG208AC.AbilityMaterialCombatBoots',Class'DEKRPG208AC.AbilityMaterialEmbers',Class'DEKRPG208AC.AbilityMaterialPlatedArmor',Class'DEKRPG208AC.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AC.AbilityMaterialNanite',Class'DEKRPG208AC.AbilityMaterialMoonlitStone'),RequiredMaterialLevels=(50,50,50,40,40,40,40,30))
	Materials(18)=(RequiredMaterials=(Class'DEKRPG208AC.AbilityMaterialTarydiumShards',Class'DEKRPG208AC.AbilityMaterialNaliFruit',Class'DEKRPG208AC.AbilityMaterialCombatBoots',Class'DEKRPG208AC.AbilityMaterialEmbers',Class'DEKRPG208AC.AbilityMaterialPlatedArmor',Class'DEKRPG208AC.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AC.AbilityMaterialNanite',Class'DEKRPG208AC.AbilityMaterialMoonlitStone'),RequiredMaterialLevels=(50,50,50,45,45,45,45,40))
	Materials(19)=(RequiredMaterials=(Class'DEKRPG208AC.AbilityMaterialTarydiumShards',Class'DEKRPG208AC.AbilityMaterialNaliFruit',Class'DEKRPG208AC.AbilityMaterialCombatBoots',Class'DEKRPG208AC.AbilityMaterialEmbers',Class'DEKRPG208AC.AbilityMaterialPlatedArmor',Class'DEKRPG208AC.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AC.AbilityMaterialNanite',Class'DEKRPG208AC.AbilityMaterialMoonlitStone'),RequiredMaterialLevels=(50,50,50,50,50,50,50,50))
}