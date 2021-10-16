class AbilityComboSpecialBeastsRevenge extends AbilityCombo
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
    ExcludingAbilities(0)=Class'DEKRPG209B.AbilityComboSpecialVoidedCubes'
    ExcludingAbilities(1)=Class'DEKRPG209B.AbilityComboSpecialSwarm'
    ExcludingAbilities(2)=Class'DEKRPG209B.AbilityComboSpecialTeleStealth'
    ExcludingAbilities(3)=Class'DEKRPG209B.AbilityComboSpecialRavenRitual'
	AbilityName="Special: Beast's Revenge"
	Description="The caster receives +15% defense for 20 seconds. For 20 seconds, the caster accumulates energy equivalent to 3% of the damage received per level. After 20 seconds, the caster deals damage equivalent to the accumulated energy to all enemies. Self-damage does not apply to the accumulated energy.||You can only have one type of Special combo at a time.||You must be level 90 to purchase this.||REQUIRED MATERIALS:|You need 5 times the ability level of Uranium Pellets you wish to purchase.||Cost(per level): 10, 20, 30, 40...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
	MaxLevel=10
	StartingCost=10
	CostAddPerLevel=10
	BaseMultiplier=0.03000
	MultiplierAddPerStep=25.000000
	MultiplierStep=1.00000
	BaseLifespan=20.000
	Dispellable=True
	All=True
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG209B.AbilityMaterialUranium'),RequiredMaterialLevels=(5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG209B.AbilityMaterialUranium'),RequiredMaterialLevels=(10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG209B.AbilityMaterialUranium'),RequiredMaterialLevels=(15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG209B.AbilityMaterialUranium'),RequiredMaterialLevels=(20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG209B.AbilityMaterialUranium'),RequiredMaterialLevels=(25))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG209B.AbilityMaterialUranium'),RequiredMaterialLevels=(30))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG209B.AbilityMaterialUranium'),RequiredMaterialLevels=(35))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG209B.AbilityMaterialUranium'),RequiredMaterialLevels=(40))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG209B.AbilityMaterialUranium'),RequiredMaterialLevels=(45))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG209B.AbilityMaterialUranium'),RequiredMaterialLevels=(50))
}