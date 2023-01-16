class AbilityComboEnergyCleave extends AbilityCombo
	config(UT2004RPG)
	abstract;

#exec  AUDIO IMPORT NAME="ComboEnergyCleave" FILE="Sounds\ComboEnergyCleave.WAV" GROUP="ComboSounds"

defaultproperties
{
	ExcludingAbilities(0)=Class'AbilityComboWarcry'
	ExcludingAbilities(1)=Class'AbilityComboBurnBlast'
	AbilityName="Fire I: Energy Cleave"
	AltarClass=Class'DEKRPG999X.Altar_Fire'
	NumGeodesRequired=1
	Combos(0)=(StatusEffectClass=Class'StatusEffect_AdrenRegen',Modifier=1,StatusLifespan=20,bDispellable=True,bStackable=False,Range=RANGE_All)
	AttackCombo=(DamageRange=RANGE_All,NumHits=1,DamagePerLevel=10,DamageType=Class'DamTypeCombo',TimeBetweenHits=0.5)
	Description="- Deals 10 damage per level to all enemies.|- Caster and all allies receive 1 adrenaline per second for 20 seconds.||Use the combo BBFF (back-back-forward-forward) at a Fire Altar that contains 1 or more Geodes.||Materials Required:|Lumber and Tarydium Shards - 5x the ability level you wish to purchase.||You can only have one type of Fire I combo.||Cost(per level): 5, 10, 15..."
	StartingCost=5
	CostAddPerLevel=5
	Materials(0)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialTarydiumShards'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialTarydiumShards'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialTarydiumShards'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialTarydiumShards'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLumber',Class'DEKRPG999X.AbilityMaterialTarydiumShards'),RequiredMaterialLevels=(25,25))
	ComboSound=Sound'DEKRPG999X.ComboSounds.ComboEnergyCleave'
}
