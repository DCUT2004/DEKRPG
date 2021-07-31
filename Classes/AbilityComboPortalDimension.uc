class AbilityComboPortalDimension extends AbilityCombo
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityPortalDimensionInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityPortalDimensionInv(Other.FindInventoryType(class'ComboAbilityPortalDimensionInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityPortalDimensionInv');
			Inv.GiveTo(Other);
		}
		if (Inv != None)
		{
			Inv.SkillLevel = (default.BaseMultiplier + (default.MultiplierAddPerStep*AbilityLevel/default.MultiplierStep));
			Inv.MonsterLifespan = (default.BaseLifespan + (default.LifespanAddPerStep*AbilityLevel/default.LifespanStep));
			Inv.ComboLifespan = 2;
		}
	}
}

defaultproperties
{
	AbilityName="Portal Dimension"
	Description="1) Spawns a friendly monster portal. Pets spawned by the portal have a life span of 120 seconds.||Every 3 levels of this combo increases the skill of your pets.||The lifespan of your pets is increased by 5 seconds per level.||This effect does not stack with similar combos.||Use the combo BBFF(back back forward forward) when you have a combo activation available(number at top left of HUD).||You must be level 90 to purchase this.||REQUIRED MATERIALS:|Level 1: 2 Gloves, 2 Steel, 2 Tarydium Shards||Level 2: 6 Gloves, 6 Steel, 6 Tarydium Shards||Level 3: 10 Gloves, 10 Steel, 10 Tarydium Shards||Level 4: 15 Gloves, 15 Steel, 15 Tarydium Shards, 5 Arctic Suit||Level 5: 20 Gloves, 20 Steel, 20 Tarydium Shards, 5 Arctic Suit||Level 6: 25 Gloves, 25 Steel, 25 Tarydium Shards, 5 Arctic Suit, 5 Fine Leather||Level 7: 27 Gloves, 27 Steel, 27 Tarydium Shards, 5 Arctic Suit, 5 Fine Leather, 5 Burning Embers||Level 8: 30 Gloves, 30 Steel, 30 Tarydium Shards, 7 Arctic Suit, 7 Fine Leather, 7 Burning Embers||Level 9: 33 Gloves, 33 Steel, 33 Tarydium Shards, 9 Arctic Suit, 9 Fine Leather, 9 Burning Embers||Level 10: 36 Gloves, 36 Steel, 36 Tarydium Shards, 11 Arctic Suit, 11 Fine Leather, 11 Burning Embers||Level 11: 39 Gloves, 39 Steel, 39 Tarydium Shards, 13 Arctic Suit, 13 Fine Leather, 13 Burning Embers, 5 Cosmic Dust|| Level 12: 41 Gloves, 41 Steel, 41 Tarydium Shards, 15 Arctic Suit, 15 Fine Leather, 15 Burning Embers, 10 Cosmic Dust||Level 13: 43 Gloves, 43 Steel, 43 Tarydium Shards, 17 Arctic Suit, 17 Fine Leather, 17 Burning Embers, 15 Cosmic Dust||Level 14: 45 Gloves, 45 Steel, 45 Tarydium Shards, 19 Arctic Suit, 19 Fine Leather, 19 Burning Embers, 20 Cosmic Dust||Level 15: 47 Gloves, 47 Steel, 47 Tarydium Shards, 21 Arctic Suit, 21 Fine Leather, 21 Burning Embers, 25 Cosmic Dust||Level 16: 50 Gloves, 50 Steel, 50 Tarydium Shards, 30 Arctic Suit, 30 Fine Leather, 30 Burning Embers, 30 Cosmic Dust, 10 Universal Translator||Level 17: 50 Gloves, 50 Steel, 50 Tarydium Shards, 35 Arctic Suit, 35 Fine Leather, 35 Burning Embers, 35 Cosmic Dust, 20 Universal Translator||Level 18: 50 Gloves, 50 Steel, 50 Tarydium Shards, 40 Arctic Suit, 40 Fine Leather, 40 Burning Embers, 40 Cosmic Dust, 30 Universal Translator||Level 19: 50 Gloves, 50 Steel, 50 Tarydium Shards, 45 Arctic Suit, 45 Fine Leather, 45 Burning Embers, 45 Cosmic Dust, 40 Universal Translator||Level 20: 50 Gloves, 50 Steel, 50 Tarydium Shards, 50 Arctic Suit, 50 Fine Leather, 50 Burning Embers, 50 Cosmic Dust, 50 Universal Translator||You can have up to 3 combos at a time. Combos are refundable by using the Refund button while the Combos list is open.||Cost(per level): 2, 4, 6, 8, 10..."
	MaxLevel=20
	StartingCost=2
	CostAddPerLevel=2
	BaseMultiplier=1.0000
	MultiplierAddPerStep=1.000000
	MultiplierStep=3.00000
	BaseLifespan=120.000
	LifespanAddPerStep=5.0000
	LifespanStep=1.00000
	Dispellable=True
	All=True
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG208AD.AbilityMaterialSteel',Class'DEKRPG208AD.AbilityMaterialGloves',Class'DEKRPG208AD.AbilityMaterialTarydiumShards'),RequiredMaterialLevels=(2,2,2))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG208AD.AbilityMaterialSteel',Class'DEKRPG208AD.AbilityMaterialGloves',Class'DEKRPG208AD.AbilityMaterialTarydiumShards'),RequiredMaterialLevels=(6,6,6))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG208AD.AbilityMaterialSteel',Class'DEKRPG208AD.AbilityMaterialGloves',Class'DEKRPG208AD.AbilityMaterialTarydiumShards'),RequiredMaterialLevels=(10,10,10))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG208AD.AbilityMaterialSteel',Class'DEKRPG208AD.AbilityMaterialGloves',Class'DEKRPG208AD.AbilityMaterialTarydiumShards',Class'DEKRPG208AD.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(15,15,15,5))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG208AD.AbilityMaterialSteel',Class'DEKRPG208AD.AbilityMaterialGloves',Class'DEKRPG208AD.AbilityMaterialTarydiumShards',Class'DEKRPG208AD.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(20,20,20,5))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG208AD.AbilityMaterialSteel',Class'DEKRPG208AD.AbilityMaterialGloves',Class'DEKRPG208AD.AbilityMaterialTarydiumShards',Class'DEKRPG208AD.AbilityMaterialArcticSuit',Class'DEKRPG208AD.AbilityMaterialLeather'),RequiredMaterialLevels=(25,25,25,5,5))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG208AD.AbilityMaterialSteel',Class'DEKRPG208AD.AbilityMaterialGloves',Class'DEKRPG208AD.AbilityMaterialTarydiumShards',Class'DEKRPG208AD.AbilityMaterialArcticSuit',Class'DEKRPG208AD.AbilityMaterialLeather',Class'DEKRPG208AD.AbilityMaterialEmbers'),RequiredMaterialLevels=(27,27,27,5,5,5))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG208AD.AbilityMaterialSteel',Class'DEKRPG208AD.AbilityMaterialGloves',Class'DEKRPG208AD.AbilityMaterialTarydiumShards',Class'DEKRPG208AD.AbilityMaterialArcticSuit',Class'DEKRPG208AD.AbilityMaterialLeather',Class'DEKRPG208AD.AbilityMaterialEmbers'),RequiredMaterialLevels=(30,30,30,7,7,7))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG208AD.AbilityMaterialSteel',Class'DEKRPG208AD.AbilityMaterialGloves',Class'DEKRPG208AD.AbilityMaterialTarydiumShards',Class'DEKRPG208AD.AbilityMaterialArcticSuit',Class'DEKRPG208AD.AbilityMaterialLeather',Class'DEKRPG208AD.AbilityMaterialEmbers'),RequiredMaterialLevels=(33,33,33,9,9,9))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG208AD.AbilityMaterialSteel',Class'DEKRPG208AD.AbilityMaterialGloves',Class'DEKRPG208AD.AbilityMaterialTarydiumShards',Class'DEKRPG208AD.AbilityMaterialArcticSuit',Class'DEKRPG208AD.AbilityMaterialLeather',Class'DEKRPG208AD.AbilityMaterialEmbers'),RequiredMaterialLevels=(36,36,36,11,11,11))
	Materials(10)=(RequiredMaterials=(Class'DEKRPG208AD.AbilityMaterialSteel',Class'DEKRPG208AD.AbilityMaterialGloves',Class'DEKRPG208AD.AbilityMaterialTarydiumShards',Class'DEKRPG208AD.AbilityMaterialArcticSuit',Class'DEKRPG208AD.AbilityMaterialLeather',Class'DEKRPG208AD.AbilityMaterialEmbers',Class'DEKRPG208AD.AbilityMaterialDust'),RequiredMaterialLevels=(39,39,39,13,13,13,5))
	Materials(11)=(RequiredMaterials=(Class'DEKRPG208AD.AbilityMaterialSteel',Class'DEKRPG208AD.AbilityMaterialGloves',Class'DEKRPG208AD.AbilityMaterialTarydiumShards',Class'DEKRPG208AD.AbilityMaterialArcticSuit',Class'DEKRPG208AD.AbilityMaterialLeather',Class'DEKRPG208AD.AbilityMaterialEmbers',Class'DEKRPG208AD.AbilityMaterialDust'),RequiredMaterialLevels=(41,41,41,15,15,15,10))
	Materials(12)=(RequiredMaterials=(Class'DEKRPG208AD.AbilityMaterialSteel',Class'DEKRPG208AD.AbilityMaterialGloves',Class'DEKRPG208AD.AbilityMaterialTarydiumShards',Class'DEKRPG208AD.AbilityMaterialArcticSuit',Class'DEKRPG208AD.AbilityMaterialLeather',Class'DEKRPG208AD.AbilityMaterialEmbers',Class'DEKRPG208AD.AbilityMaterialDust'),RequiredMaterialLevels=(43,43,43,17,17,17,15))
	Materials(13)=(RequiredMaterials=(Class'DEKRPG208AD.AbilityMaterialSteel',Class'DEKRPG208AD.AbilityMaterialGloves',Class'DEKRPG208AD.AbilityMaterialTarydiumShards',Class'DEKRPG208AD.AbilityMaterialArcticSuit',Class'DEKRPG208AD.AbilityMaterialLeather',Class'DEKRPG208AD.AbilityMaterialEmbers',Class'DEKRPG208AD.AbilityMaterialDust'),RequiredMaterialLevels=(45,45,45,19,19,19,20))
	Materials(14)=(RequiredMaterials=(Class'DEKRPG208AD.AbilityMaterialSteel',Class'DEKRPG208AD.AbilityMaterialGloves',Class'DEKRPG208AD.AbilityMaterialTarydiumShards',Class'DEKRPG208AD.AbilityMaterialArcticSuit',Class'DEKRPG208AD.AbilityMaterialLeather',Class'DEKRPG208AD.AbilityMaterialEmbers',Class'DEKRPG208AD.AbilityMaterialDust'),RequiredMaterialLevels=(47,47,47,21,21,21,25))
	Materials(15)=(RequiredMaterials=(Class'DEKRPG208AD.AbilityMaterialSteel',Class'DEKRPG208AD.AbilityMaterialGloves',Class'DEKRPG208AD.AbilityMaterialTarydiumShards',Class'DEKRPG208AD.AbilityMaterialArcticSuit',Class'DEKRPG208AD.AbilityMaterialLeather',Class'DEKRPG208AD.AbilityMaterialEmbers',Class'DEKRPG208AD.AbilityMaterialDust',Class'DEKRPG208AD.AbilityMaterialTranslator'),RequiredMaterialLevels=(50,50,50,30,30,30,30,10))
	Materials(16)=(RequiredMaterials=(Class'DEKRPG208AD.AbilityMaterialSteel',Class'DEKRPG208AD.AbilityMaterialGloves',Class'DEKRPG208AD.AbilityMaterialTarydiumShards',Class'DEKRPG208AD.AbilityMaterialArcticSuit',Class'DEKRPG208AD.AbilityMaterialLeather',Class'DEKRPG208AD.AbilityMaterialEmbers',Class'DEKRPG208AD.AbilityMaterialDust',Class'DEKRPG208AD.AbilityMaterialTranslator'),RequiredMaterialLevels=(50,50,50,35,35,35,35,20))
	Materials(17)=(RequiredMaterials=(Class'DEKRPG208AD.AbilityMaterialSteel',Class'DEKRPG208AD.AbilityMaterialGloves',Class'DEKRPG208AD.AbilityMaterialTarydiumShards',Class'DEKRPG208AD.AbilityMaterialArcticSuit',Class'DEKRPG208AD.AbilityMaterialLeather',Class'DEKRPG208AD.AbilityMaterialEmbers',Class'DEKRPG208AD.AbilityMaterialDust',Class'DEKRPG208AD.AbilityMaterialTranslator'),RequiredMaterialLevels=(50,50,50,40,40,40,40,30))
	Materials(18)=(RequiredMaterials=(Class'DEKRPG208AD.AbilityMaterialSteel',Class'DEKRPG208AD.AbilityMaterialGloves',Class'DEKRPG208AD.AbilityMaterialTarydiumShards',Class'DEKRPG208AD.AbilityMaterialArcticSuit',Class'DEKRPG208AD.AbilityMaterialLeather',Class'DEKRPG208AD.AbilityMaterialEmbers',Class'DEKRPG208AD.AbilityMaterialDust',Class'DEKRPG208AD.AbilityMaterialTranslator'),RequiredMaterialLevels=(50,50,50,45,45,45,45,40))
	Materials(19)=(RequiredMaterials=(Class'DEKRPG208AD.AbilityMaterialSteel',Class'DEKRPG208AD.AbilityMaterialGloves',Class'DEKRPG208AD.AbilityMaterialTarydiumShards',Class'DEKRPG208AD.AbilityMaterialArcticSuit',Class'DEKRPG208AD.AbilityMaterialLeather',Class'DEKRPG208AD.AbilityMaterialEmbers',Class'DEKRPG208AD.AbilityMaterialDust',Class'DEKRPG208AD.AbilityMaterialTranslator'),RequiredMaterialLevels=(50,50,50,50,50,50,50,50))
}