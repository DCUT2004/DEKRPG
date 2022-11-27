class AbilityComboBuffDefense extends AbilityComboBuff
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local StatusEffectInventory_Player StatusInv;
	
	if (Other == None)
		return;


	StatusInv = StatusEffectInventory_Player(Other.FindInventoryType(Class'StatusEffectInventory_Player'));
	
	if (StatusInv == None)
		return;

	StatusInv.AddCombo(Class'StatusEffect_DamageReduction', AbilityLevel, default.BaseLifespan, default.Dispellable, default.Stackable);
}

defaultproperties
{
	AbilityName="Buff: Defense"
	Description="The caster and all allies receive 2% damage reduction per level for 25 seconds. If a similar buff is applied, the effect is stacked. Allies with increased defense have a green orb.||Non-AMs can only have one type of Ailment at a time, AMs can have two.||REQUIRED MATERIALS (for non-AMs):|You need 5 times the ability level of Combat Boots and Steel you wish to purchase. Additionally:||Level 5: 10 Fine Plated Armor, 10 Arctic Suit||Level 6: 20 Fine Plated Armor, 20 Arctic Suit||Level 7: 30 Fine Plated Armor, 30 Arctic Suit||Level 8: 40 Fine Plated Armor, 40 Arctic Suit, 10 Icicles||Level 9: 45 Fine Plated Armor, 45 Arctic Suit, 25 Icicles||Level 10: 50 Fine Plated Armor, 50 Arctic Suit, 50 Icicles||Cost(per level): 3, 6, 9...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
	BaseMultiplier=0.025000
	MultiplierAddPerStep=25.000000
	MultiplierStep=1.00000
	BaseLifespan=25.000
	Dispellable=True
	Stackable=True
	All=True
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialCombatBoots',Class'DEKRPG999X.AbilityMaterialPlatedArmor',Class'DEKRPG999X.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(25,25,10,10))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialCombatBoots',Class'DEKRPG999X.AbilityMaterialPlatedArmor',Class'DEKRPG999X.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(30,30,20,20))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialCombatBoots',Class'DEKRPG999X.AbilityMaterialPlatedArmor',Class'DEKRPG999X.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(35,35,30,30))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialCombatBoots',Class'DEKRPG999X.AbilityMaterialPlatedArmor',Class'DEKRPG999X.AbilityMaterialArcticSuit',Class'DEKRPG999X.AbilityMaterialIcicle'),RequiredMaterialLevels=(40,40,40,40,10))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialCombatBoots',Class'DEKRPG999X.AbilityMaterialPlatedArmor',Class'DEKRPG999X.AbilityMaterialArcticSuit',Class'DEKRPG999X.AbilityMaterialIcicle'),RequiredMaterialLevels=(45,45,45,45,25))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialCombatBoots',Class'DEKRPG999X.AbilityMaterialPlatedArmor',Class'DEKRPG999X.AbilityMaterialArcticSuit',Class'DEKRPG999X.AbilityMaterialIcicle'),RequiredMaterialLevels=(50,50,50,50,50))
}