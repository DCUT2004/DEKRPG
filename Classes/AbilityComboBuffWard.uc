class AbilityComboBuffWard extends AbilityCombo
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
    ExcludingAbilities(0)=Class'DEKRPG209E.AbilityComboBuffAdrenBoost'
	ExcludingAbilities(1)=Class'DEKRPG209E.AbilityComboBuffAdrenHeal'
	ExcludingAbilities(2)=Class'DEKRPG209E.AbilityComboBuffAttack'
	ExcludingAbilities(3)=Class'DEKRPG209E.AbilityComboBuffCriticalHit'
	ExcludingAbilities(4)=Class'DEKRPG209E.AbilityComboBuffDefense'
	ExcludingAbilities(5)=Class'DEKRPG209E.AbilityComboBuffHeal'
	ExcludingAbilities(6)=Class'DEKRPG209E.AbilityComboBuffHPBoost'
	ExcludingAbilities(7)=Class'DEKRPG209E.AbilityComboBuffRegenerate'
	ExcludingAbilities(8)=Class'DEKRPG209E.AbilityComboBuffShieldBoost'
	ExcludingAbilities(9)=Class'DEKRPG209E.AbilityComboBuffShieldHeal'
	AbilityName="Buff: Ward"
	Description="The caster and all allies receive a 10% chance per level to resist any new ailments, including magic effects, for 25 seconds. If a similar buff is applied, the chance to ward the ailment is stacked. A sound will play if you have warded an Ailment.||You can only have one type of Buff combo at a time.||You must be level 90 to purchase this.||REQUIRED MATERIALS:|You need 5 times the ability level of Combat Boots and Gloves you wish to purchase. Additionally:||Level 5: 10 Fine Burning Embers, 10 Arctic Suit||Level 6: 20 Fine Burning Embers, 20 Arctic Suit||Level 7: 30 Fine Burning Embers, 30 Arctic Suit||Level 8: 40 Fine Burning Embers, 40 Arctic Suit, 10 Icicles||Level 9: 45 Fine Burning Embers, 45 Arctic Suit, 25 Icicles||Level 10: 50 Fine Burning Embers, 50 Arctic Suit, 50 Icicles||Cost(per level): 5, 10, 15, 20...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
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
	Materials(0)=(RequiredMaterials=(Class'DEKRPG209E.AbilityMaterialGloves',Class'DEKRPG209E.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG209E.AbilityMaterialGloves',Class'DEKRPG209E.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG209E.AbilityMaterialGloves',Class'DEKRPG209E.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG209E.AbilityMaterialGloves',Class'DEKRPG209E.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG209E.AbilityMaterialGloves',Class'DEKRPG209E.AbilityMaterialCombatBoots',Class'DEKRPG209E.AbilityMaterialEmbers',Class'DEKRPG209E.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(25,25,10,10))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG209E.AbilityMaterialGloves',Class'DEKRPG209E.AbilityMaterialCombatBoots',Class'DEKRPG209E.AbilityMaterialEmbers',Class'DEKRPG209E.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(30,30,20,20))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG209E.AbilityMaterialGloves',Class'DEKRPG209E.AbilityMaterialCombatBoots',Class'DEKRPG209E.AbilityMaterialEmbers',Class'DEKRPG209E.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(35,35,30,30))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG209E.AbilityMaterialGloves',Class'DEKRPG209E.AbilityMaterialCombatBoots',Class'DEKRPG209E.AbilityMaterialEmbers',Class'DEKRPG209E.AbilityMaterialArcticSuit',Class'DEKRPG209E.AbilityMaterialIcicle'),RequiredMaterialLevels=(40,40,40,40,10))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG209E.AbilityMaterialGloves',Class'DEKRPG209E.AbilityMaterialCombatBoots',Class'DEKRPG209E.AbilityMaterialEmbers',Class'DEKRPG209E.AbilityMaterialArcticSuit',Class'DEKRPG209E.AbilityMaterialIcicle'),RequiredMaterialLevels=(45,45,45,45,25))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG209E.AbilityMaterialGloves',Class'DEKRPG209E.AbilityMaterialCombatBoots',Class'DEKRPG209E.AbilityMaterialEmbers',Class'DEKRPG209E.AbilityMaterialArcticSuit',Class'DEKRPG209E.AbilityMaterialIcicle'),RequiredMaterialLevels=(50,50,50,50,50))
}