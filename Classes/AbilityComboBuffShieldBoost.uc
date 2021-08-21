class AbilityComboBuffShieldBoost extends AbilityCombo
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityShieldBoostInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityShieldBoostInv(Other.FindInventoryType(class'ComboAbilityShieldBoostInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityShieldBoostInv');
			Inv.GiveTo(Other);
		}
		if (Inv != None)
		{
			Inv.EffectMultiplier = default.MultiplierStep*AbilityLevel;
			Inv.bAll = default.All;
			Inv.bSingle = default.Single;
		}
	}
}

defaultproperties
{
    ExcludingAbilities(0)=Class'DEKRPG208AJ.AbilityComboBuffAdrenBoost'
	ExcludingAbilities(1)=Class'DEKRPG208AJ.AbilityComboBuffAdrenHeal'
	ExcludingAbilities(2)=Class'DEKRPG208AJ.AbilityComboBuffAttack'
	ExcludingAbilities(3)=Class'DEKRPG208AJ.AbilityComboBuffCriticalHit'
	ExcludingAbilities(4)=Class'DEKRPG208AJ.AbilityComboBuffDefense'
	ExcludingAbilities(5)=Class'DEKRPG208AJ.AbilityComboBuffHeal'
	ExcludingAbilities(6)=Class'DEKRPG208AJ.AbilityComboBuffHPBoost'
	ExcludingAbilities(7)=Class'DEKRPG208AJ.AbilityComboBuffRegenerate'
	ExcludingAbilities(8)=Class'DEKRPG208AJ.AbilityComboBuffWard'
	ExcludingAbilities(9)=Class'DEKRPG208AJ.AbilityComboBuffShieldHeal'
	AbilityName="Buff: Shield Boost"
	MaxLevel=10
	Description="Permanently boosts the max shield of the caster and all allies.||Each level boosts the max shield by 2 per level.||You can only have one type of Buff combo at a time.||You must be level 90 to purchase this.||REQUIRED MATERIALS:|You need 5 times the ability level of Lumber and Steel you wish to purchase. Additionally:||Level 5: 10 Arctic Suit, 10 Plated Armor||Level 6: 20 Arctic Suit, 20 Plated Armor||Level 7: 30 Arctic Suit, 30 Plated Armor||Level 8: 40 Arctic Suit, 40 Plated Armor, 10 Nanite Fragment||Level 9: 45 Arctic Suit, 45 Plated Armor, 25 Nanite Fragment||Level 10: 50 Arctic Suit, 50 Plated Armor, 50 Nanite Fragment||Cost(per level): 5, 10, 15, 20...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
	StartingCost=5
	CostAddPerLevel=5
	BaseMultiplier=25.0000
	MultiplierAddPerStep=1.000000
	MultiplierStep=2.00000
	BaseLifespan=10.000
	LifespanAddPerStep=1.0000
	LifespanStep=1.00000
	Dispellable=True
	All=True
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialSteel',Class'DEKRPG208AJ.AbilityMaterialLumber'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialSteel',Class'DEKRPG208AJ.AbilityMaterialLumber'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialSteel',Class'DEKRPG208AJ.AbilityMaterialLumber'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialSteel',Class'DEKRPG208AJ.AbilityMaterialLumber'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialSteel',Class'DEKRPG208AJ.AbilityMaterialLumber',Class'DEKRPG208AJ.AbilityMaterialArcticSuit',Class'DEKRPG208AJ.AbilityMaterialPlatedArmor'),RequiredMaterialLevels=(25,25,10,10))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialSteel',Class'DEKRPG208AJ.AbilityMaterialLumber',Class'DEKRPG208AJ.AbilityMaterialArcticSuit',Class'DEKRPG208AJ.AbilityMaterialPlatedArmor'),RequiredMaterialLevels=(30,30,20,20))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialSteel',Class'DEKRPG208AJ.AbilityMaterialLumber',Class'DEKRPG208AJ.AbilityMaterialArcticSuit',Class'DEKRPG208AJ.AbilityMaterialPlatedArmor'),RequiredMaterialLevels=(35,35,30,30))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialSteel',Class'DEKRPG208AJ.AbilityMaterialLumber',Class'DEKRPG208AJ.AbilityMaterialArcticSuit',Class'DEKRPG208AJ.AbilityMaterialPlatedArmor',Class'DEKRPG208AJ.AbilityMaterialNanite'),RequiredMaterialLevels=(40,40,40,40,10))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialSteel',Class'DEKRPG208AJ.AbilityMaterialLumber',Class'DEKRPG208AJ.AbilityMaterialArcticSuit',Class'DEKRPG208AJ.AbilityMaterialPlatedArmor',Class'DEKRPG208AJ.AbilityMaterialNanite'),RequiredMaterialLevels=(45,45,45,45,25))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG208AJ.AbilityMaterialSteel',Class'DEKRPG208AJ.AbilityMaterialLumber',Class'DEKRPG208AJ.AbilityMaterialArcticSuit',Class'DEKRPG208AJ.AbilityMaterialPlatedArmor',Class'DEKRPG208AJ.AbilityMaterialNanite'),RequiredMaterialLevels=(50,50,50,50,50))
}