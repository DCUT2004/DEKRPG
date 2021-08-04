class AbilityComboAilmentPoison extends AbilityCombo
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityPoisonInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityPoisonInv(Other.FindInventoryType(class'ComboAbilityPoisonInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityPoisonInv');
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
    ExcludingAbilities(0)=Class'DEKRPG208AF.AbilityComboAilmentBlind'
	ExcludingAbilities(1)=Class'DEKRPG208AF.AbilityComboAilmentCurse'
	ExcludingAbilities(2)=Class'DEKRPG208AF.AbilityComboAilmentDefense'
	ExcludingAbilities(3)=Class'DEKRPG208AF.AbilityComboAilmentFreeze'
	ExcludingAbilities(4)=Class'DEKRPG208AF.AbilityComboAilmentJinx'
	ExcludingAbilities(5)=Class'DEKRPG208AF.AbilityComboAilmentAttack'
	AbilityName="Ailment: Poison"
	Description="All targets receive Poison for 25 seconds. Each level increases the Poison damage. If a similar ailment is applied, the effect is stacked.||You can only have one type of Ailment combo at a time.||You must be level 90 to purchase this.||REQUIRED MATERIALS:|You need 5 times the ability level of Combat Boots and Steel you wish to purchase. Additionally:||Level 5: 10 Honeysuckle Vine, 10 Burning Embers||Level 6: 20 Honeysuckle Vine, 20 Burning Embers||Level 7: 30 Honeysuckle Vine, 30 Burning Embers||Level 8: 40 Honeysuckle Vine, 40 Burning Embers, 10 Cosmic Dust||Level 9: 45 Honeysuckle Vine, 45 Burning Embers, 25 Cosmic Dust||Level 10: 50 Honeysuckle Vine, 50 Burning Embers, 50 Cosmic Dust||Cost(per level): 5, 10, 15, 20...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
	MaxLevel=10
	StartingCost=5
	CostAddPerLevel=5
	BaseMultiplier=1.00000
	MultiplierAddPerStep=25.000000
	MultiplierStep=1.00000
	BaseLifespan=25.000
	Dispellable=True
	All=True
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialSteel',Class'DEKRPG208AF.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialSteel',Class'DEKRPG208AF.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialSteel',Class'DEKRPG208AF.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialSteel',Class'DEKRPG208AF.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialSteel',Class'DEKRPG208AF.AbilityMaterialCombatBoots',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialEmbers'),RequiredMaterialLevels=(25,25,10,10))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialSteel',Class'DEKRPG208AF.AbilityMaterialCombatBoots',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialEmbers'),RequiredMaterialLevels=(30,30,20,20))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialSteel',Class'DEKRPG208AF.AbilityMaterialCombatBoots',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialEmbers'),RequiredMaterialLevels=(35,35,30,30))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialSteel',Class'DEKRPG208AF.AbilityMaterialCombatBoots',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialEmbers',Class'DEKRPG208AF.AbilityMaterialDust'),RequiredMaterialLevels=(40,40,40,40,10))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialSteel',Class'DEKRPG208AF.AbilityMaterialCombatBoots',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialEmbers',Class'DEKRPG208AF.AbilityMaterialDust'),RequiredMaterialLevels=(45,45,45,45,25))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialSteel',Class'DEKRPG208AF.AbilityMaterialCombatBoots',Class'DEKRPG208AF.AbilityMaterialHoneysuckleVine',Class'DEKRPG208AF.AbilityMaterialEmbers',Class'DEKRPG208AF.AbilityMaterialDust'),RequiredMaterialLevels=(50,50,50,50,50))
}