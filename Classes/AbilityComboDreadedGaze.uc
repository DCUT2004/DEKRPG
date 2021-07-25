class AbilityComboDreadedGaze extends AbilityCombo
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityGazeInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityGazeInv(Other.FindInventoryType(class'ComboAbilityGazeInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityGazeInv');
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
	AbilityName="Dreaded Gaze"
	Description="1) For 15 seconds, the target the caster looks at receives Null Entropy.|2) The target the caster looks at receives -20% defense for 15 seconds.|3) For 15 seconds, the caster heals for 50% of the damage dealt to the target.|The caster can only apply these effects to one target at a time.||The defense is further decreased by 1% per level.||The duration of these effects is increased by 1 second per level.||This effect does not stack with similar combos.||Use the combo BBFF(back back forward forward) when you have a combo activation available(number at top left of HUD).||You must be level 90 to purchase this.||REQUIRED MATERIALS:|Level 1: 2 Nali Fruit, 2 Steel, 2 Combat Boots||Level 2: 6 Nali Fruit, 6 Steel, 6 Combat Boots||Level 3: 10 Nali Fruit, 10 Steel, 10 Combat Boots||Level 4: 15 Nali Fruit, 15 Steel, 15 Combat Boots, 5 Honeysuckle Vines||Level 5: 20 Nali Fruit, 20 Steel, 20 Combat Boots, 5 Honeysuckle Vines||Level 6: 25 Nali Fruit, 25 Steel, 25 Combat Boots, 5 Honeysuckle Vines, 5 Burning Embers||Level 7: 27 Nali Fruit, 27 Steel, 27 Combat Boots, 5 Honeysuckle Vines, 5 Burning Embers, 5 Fine Leather||Level 8: 30 Nali Fruit, 30 Steel, 30 Combat Boots, 7 Honeysuckle Vines, 7 Burning Embers, 7 Fine Leather||Level 9: 33 Nali Fruit, 33 Steel, 33 Combat Boots, 9 Honeysuckle Vines, 9 Burning Embers, 9 Fine Leather||Level 10: 36 Nali Fruit, 36 Steel, 36 Combat Boots, 11 Honeysuckle Vines, 11 Burning Embers, 11 Fine Leather||Level 11: 39 Nali Fruit, 39 Steel, 39 Combat Boots, 13 Honeysuckle Vines, 13 Burning Embers, 13 Fine Leather, 5 Icicles|| Level 12: 41 Nali Fruit, 41 Steel, 41 Combat Boots, 15 Honeysuckle Vines, 15 Burning Embers, 15 Fine Leather, 10 Icicles||Level 13: 43 Nali Fruit, 43 Steel, 43 Combat Boots, 17 Honeysuckle Vines, 17 Burning Embers, 17 Fine Leather, 15 Icicles||Level 14: 45 Nali Fruit, 45 Steel, 45 Combat Boots, 19 Honeysuckle Vines, 19 Burning Embers, 19 Fine Leather, 20 Icicles||Level 15: 47 Nali Fruit, 47 Steel, 47 Combat Boots, 21 Honeysuckle Vines, 21 Burning Embers, 21 Fine Leather, 25 Icicles||Level 16: 50 Nali Fruit, 50 Steel, 50 Combat Boots, 30 Honeysuckle Vines, 30 Burning Embers, 30 Fine Leather, 30 Icicles, 10 Star Chart||Level 17: 50 Nali Fruit, 50 Steel, 50 Combat Boots, 35 Honeysuckle Vines, 35 Burning Embers, 35 Fine Leather, 35 Icicles, 20 Star Chart||Level 18: 50 Nali Fruit, 50 Steel, 50 Combat Boots, 40 Honeysuckle Vines, 40 Burning Embers, 40 Fine Leather, 40 Icicles, 30 Star Chart||Level 19: 50 Nali Fruit, 50 Steel, 50 Combat Boots, 45 Honeysuckle Vines, 45 Burning Embers, 45 Fine Leather, 45 Icicles, 40 Star Chart||Level 20: 50 Nali Fruit, 50 Steel, 50 Combat Boots, 50 Honeysuckle Vines, 50 Burning Embers, 50 Fine Leather, 50 Icicles, 50 Star Chart||You can have up to 3 combos at a time. Combos are refundable by using the Refund button while the Combos list is open.||Cost(per level): 2, 4, 6, 8, 10..."
	MaxLevel=20
	StartingCost=2
	CostAddPerLevel=2
	BaseMultiplier=1.19000
	MultiplierAddPerStep=0.010000
	MultiplierStep=1.00000
	BaseLifespan=14.000
	LifespanAddPerStep=1.0000
	LifespanStep=1.00000
	Dispellable=False
	All=False
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialSteel',Class'DEKRPG208AB.AbilityMaterialNaliFruit',Class'DEKRPG208AB.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(2,2,2))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialSteel',Class'DEKRPG208AB.AbilityMaterialNaliFruit',Class'DEKRPG208AB.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(6,6,6))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialSteel',Class'DEKRPG208AB.AbilityMaterialNaliFruit',Class'DEKRPG208AB.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(10,10,10))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialSteel',Class'DEKRPG208AB.AbilityMaterialNaliFruit',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(15,15,15,5))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialSteel',Class'DEKRPG208AB.AbilityMaterialNaliFruit',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialHoneysuckleVine'),RequiredMaterialLevels=(20,20,20,5))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialSteel',Class'DEKRPG208AB.AbilityMaterialNaliFruit',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AB.AbilityMaterialEmbers'),RequiredMaterialLevels=(25,25,25,5,5))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialSteel',Class'DEKRPG208AB.AbilityMaterialNaliFruit',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AB.AbilityMaterialEmbers',Class'DEKRPG208AB.AbilityMaterialLeather'),RequiredMaterialLevels=(27,27,27,5,5,5))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialSteel',Class'DEKRPG208AB.AbilityMaterialNaliFruit',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AB.AbilityMaterialEmbers',Class'DEKRPG208AB.AbilityMaterialLeather'),RequiredMaterialLevels=(30,30,30,7,7,7))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialSteel',Class'DEKRPG208AB.AbilityMaterialNaliFruit',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AB.AbilityMaterialEmbers',Class'DEKRPG208AB.AbilityMaterialLeather'),RequiredMaterialLevels=(33,33,33,9,9,9))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialSteel',Class'DEKRPG208AB.AbilityMaterialNaliFruit',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AB.AbilityMaterialEmbers',Class'DEKRPG208AB.AbilityMaterialLeather'),RequiredMaterialLevels=(36,36,36,11,11,11))
	Materials(10)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialSteel',Class'DEKRPG208AB.AbilityMaterialNaliFruit',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AB.AbilityMaterialEmbers',Class'DEKRPG208AB.AbilityMaterialLeather',Class'DEKRPG208AB.AbilityMaterialIcicle'),RequiredMaterialLevels=(39,39,39,13,13,13,5))
	Materials(11)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialSteel',Class'DEKRPG208AB.AbilityMaterialNaliFruit',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AB.AbilityMaterialEmbers',Class'DEKRPG208AB.AbilityMaterialLeather',Class'DEKRPG208AB.AbilityMaterialIcicle'),RequiredMaterialLevels=(41,41,41,15,15,15,10))
	Materials(12)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialSteel',Class'DEKRPG208AB.AbilityMaterialNaliFruit',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AB.AbilityMaterialEmbers',Class'DEKRPG208AB.AbilityMaterialLeather',Class'DEKRPG208AB.AbilityMaterialIcicle'),RequiredMaterialLevels=(43,43,43,17,17,17,15))
	Materials(13)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialSteel',Class'DEKRPG208AB.AbilityMaterialNaliFruit',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AB.AbilityMaterialEmbers',Class'DEKRPG208AB.AbilityMaterialLeather',Class'DEKRPG208AB.AbilityMaterialIcicle'),RequiredMaterialLevels=(45,45,45,19,19,19,20))
	Materials(14)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialSteel',Class'DEKRPG208AB.AbilityMaterialNaliFruit',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AB.AbilityMaterialEmbers',Class'DEKRPG208AB.AbilityMaterialLeather',Class'DEKRPG208AB.AbilityMaterialIcicle'),RequiredMaterialLevels=(47,47,47,21,21,21,25))
	Materials(15)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialSteel',Class'DEKRPG208AB.AbilityMaterialNaliFruit',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AB.AbilityMaterialEmbers',Class'DEKRPG208AB.AbilityMaterialLeather',Class'DEKRPG208AB.AbilityMaterialIcicle',Class'DEKRPG208AB.AbilityMaterialStarChart'),RequiredMaterialLevels=(50,50,50,30,30,30,30,10))
	Materials(16)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialSteel',Class'DEKRPG208AB.AbilityMaterialNaliFruit',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AB.AbilityMaterialEmbers',Class'DEKRPG208AB.AbilityMaterialLeather',Class'DEKRPG208AB.AbilityMaterialIcicle',Class'DEKRPG208AB.AbilityMaterialStarChart'),RequiredMaterialLevels=(50,50,50,35,35,35,35,20))
	Materials(17)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialSteel',Class'DEKRPG208AB.AbilityMaterialNaliFruit',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AB.AbilityMaterialEmbers',Class'DEKRPG208AB.AbilityMaterialLeather',Class'DEKRPG208AB.AbilityMaterialIcicle',Class'DEKRPG208AB.AbilityMaterialStarChart'),RequiredMaterialLevels=(50,50,50,40,40,40,40,30))
	Materials(18)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialSteel',Class'DEKRPG208AB.AbilityMaterialNaliFruit',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AB.AbilityMaterialEmbers',Class'DEKRPG208AB.AbilityMaterialLeather',Class'DEKRPG208AB.AbilityMaterialIcicle',Class'DEKRPG208AB.AbilityMaterialStarChart'),RequiredMaterialLevels=(50,50,50,45,45,45,45,40))
	Materials(19)=(RequiredMaterials=(Class'DEKRPG208AB.AbilityMaterialSteel',Class'DEKRPG208AB.AbilityMaterialNaliFruit',Class'DEKRPG208AB.AbilityMaterialCombatBoots',Class'DEKRPG208AB.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AB.AbilityMaterialEmbers',Class'DEKRPG208AB.AbilityMaterialLeather',Class'DEKRPG208AB.AbilityMaterialIcicle',Class'DEKRPG208AB.AbilityMaterialStarChart'),RequiredMaterialLevels=(50,50,50,50,50,50,50,50))
}