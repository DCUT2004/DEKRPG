class AbilityComboBuffAttack extends AbilityCombo
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityAttackBuffInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityAttackBuffInv(Other.FindInventoryType(class'ComboAbilityAttackBuffInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityAttackBuffInv');
			Inv.GiveTo(Other);
		}
		if (Inv != None)
		{
			Inv.EffectMultiplier = 1 + default.BaseMultiplier*AbilityLevel;
			Inv.bAll = default.All;
			Inv.bSingle = default.Single;
			Inv.ComboLifespan = default.BaseLifespan;
		}
	}
}

defaultproperties
{
    ExcludingAbilities(0)=Class'DEKRPG208AF.AbilityComboBuffAdrenBoost'
	ExcludingAbilities(1)=Class'DEKRPG208AF.AbilityComboBuffAdrenHeal'
	ExcludingAbilities(2)=Class'DEKRPG208AF.AbilityComboBuffWard'
	ExcludingAbilities(3)=Class'DEKRPG208AF.AbilityComboBuffCriticalHit'
	ExcludingAbilities(4)=Class'DEKRPG208AF.AbilityComboBuffDefense'
	ExcludingAbilities(5)=Class'DEKRPG208AF.AbilityComboBuffHeal'
	ExcludingAbilities(6)=Class'DEKRPG208AF.AbilityComboBuffHPBoost'
	ExcludingAbilities(7)=Class'DEKRPG208AF.AbilityComboBuffRegenerate'
	ExcludingAbilities(8)=Class'DEKRPG208AF.AbilityComboBuffShieldBoost'
	ExcludingAbilities(9)=Class'DEKRPG208AF.AbilityComboBuffShieldHeal'
	AbilityName="Buff: Attack"
	Description="The caster and all allies receive 2.5% damage bonus per level for 25 seconds. If a similar buff is applied, the effect is stacked. Allies with increased attack have a green berserk ring.||You can only have one type of Buff combo at a time.||You must be level 90 to purchase this.||REQUIRED MATERIALS:|You need 5 times the ability level of Gloves and Steel you wish to purchase. Additionally:||Level 5: 10 Fine Leather, 10 Burning Embers||Level 6: 20 Fine Leather, 20 Burning Embers||Level 7: 30 Fine Leather, 30 Burning Embers||Level 8: 40 Fine Leather, 40 Burning Embers, 10 Pumice||Level 9: 45 Fine Leather, 45 Burning Embers, 25 Pumice||Level 10: 50 Fine Leather, 50 Burning Embers, 50 Pumice||Cost(per level): 5, 10, 15, 20...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
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
	Materials(0)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialSteel',Class'DEKRPG208AF.AbilityMaterialGloves'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialSteel',Class'DEKRPG208AF.AbilityMaterialGloves'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialSteel',Class'DEKRPG208AF.AbilityMaterialGloves'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialSteel',Class'DEKRPG208AF.AbilityMaterialGloves'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialSteel',Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialLeather',Class'DEKRPG208AF.AbilityMaterialEmbers'),RequiredMaterialLevels=(25,25,10,10))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialSteel',Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialLeather',Class'DEKRPG208AF.AbilityMaterialEmbers'),RequiredMaterialLevels=(30,30,20,20))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialSteel',Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialLeather',Class'DEKRPG208AF.AbilityMaterialEmbers'),RequiredMaterialLevels=(35,35,30,30))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialSteel',Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialLeather',Class'DEKRPG208AF.AbilityMaterialEmbers',Class'DEKRPG208AF.AbilityMaterialPumice'),RequiredMaterialLevels=(40,40,40,40,10))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialSteel',Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialLeather',Class'DEKRPG208AF.AbilityMaterialEmbers',Class'DEKRPG208AF.AbilityMaterialPumice'),RequiredMaterialLevels=(45,45,45,45,25))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG208AF.AbilityMaterialSteel',Class'DEKRPG208AF.AbilityMaterialGloves',Class'DEKRPG208AF.AbilityMaterialLeather',Class'DEKRPG208AF.AbilityMaterialEmbers',Class'DEKRPG208AF.AbilityMaterialPumice'),RequiredMaterialLevels=(50,50,50,50,50))
}