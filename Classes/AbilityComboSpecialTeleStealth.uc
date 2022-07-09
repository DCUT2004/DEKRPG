class AbilityComboSpecialTeleStealth extends AbilityCombo
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityTeleStealthInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityTeleStealthInv(Other.FindInventoryType(class'ComboAbilityTeleStealthInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityTeleStealthInv');
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
    ExcludingAbilities(0)=Class'DEKRPG209F.AbilityComboSpecialVoidedCubes'
    ExcludingAbilities(1)=Class'DEKRPG209F.AbilityComboSpecialSwarm'
    ExcludingAbilities(2)=Class'DEKRPG209F.AbilityComboSpecialBeastsRevenge'
    ExcludingAbilities(3)=Class'DEKRPG209F.AbilityComboSpecialRavenRitual'
	AbilityName="Special: Tele-Stealth"
	Description="Teleports the caster to a random location. For 20 seconds, the caster is invisible to monsters and is immune to new ailments. While the caster is invisible, the caster accumulates energy equivalent to 10% of the damage dealt to enemies per level. When the caster becomes visible, the caster deals damage equivalent to the accumulated energy to a single target.||You can only have one type of Special combo at a time.||You must be level 90 to purchase this.||REQUIRED MATERIALS:|You need 5 times the ability level of Universal Translator you wish to purchase.||Cost(per level): 10, 20, 30, 40...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
	MaxLevel=10
	StartingCost=10
	CostAddPerLevel=10
	BaseMultiplier=0.10000
	MultiplierAddPerStep=25.000000
	MultiplierStep=1.00000
	BaseLifespan=20.000
	Dispellable=True
	All=False
	Single=True
	Materials(0)=(RequiredMaterials=(Class'DEKRPG209F.AbilityMaterialTranslator'),RequiredMaterialLevels=(5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG209F.AbilityMaterialTranslator'),RequiredMaterialLevels=(10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG209F.AbilityMaterialTranslator'),RequiredMaterialLevels=(15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG209F.AbilityMaterialTranslator'),RequiredMaterialLevels=(20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG209F.AbilityMaterialTranslator'),RequiredMaterialLevels=(25))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG209F.AbilityMaterialTranslator'),RequiredMaterialLevels=(30))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG209F.AbilityMaterialTranslator'),RequiredMaterialLevels=(35))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG209F.AbilityMaterialTranslator'),RequiredMaterialLevels=(40))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG209F.AbilityMaterialTranslator'),RequiredMaterialLevels=(45))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG209F.AbilityMaterialTranslator'),RequiredMaterialLevels=(50))
}