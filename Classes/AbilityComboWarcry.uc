class AbilityComboWarcry extends AbilityCombo
	config(UT2004RPG)
	abstract;

defaultproperties
{
	AbilityName="Liandri I: Warcry"
	AltarClass=Class'DEKRPG999X.Altar_Liandri'
	NumGeodesRequired=1
	Combos(0)=(StatusEffectClass=Class'StatusEffect_DamageBonus',Modifier=6,StatusLifespan=30,bDispellable=True,bStackable=False,Range=RANGE_Single)
	Description="- Deals 35 damage per level to the enemy with the highest health.|- The caster receives +6% attack per level for 30 seconds.||Use the combo BBFF (back-back-forward-forward) at a Liandri Altar that contains 1 or more Geodes.||Materials Required:|Steel and Gloves - 5x the ability level you wish to purchase.||Cost(per level): 5, 10, 15..."
	StartingCost=5
	CostAddPerLevel=5
	Materials(0)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialGloves'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialGloves'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialGloves'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialGloves'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialGloves'),RequiredMaterialLevels=(25,25))
}
