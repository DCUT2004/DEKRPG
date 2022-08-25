class AbilityComboAilmentPoison extends AbilityComboAilment
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

	StatusInv.AddCombo(Class'StatusEffect_Poison', -AbilityLevel, default.BaseLifespan, default.Dispellable, default.Stackable);
}


defaultproperties
{
	AbilityName="Ailment: Poison"
	Description="All targets receive Poison for 25 seconds. Each level increases the Poison damage. If a similar ailment is applied, the effect is stacked.||Non-AMs can only have one type of Ailment at a time, AMs can have two.||REQUIRED MATERIALS (for non-AMs):|You need 5 times the ability level of Combat Boots and Steel you wish to purchase. Additionally:||Level 5: 10 Honeysuckle Vine, 10 Burning Embers||Level 6: 20 Honeysuckle Vine, 20 Burning Embers||Level 7: 30 Honeysuckle Vine, 30 Burning Embers||Level 8: 40 Honeysuckle Vine, 40 Burning Embers, 10 Cosmic Dust||Level 9: 45 Honeysuckle Vine, 45 Burning Embers, 25 Cosmic Dust||Level 10: 50 Honeysuckle Vine, 50 Burning Embers, 50 Cosmic Dust||Cost(per level): 3, 6, 9...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
	BaseMultiplier=1.00000
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
	Materials(4)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialCombatBoots',Class'DEKRPG999X.AbilityMaterialHoneysuckleVine',Class'DEKRPG999X.AbilityMaterialEmbers'),RequiredMaterialLevels=(25,25,10,10))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialCombatBoots',Class'DEKRPG999X.AbilityMaterialHoneysuckleVine',Class'DEKRPG999X.AbilityMaterialEmbers'),RequiredMaterialLevels=(30,30,20,20))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialCombatBoots',Class'DEKRPG999X.AbilityMaterialHoneysuckleVine',Class'DEKRPG999X.AbilityMaterialEmbers'),RequiredMaterialLevels=(35,35,30,30))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialCombatBoots',Class'DEKRPG999X.AbilityMaterialHoneysuckleVine',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialDust'),RequiredMaterialLevels=(40,40,40,40,10))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialCombatBoots',Class'DEKRPG999X.AbilityMaterialHoneysuckleVine',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialDust'),RequiredMaterialLevels=(45,45,45,45,25))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialCombatBoots',Class'DEKRPG999X.AbilityMaterialHoneysuckleVine',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialDust'),RequiredMaterialLevels=(50,50,50,50,50))
}