class AbilityComboSpecialRavenRitual extends AbilityComboSpecial
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityRavenRitualInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityRavenRitualInv(Other.FindInventoryType(class'ComboAbilityRavenRitualInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityRavenRitualInv');
			Inv.GiveTo(Other);
		}
		if (Inv != None)
		{
			Inv.ComboDamage = default.BaseMultiplier*AbilityLevel;
			Inv.bAll = default.All;
			Inv.bSingle = default.Single;
			Inv.ComboLifespan = default.BaseLifespan;
		}
	}
}

defaultproperties
{
	AbilityName="Special: Raven Ritual"
	Description="Heals the caster by 100 health. Healing over the max health is added as temporary max health, up to double the amount of the caster's original max health. For as long as the caster has boosted health, the caster deals 20 damage per level every 10 seconds to a single target. This effect ends when the caster's health drops below the normal max health amount.||You can only have one type of Special combo at a time.||REQUIRED MATERIALS:|You need 5 times the ability level of Moonlit Stone you wish to purchase.||Cost(per level): 10, 20, 30, 40...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
	MaxLevel=10
	StartingCost=10
	CostAddPerLevel=10
	BaseMultiplier=20.00000
	BaseLifespan=10.000		//Interval to deal damage
	Dispellable=True
	All=False
	Single=True
	Materials(0)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialMoonlitStone'),RequiredMaterialLevels=(5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialMoonlitStone'),RequiredMaterialLevels=(10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialMoonlitStone'),RequiredMaterialLevels=(15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialMoonlitStone'),RequiredMaterialLevels=(20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialMoonlitStone'),RequiredMaterialLevels=(25))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialMoonlitStone'),RequiredMaterialLevels=(30))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialMoonlitStone'),RequiredMaterialLevels=(35))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialMoonlitStone'),RequiredMaterialLevels=(40))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialMoonlitStone'),RequiredMaterialLevels=(45))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialMoonlitStone'),RequiredMaterialLevels=(50))
}