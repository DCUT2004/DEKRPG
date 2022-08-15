class AbilityHigherWeaponModifiers extends CostRPGAbility
	config(UT2004RPG)
	abstract;

defaultproperties
{
     MinAdrenalineMax=120
     AdrenalineMaxStep=20
     AbilityName="Higher Weapon Modifiers"
     Description="Have increased chance of higher weapon modifiers. At each level, the lowest modifier you can get increases. ||You must spend 20 points in your Adrenaline Max stat for each level of this ability you want to purchase. |Cost (per level): 10"
     StartingCost=10
     MaxLevel=8
}
