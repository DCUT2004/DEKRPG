class AbilityComboAilmentJinx extends AbilityCombo
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilityJinxInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilityJinxInv(Other.FindInventoryType(class'ComboAbilityJinxInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilityJinxInv');
			Inv.GiveTo(Other);
		}
		if (Inv != None)
		{
			Inv.EffectMultiplier = abs((default.BaseMultiplier*AbilityLevel) - 1);
			Inv.bAll = default.All;
			Inv.bSingle = default.Single;
			Inv.ComboLifespan = default.BaseLifespan;
		}
	}
}

defaultproperties
{
    ExcludingAbilities(0)=Class'DEKRPG209B.AbilityComboAilmentBlind'
	ExcludingAbilities(1)=Class'DEKRPG209B.AbilityComboAilmentCurse'
	ExcludingAbilities(2)=Class'DEKRPG209B.AbilityComboAilmentDefense'
	ExcludingAbilities(3)=Class'DEKRPG209B.AbilityComboAilmentFreeze'
	ExcludingAbilities(4)=Class'DEKRPG209B.AbilityComboAilmentAttack'
	ExcludingAbilities(5)=Class'DEKRPG209B.AbilityComboAilmentPoison'
	AbilityName="Ailment: Jinx"
	Description="A single target receives Jinx. While jinxed, the target strikes down any of its projectiles as well as its allies' projectiles. If the target dies, the curse moves to a new target, and will continue this process for 25 seconds. Each level increases the speed at which projectiles are shot down. This ailment can not be stacked. Jinxed targets have a pink-purple glow.||You can only have one type of Ailment combo at a time.||You must be level 90 to purchase this.||REQUIRED MATERIALS:|You need 5 times the ability level of Gloves and Steel you wish to purchase. Additionally:||Level 5: 10 Honeysuckle Vine, 10 Arctic Suit||Level 6: 20 Honeysuckle Vine, 20 Arctic Suit||Level 7: 30 Honeysuckle Vine, 30 Arctic Suit||Level 8: 40 Honeysuckle Vine, 40 Arctic Suit, 10 Nanite Fragments||Level 9: 45 Honeysuckle Vine, 45 Arctic Suit, 25 Nanite Fragments||Level 10: 50 Honeysuckle Vine, 50 Arctic Suit, 50 Nanite Fragments||Cost(per level): 5, 10, 15, 20...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
	MaxLevel=10
	StartingCost=5
	CostAddPerLevel=5
	BaseMultiplier=0.0500000
	MultiplierAddPerStep=25.000000
	MultiplierStep=1.00000
	BaseLifespan=25.000
	Dispellable=True
	All=False
	Single=True
	Materials(0)=(RequiredMaterials=(Class'DEKRPG209B.AbilityMaterialSteel',Class'DEKRPG209B.AbilityMaterialGloves'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG209B.AbilityMaterialSteel',Class'DEKRPG209B.AbilityMaterialGloves'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG209B.AbilityMaterialSteel',Class'DEKRPG209B.AbilityMaterialGloves'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG209B.AbilityMaterialSteel',Class'DEKRPG209B.AbilityMaterialGloves'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG209B.AbilityMaterialSteel',Class'DEKRPG209B.AbilityMaterialGloves',Class'DEKRPG209B.AbilityMaterialHoneysuckleVine',Class'DEKRPG209B.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(25,25,10,10))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG209B.AbilityMaterialSteel',Class'DEKRPG209B.AbilityMaterialGloves',Class'DEKRPG209B.AbilityMaterialHoneysuckleVine',Class'DEKRPG209B.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(30,30,20,20))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG209B.AbilityMaterialSteel',Class'DEKRPG209B.AbilityMaterialGloves',Class'DEKRPG209B.AbilityMaterialHoneysuckleVine',Class'DEKRPG209B.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(35,35,30,30))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG209B.AbilityMaterialSteel',Class'DEKRPG209B.AbilityMaterialGloves',Class'DEKRPG209B.AbilityMaterialHoneysuckleVine',Class'DEKRPG209B.AbilityMaterialArcticSuit',Class'DEKRPG209B.AbilityMaterialNanite'),RequiredMaterialLevels=(40,40,40,40,10))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG209B.AbilityMaterialSteel',Class'DEKRPG209B.AbilityMaterialGloves',Class'DEKRPG209B.AbilityMaterialHoneysuckleVine',Class'DEKRPG209B.AbilityMaterialArcticSuit',Class'DEKRPG209B.AbilityMaterialNanite'),RequiredMaterialLevels=(45,45,45,45,25))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG209B.AbilityMaterialSteel',Class'DEKRPG209B.AbilityMaterialGloves',Class'DEKRPG209B.AbilityMaterialHoneysuckleVine',Class'DEKRPG209B.AbilityMaterialArcticSuit',Class'DEKRPG209B.AbilityMaterialNanite'),RequiredMaterialLevels=(50,50,50,50,50))
}