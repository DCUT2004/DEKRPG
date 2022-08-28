class AbilityComboOffenseHealingStrike extends AbilityComboOffense
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

	StatusInv.AddAttackCombo(Class'OffenseCombo_HealingStrike', default.NumTargets, default.NumHits, AbilityLevel*default.DamagePerHit, Class'DamTypeCombo', default.TimeBetweenHits);
}

defaultproperties
{
	AbilityName="Offense: Healing Strike"
	Description="Deals 20 damage per level to all targets. The caster and all allies heal for 2% of the damage dealt per level. The damage is affected by buffs and ailments.||You can only have one type of Offense combo at a time.||REQUIRED MATERIALS (for non-AMs):|You need 5 times the ability level of Arctic Suit and Fine Leather you wish to purchase. Additionally:||Level 5: 10 Nanite Fragments, 10 Cosmic Dust||Level 6: 20 Nanite Fragments, 20 Cosmic Dust||Level 7: 30 Nanite Fragments, 30 Cosmic Dust||Level 8: 40 Nanite Fragments, 40 Cosmic Dust||Level 9: 45 Nanite Fragments, 45 Cosmic Dust||Level 10: 50 Nanite Fragments, 50 Cosmic Dust||Cost(per level): 3, 6, 9...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
	BaseMultiplier=20.000000
	MultiplierStep=0.0200000
	All=True
	Single=False
	NumTargets=0
	NumHits=1
	DamagePerHit=20
	TimeBetweenHits=1
	Materials(0)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialArcticSuit'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialArcticSuit',Class'DEKRPG999X.AbilityMaterialNanite',Class'DEKRPG999X.AbilityMaterialDust'),RequiredMaterialLevels=(25,25,10,10))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialArcticSuit',Class'DEKRPG999X.AbilityMaterialNanite',Class'DEKRPG999X.AbilityMaterialDust'),RequiredMaterialLevels=(30,30,20,20))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialArcticSuit',Class'DEKRPG999X.AbilityMaterialNanite',Class'DEKRPG999X.AbilityMaterialDust'),RequiredMaterialLevels=(35,35,30,30))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialArcticSuit',Class'DEKRPG999X.AbilityMaterialNanite',Class'DEKRPG999X.AbilityMaterialDust'),RequiredMaterialLevels=(40,40,40,40))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialArcticSuit',Class'DEKRPG999X.AbilityMaterialNanite',Class'DEKRPG999X.AbilityMaterialDust'),RequiredMaterialLevels=(45,45,45,45))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialArcticSuit',Class'DEKRPG999X.AbilityMaterialNanite',Class'DEKRPG999X.AbilityMaterialDust'),RequiredMaterialLevels=(50,50,50,50))
}