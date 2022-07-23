class AbilityComboBuffAttack extends AbilityComboBuff
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
	AbilityName="Buff: Attack"
	Description="The caster and all allies receive 2.5% damage bonus per level for 25 seconds. If a similar buff is applied, the effect is stacked. Allies with increased attack have a green berserk ring.||Non-AMs can only have one type of Ailment at a time, AMs can have two.||REQUIRED MATERIALS (for non-AMs):|You need 5 times the ability level of Gloves and Steel you wish to purchase. Additionally:||Level 5: 10 Fine Leather, 10 Burning Embers||Level 6: 20 Fine Leather, 20 Burning Embers||Level 7: 30 Fine Leather, 30 Burning Embers||Level 8: 40 Fine Leather, 40 Burning Embers, 10 Pumice||Level 9: 45 Fine Leather, 45 Burning Embers, 25 Pumice||Level 10: 50 Fine Leather, 50 Burning Embers, 50 Pumice||Cost(per level): 3, 6, 9...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
	BaseMultiplier=0.025000
	MultiplierAddPerStep=25.000000
	MultiplierStep=1.00000
	BaseLifespan=25.000
	Dispellable=True
	All=True
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialGloves'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialGloves'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialGloves'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialGloves'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialGloves',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialEmbers'),RequiredMaterialLevels=(25,25,10,10))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialGloves',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialEmbers'),RequiredMaterialLevels=(30,30,20,20))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialGloves',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialEmbers'),RequiredMaterialLevels=(35,35,30,30))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialGloves',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialPumice'),RequiredMaterialLevels=(40,40,40,40,10))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialGloves',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialPumice'),RequiredMaterialLevels=(45,45,45,45,25))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialGloves',Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialPumice'),RequiredMaterialLevels=(50,50,50,50,50))
}