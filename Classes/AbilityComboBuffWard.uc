class AbilityComboBuffWard extends AbilityComboBuff
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityWardInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityWardInv(Other.FindInventoryType(class'ComboAbilityWardInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityWardInv');
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
	AbilityName="Buff: Ward"
	Description="The caster and all allies receive a 10% chance per level to resist any new ailments, including magic effects, for 25 seconds. If a similar buff is applied, the chance to ward the ailment is stacked. A sound will play if you have warded an Ailment.||Non-AMs can only have one type of Ailment at a time, AMs can have two.||REQUIRED MATERIALS (for non-AMs):|You need 5 times the ability level of Combat Boots and Gloves you wish to purchase. Additionally:||Level 5: 10 Fine Burning Embers, 10 Arctic Suit||Level 6: 20 Fine Burning Embers, 20 Arctic Suit||Level 7: 30 Fine Burning Embers, 30 Arctic Suit||Level 8: 40 Fine Burning Embers, 40 Arctic Suit, 10 Icicles||Level 9: 45 Fine Burning Embers, 45 Arctic Suit, 25 Icicles||Level 10: 50 Fine Burning Embers, 50 Arctic Suit, 50 Icicles||Cost(per level): 5, 10, 15, 20...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
	MaxLevel=10
	StartingCost=5
	CostAddPerLevel=5
	BaseMultiplier=10.000000
	MultiplierAddPerStep=25.000000
	MultiplierStep=1.00000
	BaseLifespan=25.000
	Dispellable=True
	All=True
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialGloves',Class'DEKRPG999X.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialGloves',Class'DEKRPG999X.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialGloves',Class'DEKRPG999X.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialGloves',Class'DEKRPG999X.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialGloves',Class'DEKRPG999X.AbilityMaterialCombatBoots',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(25,25,10,10))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialGloves',Class'DEKRPG999X.AbilityMaterialCombatBoots',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(30,30,20,20))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialGloves',Class'DEKRPG999X.AbilityMaterialCombatBoots',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(35,35,30,30))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialGloves',Class'DEKRPG999X.AbilityMaterialCombatBoots',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialArcticSuit',Class'DEKRPG999X.AbilityMaterialIcicle'),RequiredMaterialLevels=(40,40,40,40,10))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialGloves',Class'DEKRPG999X.AbilityMaterialCombatBoots',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialArcticSuit',Class'DEKRPG999X.AbilityMaterialIcicle'),RequiredMaterialLevels=(45,45,45,45,25))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialGloves',Class'DEKRPG999X.AbilityMaterialCombatBoots',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialArcticSuit',Class'DEKRPG999X.AbilityMaterialIcicle'),RequiredMaterialLevels=(50,50,50,50,50))
}