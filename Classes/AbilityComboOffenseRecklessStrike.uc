class AbilityComboOffenseRecklessStrike extends AbilityCombo
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityRecklessStrikeInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityRecklessStrikeInv(Other.FindInventoryType(class'ComboAbilityRecklessStrikeInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityRecklessStrikeInv');
			Inv.GiveTo(Other);
		}
		if (Inv != None)
		{
			Inv.ComboDamage = default.BaseMultiplier*AbilityLevel;
			Inv.ComboLifespan = default.BaseLifespan;
			Inv.EffectMultiplier = 1 + default.MultiplierStep*AbilityLevel;
			Inv.bAll = default.All;
			Inv.bSingle = default.Single;
		}
	}
}

defaultproperties
{
    ExcludingAbilities(0)=Class'DEKRPG208AE.AbilityComboOffensePurifyingStrike'
	ExcludingAbilities(1)=Class'DEKRPG208AE.AbilityComboOffenseHealingStrike'
	ExcludingAbilities(2)=Class'DEKRPG208AE.AbilityComboOffenseStab'
	ExcludingAbilities(3)=Class'DEKRPG208AE.AbilityComboOffenseStrike'
	AbilityName="Offense: Reckless Strike"
	Description="Deals 40 damage per level to all targets. The damage is affected by buffs and ailments. The caster receives -3% defense per level for 25 seconds. This cannot be cleansed.||You can only have one type of Offense combo at a time.||You must be level 90 to purchase this.||REQUIRED MATERIALS:|You need 5 times the ability level of Arctic Suit and Burning Embers you wish to purchase. Additionally:||Level 5: 10 Cosmic Dust, 10 Icicles||Level 6: 20 Cosmic Dust, 20 Icicles||Level 7: 30 Cosmic Dust, 30 Icicles||Level 8: 40 Cosmic Dust, 40 Icicles||Level 9: 45 Cosmic Dust, 45 Icicles||Level 10: 50 Cosmic Dust, 50 Icicles||Cost(per level): 5, 10, 15, 20...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
	MaxLevel=10
	StartingCost=5
	CostAddPerLevel=5
	BaseMultiplier=20.000000
	MultiplierStep=0.030000000
	BaseLifespan=25.00000
	All=True
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG208AE.AbilityMaterialArcticSuit',Class'DEKRPG208AE.AbilityMaterialEmbers'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG208AE.AbilityMaterialArcticSuit',Class'DEKRPG208AE.AbilityMaterialEmbers'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG208AE.AbilityMaterialArcticSuit',Class'DEKRPG208AE.AbilityMaterialEmbers'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG208AE.AbilityMaterialArcticSuit',Class'DEKRPG208AE.AbilityMaterialEmbers'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG208AE.AbilityMaterialArcticSuit',Class'DEKRPG208AE.AbilityMaterialEmbers',Class'DEKRPG208AE.AbilityMaterialDust',Class'DEKRPG208AE.AbilityMaterialIcicle'),RequiredMaterialLevels=(25,25,10,10))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG208AE.AbilityMaterialArcticSuit',Class'DEKRPG208AE.AbilityMaterialEmbers',Class'DEKRPG208AE.AbilityMaterialDust',Class'DEKRPG208AE.AbilityMaterialIcicle'),RequiredMaterialLevels=(30,30,20,20))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG208AE.AbilityMaterialArcticSuit',Class'DEKRPG208AE.AbilityMaterialEmbers',Class'DEKRPG208AE.AbilityMaterialDust',Class'DEKRPG208AE.AbilityMaterialIcicle'),RequiredMaterialLevels=(35,35,30,30))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG208AE.AbilityMaterialArcticSuit',Class'DEKRPG208AE.AbilityMaterialEmbers',Class'DEKRPG208AE.AbilityMaterialDust',Class'DEKRPG208AE.AbilityMaterialIcicle'),RequiredMaterialLevels=(40,40,40,40))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG208AE.AbilityMaterialArcticSuit',Class'DEKRPG208AE.AbilityMaterialEmbers',Class'DEKRPG208AE.AbilityMaterialDust',Class'DEKRPG208AE.AbilityMaterialIcicle'),RequiredMaterialLevels=(45,45,45,45))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG208AE.AbilityMaterialArcticSuit',Class'DEKRPG208AE.AbilityMaterialEmbers',Class'DEKRPG208AE.AbilityMaterialDust',Class'DEKRPG208AE.AbilityMaterialIcicle'),RequiredMaterialLevels=(50,50,50,50))
}