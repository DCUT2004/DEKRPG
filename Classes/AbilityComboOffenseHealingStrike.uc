class AbilityComboOffenseHealingStrike extends AbilityCombo
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityHealingStrikeInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityHealingStrikeInv(Other.FindInventoryType(class'ComboAbilityHealingStrikeInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityHealingStrikeInv');
			Inv.GiveTo(Other);
		}
		if (Inv != None)
		{
			Inv.ComboDamage = default.BaseMultiplier*AbilityLevel;
			Inv.EffectMultiplier = default.MultiplierStep*AbilityLevel;
			Inv.bAll = default.All;
			Inv.bSingle = default.Single;
		}
	}
}

defaultproperties
{
    ExcludingAbilities(0)=Class'DEKRPG208AG.AbilityComboOffensePurifyingStrike'
	ExcludingAbilities(1)=Class'DEKRPG208AG.AbilityComboOffenseRecklessStrike'
	ExcludingAbilities(2)=Class'DEKRPG208AG.AbilityComboOffenseStab'
	ExcludingAbilities(3)=Class'DEKRPG208AG.AbilityComboOffenseStrike'
	AbilityName="Offense: Healing Strike"
	Description="Deals 20 damage per level to all targets. The caster and all allies heal for 2% of the damage dealt per level. The damage is affected by buffs and ailments.||You can only have one type of Offense combo at a time.||You must be level 90 to purchase this.||REQUIRED MATERIALS:|You need 5 times the ability level of Arctic Suit and Fine Leather you wish to purchase. Additionally:||Level 5: 10 Nanite Fragments, 10 Cosmic Dust||Level 6: 20 Nanite Fragments, 20 Cosmic Dust||Level 7: 30 Nanite Fragments, 30 Cosmic Dust||Level 8: 40 Nanite Fragments, 40 Cosmic Dust||Level 9: 45 Nanite Fragments, 45 Cosmic Dust||Level 10: 50 Nanite Fragments, 50 Cosmic Dust||Cost(per level): 5, 10, 15, 20...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
	MaxLevel=10
	StartingCost=5
	CostAddPerLevel=5
	BaseMultiplier=20.000000
	MultiplierStep=0.0200000
	All=True
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG208AG.AbilityMaterialLeather',Class'DEKRPG208AG.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG208AG.AbilityMaterialLeather',Class'DEKRPG208AG.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG208AG.AbilityMaterialLeather',Class'DEKRPG208AG.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG208AG.AbilityMaterialLeather',Class'DEKRPG208AG.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG208AG.AbilityMaterialLeather',Class'DEKRPG208AG.AbilityMaterialArcticSuit',Class'DEKRPG208AG.AbilityMaterialNanite',Class'DEKRPG208AG.AbilityMaterialDust'),RequiredMaterialLevels=(25,25,10,10))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG208AG.AbilityMaterialLeather',Class'DEKRPG208AG.AbilityMaterialArcticSuit',Class'DEKRPG208AG.AbilityMaterialNanite',Class'DEKRPG208AG.AbilityMaterialDust'),RequiredMaterialLevels=(30,30,20,20))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG208AG.AbilityMaterialLeather',Class'DEKRPG208AG.AbilityMaterialArcticSuit',Class'DEKRPG208AG.AbilityMaterialNanite',Class'DEKRPG208AG.AbilityMaterialDust'),RequiredMaterialLevels=(35,35,30,30))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG208AG.AbilityMaterialLeather',Class'DEKRPG208AG.AbilityMaterialArcticSuit',Class'DEKRPG208AG.AbilityMaterialNanite',Class'DEKRPG208AG.AbilityMaterialDust'),RequiredMaterialLevels=(40,40,40,40))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG208AG.AbilityMaterialLeather',Class'DEKRPG208AG.AbilityMaterialArcticSuit',Class'DEKRPG208AG.AbilityMaterialNanite',Class'DEKRPG208AG.AbilityMaterialDust'),RequiredMaterialLevels=(45,45,45,45))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG208AG.AbilityMaterialLeather',Class'DEKRPG208AG.AbilityMaterialArcticSuit',Class'DEKRPG208AG.AbilityMaterialNanite',Class'DEKRPG208AG.AbilityMaterialDust'),RequiredMaterialLevels=(50,50,50,50))
}