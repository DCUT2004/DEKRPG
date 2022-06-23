class AbilityComboSpecialVoidedCubes extends AbilityCombo
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityVoidedCubesInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityVoidedCubesInv(Other.FindInventoryType(class'ComboAbilityVoidedCubesInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityVoidedCubesInv');
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
    ExcludingAbilities(0)=Class'DEKRPG209C.AbilityComboSpecialSwarm'
    ExcludingAbilities(1)=Class'DEKRPG209C.AbilityComboSpecialTeleStealth'
    ExcludingAbilities(2)=Class'DEKRPG209C.AbilityComboSpecialBeastsRevenge'
    ExcludingAbilities(3)=Class'DEKRPG209C.AbilityComboSpecialRavenRitual'
	AbilityName="Special: Voided Cubes"
	Description="Summons three Voided Cubes at random locations. Each Voided Cube kills a non-Boss enemy that comes into contact with it before disappearing. Each kill decreases the enemy team adrenaline by 3 per level.||You can only have one type of Special combo at a time.||You must be level 90 to purchase this.||REQUIRED MATERIALS:|You need 5 times the ability level of Star Chart you wish to purchase.||Cost(per level): 10, 20, 30, 40...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
	MaxLevel=10
	StartingCost=10
	CostAddPerLevel=10
	BaseMultiplier=3.00000
	MultiplierAddPerStep=25.000000
	MultiplierStep=1.00000
	BaseLifespan=25.000
	Dispellable=True
	All=True
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG209C.AbilityMaterialStarChart'),RequiredMaterialLevels=(5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG209C.AbilityMaterialStarChart'),RequiredMaterialLevels=(10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG209C.AbilityMaterialStarChart'),RequiredMaterialLevels=(15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG209C.AbilityMaterialStarChart'),RequiredMaterialLevels=(20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG209C.AbilityMaterialStarChart'),RequiredMaterialLevels=(25))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG209C.AbilityMaterialStarChart'),RequiredMaterialLevels=(30))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG209C.AbilityMaterialStarChart'),RequiredMaterialLevels=(35))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG209C.AbilityMaterialStarChart'),RequiredMaterialLevels=(40))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG209C.AbilityMaterialStarChart'),RequiredMaterialLevels=(45))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG209C.AbilityMaterialStarChart'),RequiredMaterialLevels=(50))
}