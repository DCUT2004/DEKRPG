class AbilityComboSpecialBeastsRevenge extends AbilityComboSpecial
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityBeastsRevengeInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityBeastsRevengeInv(Other.FindInventoryType(class'ComboAbilityBeastsRevengeInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityBeastsRevengeInv');
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
	AbilityName="Special: Beast's Revenge"
	Description="The caster receives +15% defense for 20 seconds. For 20 seconds, the caster accumulates energy equivalent to 10% of the damage received per level. After 20 seconds, the caster deals damage equivalent to the accumulated energy to all enemies. Self-damage does not apply to the accumulated energy.||You can only have one type of Special combo at a time.||REQUIRED MATERIALS:|You need 5 times the ability level of Uranium Pellets you wish to purchase.||Cost(per level): 10, 20, 30, 40...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
	MaxLevel=10
	StartingCost=10
	CostAddPerLevel=10
	BaseMultiplier=0.100000
	MultiplierAddPerStep=25.000000
	MultiplierStep=1.00000
	BaseLifespan=20.000
	Dispellable=True
	All=True
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialUranium'),RequiredMaterialLevels=(5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialUranium'),RequiredMaterialLevels=(10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialUranium'),RequiredMaterialLevels=(15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialUranium'),RequiredMaterialLevels=(20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialUranium'),RequiredMaterialLevels=(25))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialUranium'),RequiredMaterialLevels=(30))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialUranium'),RequiredMaterialLevels=(35))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialUranium'),RequiredMaterialLevels=(40))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialUranium'),RequiredMaterialLevels=(45))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialUranium'),RequiredMaterialLevels=(50))
}