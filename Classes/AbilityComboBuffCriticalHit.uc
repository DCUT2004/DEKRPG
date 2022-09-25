class AbilityComboBuffCriticalHit extends AbilityComboBuff
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

	StatusInv.AddCombo(Class'StatusEffect_ChanceHit'.static.GetName(), AbilityLevel, default.BaseLifespan, default.Dispellable, default.Stackable);
}

defaultproperties
{
	AbilityName="Buff: Critical Hit"
	Description="The caster and all allies receive Critical Hit for 25 seconds, which provides a 5% chance per level to deal double damage on each hit. A purple flash and sound indicates a critical hit.||Non-AMs can only have one type of Ailment at a time, AMs can have two.||REQUIRED MATERIALS (for non-AMs):|You need 5 times the ability level of Tarydium Shard and Lumber you wish to purchase. Additionally:||Level 5: 10 Fine Honeysuckle Vine, 10 Burning Embers||Level 6: 20 Fine Honeysuckle Vine, 20 Burning Embers||Level 7: 30 Fine Honeysuckle Vine, 30 Burning Embers||Level 8: 40 Fine Honeysuckle Vine, 40 Burning Embers, 10 Cosmic Dust||Level 9: 45 Fine Honeysuckle Vine, 45 Burning Embers, 25 Cosmic Dust||Level 10: 50 Fine Honeysuckle Vine, 50 Burning Embers, 50 Cosmic Dust||Cost(per level): 3, 6, 9...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
	BaseMultiplier=3.500000
	MultiplierAddPerStep=25.000000
	MultiplierStep=1.00000
	BaseLifespan=25.000
	Dispellable=True
	Stackable=True
	All=True
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialTarydiumShards'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialTarydiumShards'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialTarydiumShards'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialTarydiumShards'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialHoneysuckleVine',Class'DEKRPG999X.AbilityMaterialEmbers'),RequiredMaterialLevels=(25,25,10,10))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialHoneysuckleVine',Class'DEKRPG999X.AbilityMaterialEmbers'),RequiredMaterialLevels=(30,30,20,20))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialHoneysuckleVine',Class'DEKRPG999X.AbilityMaterialEmbers'),RequiredMaterialLevels=(35,35,30,30))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialHoneysuckleVine',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialDust'),RequiredMaterialLevels=(40,40,40,40,10))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialHoneysuckleVine',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialDust'),RequiredMaterialLevels=(45,45,45,45,25))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialTarydiumShards',Class'DEKRPG999X.AbilityMaterialHoneysuckleVine',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialDust'),RequiredMaterialLevels=(50,50,50,50,50))
}