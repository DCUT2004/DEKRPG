/*
* StatusEffectData is an abstract Inventory item that holds a struct representing a StatusEffect
* A StatusEffect can provide positive or negative effects to the holder
* A status effect has a Modifier, representing the intensity of the effect
* Positive Modifiers grant buffs to the holder, Negative Modifiers grant ailments
* StatusEffects have a lifespan, but can be removed/dispelled earlier (bDispellable)
* If the holder already has a certain status effect, then other attempts to add a similar status effect can increase the Modifier and/or lifespan (bStackable)
* This class should never be instantiated.
*/

class StatusEffectData extends Object
	config(UT2004RPG);
	
var string StatusEffectName;
var Pawn Producer;								//Who gave this status effect to this pawn?
var int Modifier;								//Intensity of this status effect. > 0 is a buff, < 0 is an ailment
var config int MaxModifier;
var int StatusLifespan;							//How long this StatusEffect lasts
var bool bDispellable;							//Whether this status effect can be removed before its Lifespan duration
var bool bStackable;							//If true, the Modifier will fluctuate when new status effects are given
var bool bOnlyPositiveModifier, bOnlyNegativeModifier;

static function string GetName()
{
	return default.StatusEffectName;
}

static function int GetMaxModifier()
{
	return default.MaxModifier;
}

static function int GetStatusLifespan()
{
	return default.StatusLifespan;
}

static function bool IsDispellable()
{
	return default.bDispellable;
}

static function bool IsStackable()
{
	return default.bStackable;
}

static function bool IsOnlyPositive()
{
	return default.bOnlyPositiveModifier;
}

static function bool IsOnlyNegative()
{
	return default.bOnlyNegativeModifier;
}

defaultproperties
{
	bOnlyNegativeModifier=False
	bOnlyPositiveModifier=False
}
