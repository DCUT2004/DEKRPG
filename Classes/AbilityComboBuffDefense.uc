class AbilityComboBuffDefense extends AbilityCombo
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityDefenseBuffInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityDefenseBuffInv(Other.FindInventoryType(class'ComboAbilityDefenseBuffInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityDefenseBuffInv');
			Inv.GiveTo(Other);
		}
		if (Inv != None)
		{
			Inv.EffectMultiplier = abs((default.BaseMultiplier*AbilityLevel) - 1);
			Inv.bAll = default.All;
			Inv.bSingle = default.Single;
			Inv.ComboLifespan = default.BaseLifespan;
		}
	}
}

defaultproperties
{
    ExcludingAbilities(0)=Class'DEKRPG999X.AbilityComboBuffAdrenBoost'
	ExcludingAbilities(1)=Class'DEKRPG999X.AbilityComboBuffAdrenHeal'
	ExcludingAbilities(2)=Class'DEKRPG999X.AbilityComboBuffAttack'
	ExcludingAbilities(3)=Class'DEKRPG999X.AbilityComboBuffCriticalHit'
	ExcludingAbilities(4)=Class'DEKRPG999X.AbilityComboBuffWard'
	ExcludingAbilities(5)=Class'DEKRPG999X.AbilityComboBuffHeal'
	ExcludingAbilities(6)=Class'DEKRPG999X.AbilityComboBuffHPBoost'
	ExcludingAbilities(7)=Class'DEKRPG999X.AbilityComboBuffRegenerate'
	ExcludingAbilities(8)=Class'DEKRPG999X.AbilityComboBuffShieldBoost'
	ExcludingAbilities(9)=Class'DEKRPG999X.AbilityComboBuffShieldHeal'
	AbilityName="Buff: Defense"
	Description="The caster and all allies receive 2.5% damage reduction per level for 25 seconds. If a similar buff is applied, the effect is stacked. Allies with increased defense have a green orb.||You can only have one type of Buff combo at a time.||You must be level 90 to purchase this.||REQUIRED MATERIALS:|You need 5 times the ability level of Combat Boots and Steel you wish to purchase. Additionally:||Level 5: 10 Fine Plated Armor, 10 Arctic Suit||Level 6: 20 Fine Plated Armor, 20 Arctic Suit||Level 7: 30 Fine Plated Armor, 30 Arctic Suit||Level 8: 40 Fine Plated Armor, 40 Arctic Suit, 10 Icicles||Level 9: 45 Fine Plated Armor, 45 Arctic Suit, 25 Icicles||Level 10: 50 Fine Plated Armor, 50 Arctic Suit, 50 Icicles||Cost(per level): 5, 10, 15, 20...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
	MaxLevel=10
	StartingCost=5
	CostAddPerLevel=5
	BaseMultiplier=0.025000
	MultiplierAddPerStep=25.000000
	MultiplierStep=1.00000
	BaseLifespan=25.000
	Dispellable=True
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