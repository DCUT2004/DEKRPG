/*
* A status effect is a temporary actor spawned by a Pawn's StatusEffectInventory
* A status effect can provide positive (buff) or negative (aillment) effects to the holder
* A status effect has a Modifier, representing the intensity of the buff or ailment
* A status effect has a lifespan, but can be removed/dispelled earlier (bDispellable)
* If the holder already has a certain status effect, then other attempts to add a similar status effect can increase the Modifier and/or lifespan (bStackable)
* Status effects will have a pointer to the StatusEffectInventory item that spawned it, for managing destructions of this instance
* All magic inventory items (FreezeInv, SuperHeatInv, DruidPoisonInv, etc.) will be replaced with StatusEffect
*/

class StatusEffect extends Actor
	abstract
	config(UT2004RPG);
	
var Pawn Producer;								//Who gave this status effect to this pawn?
var config bool bDispellable;					//Whether this status effect can be removed before its Lifespan duration
var config bool bStackable;						//If true, and Pawn already has a similar status effect, then new status effects will increase the Modifier and/or Lifespan
var int Modifier;								//Intensity of this status effect. > 0 is a buff, < 0 is an ailment if applicable
var StatusEffectInventory StatusEffectInv;
var Class<xEmitter> xEmitterAilmentFX, xEmitterBuffFX;		//xEmitter for Ailment and Buff
var Sound AilmentSound, BuffSound;

function StartEffect(Pawn Target);	//Called by StatusEffectInventory. This function should be overridden.
function StopEffect(Pawn Target);

simulated function Destroyed()
{
	local int x;
	
	Super.Destroyed();
	if (Instigator != None)
		StopEffect(Instigator);
	if (StatusEffectInv != None)
	{
		for (x = 0 ; x < StatusEffectInv.StatusEffects.Length; x++)
			if (StatusEffectInv.StatusEffects[x] == self)
				StatusEffectInv.StatusEffects.Remove(x, 1);
	}
}

defaultproperties
{
	DrawType=DT_None
	AmbientGlow=0
	bHidden=true
	Physics=PHYS_None
	bReplicateMovement=false
}
