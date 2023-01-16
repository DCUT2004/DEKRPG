class AbilityComboPiercingShot extends AbilityCombo
	config(UT2004RPG)
	abstract;

#exec  AUDIO IMPORT NAME="ComboPiercingShot" FILE="Sounds\ComboPiercingShot.WAV" GROUP="ComboSounds"

defaultproperties
{
	//ExcludingAbilities(0)=Class'AbilityComboEnergyCleave'
	//ExcludingAbilities(1)=Class'AbilityComboBurnBlast'
	AbilityName="Fire II: Piercing Shot"
	AltarClass=Class'DEKRPG999X.Altar_Fire'
	NumGeodesRequired=2
	Combos(0)=(StatusEffectClass=Class'StatusEffect_ChanceHit',Modifier=6,StatusLifespan=30,bDispellable=True,bStackable=False,Range=RANGE_Single)
	AttackCombo=(DamageRange=RANGE_Single,NumHits=1,DamagePerLevel=100,DamageType=Class'DamTypeCombo',TimeBetweenHits=0.5)
	Description="- Deals 100 damage per level to the enemy with the highest health.|- The enemy receives -8% defense per level for 30 seconds.|- The caster receives +8% critical chance per level for 30 seconds.||Use the combo BBFF (back-back-forward-forward) at a Fire Altar that contains 2 or more Geodes.||Materials Required:|Steel and Gloves - 5x the ability level you wish to purchase.||You can only have one type of Fire II combo.||Cost(per level): 5, 10, 15..."
	StartingCost=5
	CostAddPerLevel=5
	Materials(0)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor'),RequiredMaterialLevels=(5,5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor'),RequiredMaterialLevels=(10,10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor'),RequiredMaterialLevels=(15,15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor'),RequiredMaterialLevels=(20,20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG999X.AbilityMaterialLeather',Class'DEKRPG999X.AbilityMaterialPlatedArmor'),RequiredMaterialLevels=(25,25))
	ComboSound=Sound'DEKRPG999X.ComboSounds.ComboPiercingShot'
}
