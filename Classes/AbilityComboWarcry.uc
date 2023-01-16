class AbilityComboWarcry extends AbilityCombo
	config(UT2004RPG)
	abstract;

#exec  AUDIO IMPORT NAME="ComboWarcry" FILE="Sounds\ComboWarcry.WAV" GROUP="ComboSounds"

defaultproperties
{
	ExcludingAbilities(0)=Class'AbilityComboEnergyCleave'
	ExcludingAbilities(1)=Class'AbilityComboBurnBlast'
	AbilityName="Fire I: Warcry"
	AltarClass=Class'DEKRPG999X.Altar_Fire'
	NumGeodesRequired=1
	Combos(0)=(StatusEffectClass=Class'StatusEffect_DamageBonus',Modifier=6,StatusLifespan=30,bDispellable=True,bStackable=False,Range=RANGE_Single)
	AttackCombo=(DamageRange=RANGE_Single,NumHits=1,DamagePerLevel=35,DamageType=Class'DamTypeCombo',TimeBetweenHits=0.5)
	Description="- Deals 35 damage per level to the enemy with the highest health.|- The caster receives +6% attack per level for 30 seconds.||Use the combo BBFF (back-back-forward-forward) at a Fire Altar that contains 1 or more Geodes.||Materials Required:|Steel and Gloves - 5x the ability level you wish to purchase.||You can only have one type of Fire I combo.||Cost(per level): 5, 10, 15..."
	StartingCost=5
	CostAddPerLevel=5
	Materials(0)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialGloves'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialGloves'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialGloves'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialGloves'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialSteel',Class'DEKRPG999X.AbilityMaterialGloves'),RequiredMaterialLevels=(25,25))
	ComboSound=Sound'DEKRPG999X.ComboSounds.ComboWarcry'
}
