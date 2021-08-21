class AbilityComboPalmDespair extends AbilityCombo
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityPalmOfDespairInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityPalmOfDespairInv(Other.FindInventoryType(class'ComboAbilityPalmOfDespairInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityPalmOfDespairInv');
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
	AbilityName="Palm of Despair"
	Description="1) All enemies receive -10% damage bonus for 10 seconds.||The effect further decreases damage bonus by 1% per level.|The duration is increased by 1 second per level.|This combo stacks with a similar effect at a diminishing rate.|Use the combo BBFF(back back forward forward) when you have a combo activation available(number at top left of HUD).|You must be level 90 to purchase this.||REQUIRED MATERIALS:|Level 1: 2 Steel, 2 Tarydium Shards, 2 Combat Boots||Level 2: 6 Steel, 6 Tarydium Shards, 6 Combat Boots||Level 3: 10 Steel, 10 Tarydium Shards, 10 Combat Boots||Level 4: 15 Steel, 15 Tarydium Shards, 15 Combat Boots, 5 Burning Embers||Level 5: 20 Steel, 20 Tarydium Shards, 20 Combat Boots, 5 Burning Embers||Level 6: 25 Steel, 25 Tarydium Shards, 25 Combat Boots, 5 Burning Embers, 5 Arctic Suit||Level 7: 27 Steel, 27 Tarydium Shards, 27 Combat Boots, 5 Burning Embers, 5 Arctic Suit, 5 Honeysuckle Vines||Level 8: 30 Steel, 30 Tarydium Shards, 30 Combat Boots, 7 Burning Embers, 7 Arctic Suit, 7 Honeysuckle Vines||Level 9: 33 Steel, 33 Tarydium Shards, 33 Combat Boots, 9 Burning Embers, 9 Arctic Suit, 9 Honeysuckle Vines||Level 10: 36 Steel, 36 Tarydium Shards, 36 Combat Boots, 11 Burning Embers, 11 Arctic Suit, 11 Honeysuckle Vines||Level 11: 39 Steel, 39 Tarydium Shards, 39 Combat Boots, 13 Burning Embers, 13 Arctic Suit, 13 Honeysuckle Vines, 5 Moss|| Level 12: 41 Steel, 41 Tarydium Shards, 41 Combat Boots, 15 Burning Embers, 15 Arctic Suit, 15 Honeysuckle Vines, 10 Moss||Level 13: 43 Steel, 43 Tarydium Shards, 43 Combat Boots, 17 Burning Embers, 17 Arctic Suit, 17 Honeysuckle Vines, 15 Moss||Level 14: 45 Steel, 45 Tarydium Shards, 45 Combat Boots, 19 Burning Embers, 19 Arctic Suit, 19 Honeysuckle Vines, 20 Moss||Level 15: 47 Steel, 47 Tarydium Shards, 47 Combat Boots, 21 Burning Embers, 21 Arctic Suit, 21 Honeysuckle Vines, 25 Moss||Level 16: 50 Steel, 50 Tarydium Shards, 50 Combat Boots, 30 Burning Embers, 30 Arctic Suit, 30 Honeysuckle Vines, 30 Moss, 10 Star Chart||Level 17: 50 Steel, 50 Tarydium Shards, 50 Lumb, 35 Burning Embers, 35 Arctic Suit, 35 Honeysuckle Vines, 35 Moss, 20 Star Chart||Level 18: 50 Steel, 50 Tarydium Shards, 50 Combat Boots, 40 Burning Embers, 40 Arctic Suit, 40 Honeysuckle Vines, 40 Moss, 30 Star Chart||Level 19: 50 Steel, 50 Tarydium Shards, 50 Combat Boots, 45 Burning Embers, 45 Arctic Suit, 45 Honeysuckle Vines, 45 Moss, 40 Star Chart||Level 20: 50 Steel, 50 Tarydium Shards, 50 Combat Boots, 50 Burning Embers, 50 Arctic Suit, 50 Honeysuckle Vines, 50 Moss, 50 Star Chart||You can have up to 3 combos at a time. Combos are refundable by using the Refund button while the Combos list is open.||Cost(per level): 2, 4, 6, 8, 10..."
	MaxLevel=20
	StartingCost=2
	CostAddPerLevel=2
	BaseMultiplier=0.9000
	MultiplierAddPerStep=-0.010000
	MultiplierStep=1.00000
	BaseLifespan=10.0000
	LifespanAddPerStep=1.0000
	LifespanStep=1.00000
	Dispellable=True
	All=True
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialTarydiumShards',Class'DEKRPG208AJ.AbilityMaterialSteel',Class'DEKRPG208AJ.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(2,2,2))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialTarydiumShards',Class'DEKRPG208AJ.AbilityMaterialSteel',Class'DEKRPG208AJ.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(6,6,6))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialTarydiumShards',Class'DEKRPG208AJ.AbilityMaterialSteel',Class'DEKRPG208AJ.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(10,10,10))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialTarydiumShards',Class'DEKRPG208AJ.AbilityMaterialSteel',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialEmbers'),RequiredMaterialLevels=(15,15,15,5))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialTarydiumShards',Class'DEKRPG208AJ.AbilityMaterialSteel',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialEmbers'),RequiredMaterialLevels=(20,20,20,5))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialTarydiumShards',Class'DEKRPG208AJ.AbilityMaterialSteel',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialEmbers',Class'DEKRPG208AJ.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(25,25,25,5,5))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialTarydiumShards',Class'DEKRPG208AJ.AbilityMaterialSteel',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialEmbers',Class'DEKRPG208AJ.AbilityMaterialArcticSuit',Class'DEKRPG208AJ.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(27,27,27,5,5,5))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialTarydiumShards',Class'DEKRPG208AJ.AbilityMaterialSteel',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialEmbers',Class'DEKRPG208AJ.AbilityMaterialArcticSuit',Class'DEKRPG208AJ.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(30,30,30,7,7,7))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialTarydiumShards',Class'DEKRPG208AJ.AbilityMaterialSteel',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialEmbers',Class'DEKRPG208AJ.AbilityMaterialArcticSuit',Class'DEKRPG208AJ.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(33,33,33,9,9,9))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialTarydiumShards',Class'DEKRPG208AJ.AbilityMaterialSteel',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialEmbers',Class'DEKRPG208AJ.AbilityMaterialArcticSuit',Class'DEKRPG208AJ.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(36,36,36,11,11,11))
	Materials(10)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialTarydiumShards',Class'DEKRPG208AJ.AbilityMaterialSteel',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialEmbers',Class'DEKRPG208AJ.AbilityMaterialArcticSuit',Class'DEKRPG208AJ.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AJ.AbilityMaterialMoss'),RequiredMaterialLevels=(39,39,39,13,13,13,5))
	Materials(11)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialTarydiumShards',Class'DEKRPG208AJ.AbilityMaterialSteel',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialEmbers',Class'DEKRPG208AJ.AbilityMaterialArcticSuit',Class'DEKRPG208AJ.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AJ.AbilityMaterialMoss'),RequiredMaterialLevels=(41,41,41,15,15,15,10))
	Materials(12)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialTarydiumShards',Class'DEKRPG208AJ.AbilityMaterialSteel',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialEmbers',Class'DEKRPG208AJ.AbilityMaterialArcticSuit',Class'DEKRPG208AJ.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AJ.AbilityMaterialMoss'),RequiredMaterialLevels=(43,43,43,17,17,17,15))
	Materials(13)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialTarydiumShards',Class'DEKRPG208AJ.AbilityMaterialSteel',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialEmbers',Class'DEKRPG208AJ.AbilityMaterialArcticSuit',Class'DEKRPG208AJ.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AJ.AbilityMaterialMoss'),RequiredMaterialLevels=(45,45,45,19,19,19,20))
	Materials(14)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialTarydiumShards',Class'DEKRPG208AJ.AbilityMaterialSteel',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialEmbers',Class'DEKRPG208AJ.AbilityMaterialArcticSuit',Class'DEKRPG208AJ.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AJ.AbilityMaterialMoss'),RequiredMaterialLevels=(47,47,47,21,21,21,25))
	Materials(15)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialTarydiumShards',Class'DEKRPG208AJ.AbilityMaterialSteel',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialEmbers',Class'DEKRPG208AJ.AbilityMaterialArcticSuit',Class'DEKRPG208AJ.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AJ.AbilityMaterialMoss',Class'DEKRPG208AJ.AbilityMaterialStarChart'),RequiredMaterialLevels=(50,50,50,30,30,30,30,10))
	Materials(16)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialTarydiumShards',Class'DEKRPG208AJ.AbilityMaterialSteel',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialEmbers',Class'DEKRPG208AJ.AbilityMaterialArcticSuit',Class'DEKRPG208AJ.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AJ.AbilityMaterialMoss',Class'DEKRPG208AJ.AbilityMaterialStarChart'),RequiredMaterialLevels=(50,50,50,35,35,35,35,20))
	Materials(17)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialTarydiumShards',Class'DEKRPG208AJ.AbilityMaterialSteel',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialEmbers',Class'DEKRPG208AJ.AbilityMaterialArcticSuit',Class'DEKRPG208AJ.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AJ.AbilityMaterialMoss',Class'DEKRPG208AJ.AbilityMaterialStarChart'),RequiredMaterialLevels=(50,50,50,40,40,40,40,30))
	Materials(18)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialTarydiumShards',Class'DEKRPG208AJ.AbilityMaterialSteel',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialEmbers',Class'DEKRPG208AJ.AbilityMaterialArcticSuit',Class'DEKRPG208AJ.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AJ.AbilityMaterialMoss',Class'DEKRPG208AJ.AbilityMaterialStarChart'),RequiredMaterialLevels=(50,50,50,45,45,45,45,40))
	Materials(19)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialTarydiumShards',Class'DEKRPG208AJ.AbilityMaterialSteel',Class'DEKRPG208AJ.AbilityMaterialCombatBoots',Class'DEKRPG208AJ.AbilityMaterialEmbers',Class'DEKRPG208AJ.AbilityMaterialArcticSuit',Class'DEKRPG208AJ.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AJ.AbilityMaterialMoss',Class'DEKRPG208AJ.AbilityMaterialStarChart'),RequiredMaterialLevels=(50,50,50,50,50,50,50,50))
}