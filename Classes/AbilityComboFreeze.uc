class AbilityComboFreeze extends AbilityCombo
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityFreezeInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityFreezeInv(Other.FindInventoryType(class'ComboAbilityFreezeInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityFreezeInv');
			Inv.GiveTo(Other);
		}
		if (Inv != None)
		{
			Inv.EffectMultiplier = (default.BaseMultiplier + (default.MultiplierAddPerStep*AbilityLevel/default.MultiplierStep));
			Inv.ComboLifespan = (default.BaseLifespan + (default.LifespanAddPerStep*AbilityLevel/default.LifespanStep));
			Inv.ComboDamage = (default.BaseDamage + (default.DamageAddPerStep*AbilityLevel/default.DamageStep));
			Inv.bDispellable = default.Dispellable;
			Inv.bAll = default.All;
			Inv.bSingle = default.Single;
		}
	}
}

defaultproperties
{
	Description="1) Deals 50 damage to all enemies.|2) All enemies receive freeze for 10 seconds.||The damage is increased by 5 every 2 levels.|The duration is increased by 1 second per level.|This combo stacks with a similar effect at a diminishing rate.|Use the combo BBFF(back back forward forward) when you have a combo activation available(number at top left of HUD).|You must be level 90 to purchase this.||REQUIRED MATERIALS:|Level 1: 2 Combat Boots, 2 Gloves, 2 Lumber||Level 2: 6 Combat Boots, 6 Gloves, 6 Lumber||Level 3: 10 Combat Boots, 10 Gloves, 10 Lumber||Level 4: 15 Combat Boots, 15 Gloves, 15 Lumber, 5 Fine Leather||Level 5: 20 Combat Boots, 20 Gloves, 20 Lumber, 5 Fine Leather||Level 6: 25 Combat Boots, 25 Gloves, 25 Lumber, 5 Fine Leather, 5 Arctic Suit||Level 7: 27 Combat Boots, 27 Gloves, 27 Lumber, 5 Fine Leather, 5 Arctic Suit, 5 Plated Armor||Level 8: 30 Combat Boots, 30 Gloves, 30 Lumber, 7 Fine Leather, 7 Arctic Suit, 7 Plated Armor||Level 9: 33 Combat Boots, 33 Gloves, 33 Lumber, 9 Fine Leather, 9 Arctic Suit, 9 Plated Armor||Level 10: 36 Combat Boots, 36 Gloves, 36 Lumber, 11 Fine Leather, 11 Arctic Suit, 11 Plated Armor||Level 11: 39 Combat Boots, 39 Gloves, 39 Lumber, 13 Fine Leather, 13 Arctic Suit, 13 Plated Armor, 5 Icicle|| Level 12: 41 Combat Boots, 41 Gloves, 41 Lumber, 15 Fine Leather, 15 Arctic Suit, 15 Plated Armor, 10 Icicle||Level 13: 43 Combat Boots, 43 Gloves, 43 Lumber, 17 Fine Leather, 17 Arctic Suit, 17 Plated Armor, 15 Icicle||Level 14: 45 Combat Boots, 45 Gloves, 45 Lumber, 19 Fine Leather, 19 Arctic Suit, 19 Plated Armor, 20 Icicle||Level 15: 47 Combat Boots, 47 Gloves, 47 Lumber, 21 Fine Leather, 21 Arctic Suit, 21 Plated Armor, 25 Icicle||Level 16: 50 Combat Boots, 50 Gloves, 50 Lumber, 30 Fine Leather, 30 Arctic Suit, 30 Plated Armor, 30 Icicle, 10 Arcane Hourglass||Level 17: 50 Combat Boots, 50 Gloves, 50 Lumb, 35 Fine Leather, 35 Arctic Suit, 35 Plated Armor, 35 Icicle, 20 Arcane Hourglass||Level 18: 50 Combat Boots, 50 Gloves, 50 Lumber, 40 Fine Leather, 40 Arctic Suit, 40 Plated Armor, 40 Icicle, 30 Arcane Hourglass||Level 19: 50 Combat Boots, 50 Gloves, 50 Lumber, 45 Fine Leather, 45 Arctic Suit, 45 Plated Armor, 45 Icicle, 40 Arcane Hourglass||Level 20: 50 Combat Boots, 50 Gloves, 50 Lumber, 50 Fine Leather, 50 Arctic Suit, 50 Plated Armor, 50 Icicle, 50 Arcane Hourglass||You can have up to 3 combos at a time. Combos are refundable by using the Refund button while the Combos list is open.||Cost(per level): 2, 4, 6, 8, 10..."
	AbilityName="Cold Front"
	MaxLevel=20
	StartingCost=2
	CostAddPerLevel=2
	BaseMultiplier=3.0000
	MultiplierAddPerStep=0.000000
	MultiplierStep=4.00000
	BaseLifespan=10.000
	LifespanAddPerStep=1.0000
	LifespanStep=1.00000
	BaseDamage=2
	DamageAddPerStep=2
	DamageStep=2
	Dispellable=True
	All=True
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialGloves',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialLumber'),RequiredMaterialLevels=(2,2,2))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialGloves',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialLumber'),RequiredMaterialLevels=(6,6,6))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialGloves',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialLumber'),RequiredMaterialLevels=(10,10,10))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialGloves',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialLumber',Class'DEKRPG208AB.AbilityMaterialLeather'),RequiredMaterialLevels=(15,15,15,5))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialGloves',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialLumber',Class'DEKRPG208AB.AbilityMaterialLeather'),RequiredMaterialLevels=(20,20,20,5))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialGloves',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialLumber',Class'DEKRPG208AB.AbilityMaterialLeather',Class'DEKRPG208AB.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(25,25,25,5,5))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialGloves',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialLumber',Class'DEKRPG208AB.AbilityMaterialLeather',Class'DEKRPG208AB.AbilityMaterialArcticSuit',Class'DEKRPG208AB.AbilityMaterialPlatedArmor'),RequiredMaterialLevels=(27,27,27,5,5,5))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialGloves',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialLumber',Class'DEKRPG208AB.AbilityMaterialLeather',Class'DEKRPG208AB.AbilityMaterialArcticSuit',Class'DEKRPG208AB.AbilityMaterialPlatedArmor'),RequiredMaterialLevels=(30,30,30,7,7,7))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialGloves',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialLumber',Class'DEKRPG208AB.AbilityMaterialLeather',Class'DEKRPG208AB.AbilityMaterialArcticSuit',Class'DEKRPG208AB.AbilityMaterialPlatedArmor'),RequiredMaterialLevels=(33,33,33,9,9,9))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialGloves',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialLumber',Class'DEKRPG208AB.AbilityMaterialLeather',Class'DEKRPG208AB.AbilityMaterialArcticSuit',Class'DEKRPG208AB.AbilityMaterialPlatedArmor'),RequiredMaterialLevels=(36,36,36,11,11,11))
	Materials(10)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialGloves',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialLumber',Class'DEKRPG208AB.AbilityMaterialLeather',Class'DEKRPG208AB.AbilityMaterialArcticSuit',Class'DEKRPG208AB.AbilityMaterialPlatedArmor',Class'DEKRPG208AB.AbilityMaterialIcicle'),RequiredMaterialLevels=(39,39,39,13,13,13,5))
	Materials(11)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialGloves',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialLumber',Class'DEKRPG208AB.AbilityMaterialLeather',Class'DEKRPG208AB.AbilityMaterialArcticSuit',Class'DEKRPG208AB.AbilityMaterialPlatedArmor',Class'DEKRPG208AB.AbilityMaterialIcicle'),RequiredMaterialLevels=(41,41,41,15,15,15,10))
	Materials(12)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialGloves',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialLumber',Class'DEKRPG208AB.AbilityMaterialLeather',Class'DEKRPG208AB.AbilityMaterialArcticSuit',Class'DEKRPG208AB.AbilityMaterialPlatedArmor',Class'DEKRPG208AB.AbilityMaterialIcicle'),RequiredMaterialLevels=(43,43,43,17,17,17,15))
	Materials(13)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialGloves',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialLumber',Class'DEKRPG208AB.AbilityMaterialLeather',Class'DEKRPG208AB.AbilityMaterialArcticSuit',Class'DEKRPG208AB.AbilityMaterialPlatedArmor',Class'DEKRPG208AB.AbilityMaterialIcicle'),RequiredMaterialLevels=(45,45,45,19,19,19,20))
	Materials(14)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialGloves',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialLumber',Class'DEKRPG208AB.AbilityMaterialLeather',Class'DEKRPG208AB.AbilityMaterialArcticSuit',Class'DEKRPG208AB.AbilityMaterialPlatedArmor',Class'DEKRPG208AB.AbilityMaterialIcicle'),RequiredMaterialLevels=(47,47,47,21,21,21,25))
	Materials(15)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialGloves',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialLumber',Class'DEKRPG208AB.AbilityMaterialLeather',Class'DEKRPG208AB.AbilityMaterialArcticSuit',Class'DEKRPG208AB.AbilityMaterialPlatedArmor',Class'DEKRPG208AB.AbilityMaterialIcicle',Class'DEKRPG208AB.AbilityMaterialHourglass'),RequiredMaterialLevels=(50,50,50,30,30,30,30,10))
	Materials(16)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialGloves',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialLumber',Class'DEKRPG208AB.AbilityMaterialLeather',Class'DEKRPG208AB.AbilityMaterialArcticSuit',Class'DEKRPG208AB.AbilityMaterialPlatedArmor',Class'DEKRPG208AB.AbilityMaterialIcicle',Class'DEKRPG208AB.AbilityMaterialHourglass'),RequiredMaterialLevels=(50,50,50,35,35,35,35,20))
	Materials(17)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialGloves',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialLumber',Class'DEKRPG208AB.AbilityMaterialLeather',Class'DEKRPG208AB.AbilityMaterialArcticSuit',Class'DEKRPG208AB.AbilityMaterialPlatedArmor',Class'DEKRPG208AB.AbilityMaterialIcicle',Class'DEKRPG208AB.AbilityMaterialHourglass'),RequiredMaterialLevels=(50,50,50,40,40,40,40,30))
	Materials(18)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialGloves',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialLumber',Class'DEKRPG208AB.AbilityMaterialLeather',Class'DEKRPG208AB.AbilityMaterialArcticSuit',Class'DEKRPG208AB.AbilityMaterialPlatedArmor',Class'DEKRPG208AB.AbilityMaterialIcicle',Class'DEKRPG208AB.AbilityMaterialHourglass'),RequiredMaterialLevels=(50,50,50,45,45,45,45,40))
	Materials(19)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialGloves',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialLumber',Class'DEKRPG208AB.AbilityMaterialLeather',Class'DEKRPG208AB.AbilityMaterialArcticSuit',Class'DEKRPG208AB.AbilityMaterialPlatedArmor',Class'DEKRPG208AB.AbilityMaterialIcicle',Class'DEKRPG208AB.AbilityMaterialHourglass'),RequiredMaterialLevels=(50,50,50,50,50,50,50,50))
}