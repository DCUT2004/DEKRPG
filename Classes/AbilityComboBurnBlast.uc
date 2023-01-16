class AbilityComboBurnBlast extends AbilityCombo
	config(UT2004RPG)
	abstract;

#exec  AUDIO IMPORT NAME="ComboBurnBlast" FILE="Sounds\ComboBurnBlast.WAV" GROUP="ComboSounds"

defaultproperties
{
	ExcludingAbilities(0)=Class'AbilityComboEnergyCleave'
	ExcludingAbilities(1)=Class'AbilityComboWarcry'
	AbilityName="Fire I: Burn Blast"
	AltarClass=Class'DEKRPG999X.Altar_Fire'
	NumGeodesRequired=1
	Combos(0)=(StatusEffectClass=Class'StatusEffect_Burn',Modifier=-2,StatusLifespan=10,bDispellable=True,bStackable=False,Range=RANGE_Near)
	AttackCombo=(DamageRange=RANGE_Near,NumHits=1,DamagePerLevel=15,DamageType=Class'DamTypeCombo',TimeBetweenHits=0.5)
	Description="- Deals 15 damage per level to all nearby enemies.|- All nearby enemies receive Burn 2 for 10 seconds.||Use the combo BBFF (back-back-forward-forward) at a Fire Altar that contains 1 or more Geodes.||Materials Required:|Nali Fruit and Combat Boots - 5x the ability level you wish to purchase.||You can only have one type of Fire I combo.||Cost(per level): 5, 10, 15..."
	StartingCost=5
	CostAddPerLevel=5
	Materials(0)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialNaliFruit',Class'DEKRPG999X.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialNaliFruit',Class'DEKRPG999X.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialNaliFruit',Class'DEKRPG999X.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialNaliFruit',Class'DEKRPG999X.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialNaliFruit',Class'DEKRPG999X.AbilityMaterialCombatBoots'),RequiredMaterialLevels=(25,25))
	ComboSound=Sound'DEKRPG999X.ComboSounds.ComboBurnBlast'
}
