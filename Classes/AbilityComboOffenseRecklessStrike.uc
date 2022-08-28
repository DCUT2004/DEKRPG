class AbilityComboOffenseRecklessStrike extends AbilityComboOffense
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local StatusEffectInventory_Player StatusInv;
	
	if (Other == None)
		return;

	StatusInv = StatusEffectInventory_Player(Other.FindInventoryType(Class'StatusEffectInventory_Player'));
	
	if (StatusInv == None)
		return;

	StatusInv.AddAttackCombo(Class'OffenseCombo_RecklessStrike', default.NumTargets, default.NumHits, AbilityLevel*default.DamagePerHit, Class'DamTypeCombo', default.TimeBetweenHits);
}

defaultproperties
{
	AbilityName="Offense: Reckless Strike"
	Description="Deals 40 damage per level to all targets. The damage is affected by buffs and ailments. The caster receives -30% defense for 25 seconds. This cannot be cleansed nor stacked.||You can only have one type of Offense combo at a time.||REQUIRED MATERIALS (for non-AMs):|You need 5 times the ability level of Arctic Suit and Burning Embers you wish to purchase. Additionally:||Level 5: 10 Cosmic Dust, 10 Icicles||Level 6: 20 Cosmic Dust, 20 Icicles||Level 7: 30 Cosmic Dust, 30 Icicles||Level 8: 40 Cosmic Dust, 40 Icicles||Level 9: 45 Cosmic Dust, 45 Icicles||Level 10: 50 Cosmic Dust, 50 Icicles||Cost(per level): 3, 6, 9...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
	BaseMultiplier=20.000000
	MultiplierStep=0.030000000
	BaseLifespan=25.00000
	All=True
	Single=False
	NumTargets=0
	NumHits=1
	DamagePerHit=40
	TimeBetweenHits=1
	Materials(0)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialArcticSuit',Class'DEKRPG999X.AbilityMaterialEmbers'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialArcticSuit',Class'DEKRPG999X.AbilityMaterialEmbers'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialArcticSuit',Class'DEKRPG999X.AbilityMaterialEmbers'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialArcticSuit',Class'DEKRPG999X.AbilityMaterialEmbers'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialArcticSuit',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialDust',Class'DEKRPG999X.AbilityMaterialIcicle'),RequiredMaterialLevels=(25,25,10,10))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialArcticSuit',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialDust',Class'DEKRPG999X.AbilityMaterialIcicle'),RequiredMaterialLevels=(30,30,20,20))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialArcticSuit',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialDust',Class'DEKRPG999X.AbilityMaterialIcicle'),RequiredMaterialLevels=(35,35,30,30))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialArcticSuit',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialDust',Class'DEKRPG999X.AbilityMaterialIcicle'),RequiredMaterialLevels=(40,40,40,40))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialArcticSuit',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialDust',Class'DEKRPG999X.AbilityMaterialIcicle'),RequiredMaterialLevels=(45,45,45,45))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialArcticSuit',Class'DEKRPG999X.AbilityMaterialEmbers',Class'DEKRPG999X.AbilityMaterialDust',Class'DEKRPG999X.AbilityMaterialIcicle'),RequiredMaterialLevels=(50,50,50,50))
}