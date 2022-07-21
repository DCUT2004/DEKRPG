class AbilityComboBuffShieldHeal extends AbilityComboBuff
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityShieldHealInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityShieldHealInv(Other.FindInventoryType(class'ComboAbilityShieldHealInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityShieldHealInv');
			Inv.GiveTo(Other);
		}
		if (Inv != None)
		{
			Inv.EffectMultiplier = default.MultiplierStep*AbilityLevel;
			Inv.bAll = default.All;
			Inv.bSingle = default.Single;
			Inv.ComboLifespan = default.BaseLifespan;
		}
	}
}

defaultproperties
{
	AbilityName="Buff: Shield Heal"
	MaxLevel=10
	Description="Caster and all allies receive 40 shield per level. Healing over the max shield is added as temporary max shield.||You can only have one type of Buff combo at a time.||You must be level 90 to purchase this.||REQUIRED MATERIALS:|You need 5 times the ability level of Lumber and Steel you wish to purchase. Additionally:||Level 5: 10 Fine Leather, 10 Plated Armor||Level 6: 20 Fine Leather, 20 Plated Armor||Level 7: 30 Fine Leather, 30 Plated Armor||Level 8: 40 Fine Leather, 40 Plated Armor, 10 Nanite Fragment||Level 9: 45 Fine Leather, 45 Plated Armor, 25 Nanite Fragment||Level 10: 50 Fine Leather, 50 Plated Armor, 50 Nanite Fragment||Cost(per level): 5, 10, 15, 20...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
	StartingCost=5
	CostAddPerLevel=5
	BaseMultiplier=25.0000
	MultiplierStep=40.00000
	BaseLifespan=25.000
	Dispellable=True
	All=True
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialLumber'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialLumber'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialLumber'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialLumber'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor'),RequiredMaterialLevels=(25,25,10,10))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor'),RequiredMaterialLevels=(30,30,20,20))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor'),RequiredMaterialLevels=(35,35,30,30))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor',Class'DEKRPG999X.AbilityMaterialNanite'),RequiredMaterialLevels=(40,40,40,40,10))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor',Class'DEKRPG999X.AbilityMaterialNanite'),RequiredMaterialLevels=(45,45,45,45,25))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor',Class'DEKRPG999X.AbilityMaterialNanite'),RequiredMaterialLevels=(50,50,50,50,50))
}