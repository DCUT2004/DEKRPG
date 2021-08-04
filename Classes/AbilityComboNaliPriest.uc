class AbilityComboNaliPriest extends AbilityCombo
	config(UT2004RPG)
	abstract;
	
var config int HealPerLevel;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityNaliPriestInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityNaliPriestInv(Other.FindInventoryType(class'ComboAbilityNaliPriestInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityNaliPriestInv');
			Inv.GiveTo(Other);
		}
		if (Inv != None)
		{
			Inv.EffectMultiplier = (default.BaseMultiplier + (default.MultiplierAddPerStep*AbilityLevel/default.MultiplierStep));
			Inv.ComboLifespan = (default.BaseLifespan + (default.LifespanAddPerStep*AbilityLevel/default.LifespanStep));
			Inv.bDispellable = default.Dispellable;
			Inv.bAll = default.All;
			Inv.bSingle = default.Single;
			Inv.NaliPriestHealAmount = (AbilityLevel*default.HealPerLevel);
		}
	}
}

defaultproperties
{
	AbilityName="Nali Priest"
	Description="1) Summons a Nali Priest pet with 400 health, with a max health of 800 and a duration of 60 seconds.|2) If a Nali Priest already exists, the Nali Priest heals by 20.|3) The Nali Priest absorbs 40% of all damage received by the caster and all allies.||Each level of this combo increases the amount of damage absorbed by the Nali Priest by 2.5%.||Each level of this combo increases the heal amount by 20.||Each level of this combo increases the duration of the Nali Priest by 10 seconds.||This effect does not stack with similar combos.||Use the combo BBFF(back back forward forward) when you have a combo activation available(number at top left of HUD).||You must be level 90 to purchase this.||REQUIRED MATERIALS:|Level 1: 2 Nali Fruit, 2 Gloves, 2 Combat Boots||Level 2: 6 Nali Fruit, 6 Gloves, 6 Combat Boots||Level 3: 10 Nali Fruit, 10 Gloves, 10 Combat Boots||Level 4: 15 Nali Fruit, 15 Gloves, 15 Combat Boots, 5 Arctic Suit||Level 5: 20 Nali Fruit, 20 Gloves, 20 Combat Boots, 5 Arctic Suit||Level 6: 25 Nali Fruit, 25 Gloves, 25 Combat Boots, 5 Arctic Suit, 5 Honeysuckle Vines||Level 7: 27 Nali Fruit, 27 Gloves, 27 Combat Boots, 5 Arctic Suit, 5 Honeysuckle Vines, 5 Plated Armor||Level 8: 30 Nali Fruit, 30 Gloves, 30 Combat Boots, 7 Arctic Suit, 7 Honeysuckle Vines, 7 Plated Armor||Level 9: 33 Nali Fruit, 33 Gloves, 33 Combat Boots, 9 Arctic Suit, 9 Honeysuckle Vines, 9 Plated Armor||Level 10: 36 Nali Fruit, 36 Gloves, 36 Combat Boots, 11 Arctic Suit, 11 Honeysuckle Vines, 11 Plated Armor||Level 11: 39 Nali Fruit, 39 Gloves, 39 Combat Boots, 13 Arctic Suit, 13 Honeysuckle Vines, 13 Plated Armor, 5 Moss|| Level 12: 41 Nali Fruit, 41 Gloves, 41 Combat Boots, 15 Arctic Suit, 15 Honeysuckle Vines, 15 Plated Armor, 10 Moss||Level 13: 43 Nali Fruit, 43 Gloves, 43 Combat Boots, 17 Arctic Suit, 17 Honeysuckle Vines, 17 Plated Armor, 15 Moss||Level 14: 45 Nali Fruit, 45 Gloves, 45 Combat Boots, 19 Arctic Suit, 19 Honeysuckle Vines, 19 Plated Armor, 20 Moss||Level 15: 47 Nali Fruit, 47 Gloves, 47 Combat Boots, 21 Arctic Suit, 21 Honeysuckle Vines, 21 Plated Armor, 25 Moss||Level 16: 50 Nali Fruit, 50 Gloves, 50 Combat Boots, 30 Arctic Suit, 30 Honeysuckle Vines, 30 Plated Armor, 30 Moss, 10 Moonlit Stone||Level 17: 50 Nali Fruit, 50 Gloves, 50 Combat Boots, 35 Arctic Suit, 35 Honeysuckle Vines, 35 Plated Armor, 35 Moss, 20 Moonlit Stone||Level 18: 50 Nali Fruit, 50 Gloves, 50 Combat Boots, 40 Arctic Suit, 40 Honeysuckle Vines, 40 Plated Armor, 40 Moss, 30 Moonlit Stone||Level 19: 50 Nali Fruit, 50 Gloves, 50 Combat Boots, 45 Arctic Suit, 45 Honeysuckle Vines, 45 Plated Armor, 45 Moss, 40 Moonlit Stone||Level 20: 50 Nali Fruit, 50 Gloves, 50 Combat Boots, 50 Arctic Suit, 50 Honeysuckle Vines, 50 Plated Armor, 50 Moss, 50 Moonlit Stone||You can have up to 3 combos at a time. Combos are refundable by using the Refund button while the Combos list is open.||Cost(per level): 2, 4, 6, 8, 10..."
	MaxLevel=20
	StartingCost=2
	CostAddPerLevel=2
	BaseMultiplier=0.40000
	MultiplierAddPerStep=0.050000
	MultiplierStep=2.00000
	BaseLifespan=50.000
	LifespanAddPerStep=10.0000
	LifespanStep=1.00000
	Dispellable=False
	All=False
	Single=False
	HealPerLevel=20
	Materials(0)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialNaliFruit',Class'DEKRPG208AF.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(2,2,2))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialNaliFruit',Class'DEKRPG208AF.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(6,6,6))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialNaliFruit',Class'DEKRPG208AF.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(10,10,10))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialNaliFruit',Class'DEKRPG208AF.AbilityMaterialCombatBoots',Class'DEKRPG208AF.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(15,15,15,5))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialNaliFruit',Class'DEKRPG208AF.AbilityMaterialCombatBoots',Class'DEKRPG208AF.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(20,20,20,5))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialNaliFruit',Class'DEKRPG208AF.AbilityMaterialCombatBoots',Class'DEKRPG208AF.AbilityMaterialArcticSuit',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(25,25,25,5,5))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialNaliFruit',Class'DEKRPG208AF.AbilityMaterialCombatBoots',Class'DEKRPG208AF.AbilityMaterialArcticSuit',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialPlatedArmor'),RequiredMaterialLevels=(27,27,27,5,5,5))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialNaliFruit',Class'DEKRPG208AF.AbilityMaterialCombatBoots',Class'DEKRPG208AF.AbilityMaterialArcticSuit',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialPlatedArmor'),RequiredMaterialLevels=(30,30,30,7,7,7))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialNaliFruit',Class'DEKRPG208AF.AbilityMaterialCombatBoots',Class'DEKRPG208AF.AbilityMaterialArcticSuit',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialPlatedArmor'),RequiredMaterialLevels=(33,33,33,9,9,9))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialNaliFruit',Class'DEKRPG208AF.AbilityMaterialCombatBoots',Class'DEKRPG208AF.AbilityMaterialArcticSuit',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialPlatedArmor'),RequiredMaterialLevels=(36,36,36,11,11,11))
	Materials(10)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialNaliFruit',Class'DEKRPG208AF.AbilityMaterialCombatBoots',Class'DEKRPG208AF.AbilityMaterialArcticSuit',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialPlatedArmor',Class'DEKRPG208AF.AbilityMaterialMoss'),RequiredMaterialLevels=(39,39,39,13,13,13,5))
	Materials(11)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialNaliFruit',Class'DEKRPG208AF.AbilityMaterialCombatBoots',Class'DEKRPG208AF.AbilityMaterialArcticSuit',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialPlatedArmor',Class'DEKRPG208AF.AbilityMaterialMoss'),RequiredMaterialLevels=(41,41,41,15,15,15,10))
	Materials(12)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialNaliFruit',Class'DEKRPG208AF.AbilityMaterialCombatBoots',Class'DEKRPG208AF.AbilityMaterialArcticSuit',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialPlatedArmor',Class'DEKRPG208AF.AbilityMaterialMoss'),RequiredMaterialLevels=(43,43,43,17,17,17,15))
	Materials(13)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialNaliFruit',Class'DEKRPG208AF.AbilityMaterialCombatBoots',Class'DEKRPG208AF.AbilityMaterialArcticSuit',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialPlatedArmor',Class'DEKRPG208AF.AbilityMaterialMoss'),RequiredMaterialLevels=(45,45,45,19,19,19,20))
	Materials(14)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialNaliFruit',Class'DEKRPG208AF.AbilityMaterialCombatBoots',Class'DEKRPG208AF.AbilityMaterialArcticSuit',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialPlatedArmor',Class'DEKRPG208AF.AbilityMaterialMoss'),RequiredMaterialLevels=(47,47,47,21,21,21,25))
	Materials(15)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialNaliFruit',Class'DEKRPG208AF.AbilityMaterialCombatBoots',Class'DEKRPG208AF.AbilityMaterialArcticSuit',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialPlatedArmor',Class'DEKRPG208AF.AbilityMaterialMoss',Class'DEKRPG208AF.AbilityMaterialMoonlitStone'),RequiredMaterialLevels=(50,50,50,30,30,30,30,10))
	Materials(16)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialNaliFruit',Class'DEKRPG208AF.AbilityMaterialCombatBoots',Class'DEKRPG208AF.AbilityMaterialArcticSuit',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialPlatedArmor',Class'DEKRPG208AF.AbilityMaterialMoss',Class'DEKRPG208AF.AbilityMaterialMoonlitStone'),RequiredMaterialLevels=(50,50,50,35,35,35,35,20))
	Materials(17)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialNaliFruit',Class'DEKRPG208AF.AbilityMaterialCombatBoots',Class'DEKRPG208AF.AbilityMaterialArcticSuit',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialPlatedArmor',Class'DEKRPG208AF.AbilityMaterialMoss',Class'DEKRPG208AF.AbilityMaterialMoonlitStone'),RequiredMaterialLevels=(50,50,50,40,40,40,40,30))
	Materials(18)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialNaliFruit',Class'DEKRPG208AF.AbilityMaterialCombatBoots',Class'DEKRPG208AF.AbilityMaterialArcticSuit',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialPlatedArmor',Class'DEKRPG208AF.AbilityMaterialMoss',Class'DEKRPG208AF.AbilityMaterialMoonlitStone'),RequiredMaterialLevels=(50,50,50,45,45,45,45,40))
	Materials(19)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialNaliFruit',Class'DEKRPG208AF.AbilityMaterialCombatBoots',Class'DEKRPG208AF.AbilityMaterialArcticSuit',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialPlatedArmor',Class'DEKRPG208AF.AbilityMaterialMoss',Class'DEKRPG208AF.AbilityMaterialMoonlitStone'),RequiredMaterialLevels=(50,50,50,50,50,50,50,50))
}