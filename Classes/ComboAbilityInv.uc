//Deprecated - Use StatusEffect Classes
//Will need to move Special combos over
class ComboAbilityInv extends Inventory
	config(UT2004RPG)
	abstract;

var ComboAbilityInv ComboAbilityInv;	//Linked list
var bool bSingle, bAll;
var float EffectMultiplier;
var float ComboLifespan;
var bool bDispellable;
var Emitter EffectEmitter;
var class<Emitter> EffectEmitterClass;
var xEmitter EffectxEmitter;
var config class<xEmitter> EffectxEmitterClass;
var int ComboDamage;
var config class<DamageType> ComboDamageType;


function DoEffect();

defaultproperties
{
	ComboDamageType=Class'DEKRPG999X.DamTypeCombo'
	bOnlyRelevantToOwner=False
	bAlwaysRelevant=True
	bReplicateInstigator=True
	MessageClass=Class'UnrealGame.StringMessagePlus'
}
