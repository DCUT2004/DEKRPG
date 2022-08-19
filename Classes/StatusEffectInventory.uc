/*
* StatusEffectInventory is spawned on a Pawn through MutDruidsRPG
* It manages a Pawn's currently applied Status Effects, and properly adds or removes them
*/

class StatusEffectInventory extends Inventory
	config (UT2004RPG);
	
var Array < StatusEffect > StatusEffects;			//The pawn's currently applied status effects

//For constant-time access for StatusEffectGameRules
var StatusEffect DamageBonus;
var StatusEffect DamageReduction;
var StatusEffect Momentum;
var StatusEffect ChanceHit;

function bool AddStatusEffect(Class<StatusEffect> EffectClass, int ModifierToAdd, int Lifespan, bool bDispellable, bool bStackable, optional Pawn Producer)
{
	local int x;
	local StatusEffect Effect;
	
	if (EffectClass == None || ModifierToAdd == 0)
		return false;
		
	/* TODO:
		Add a check for magical ward
	*/
	
	//See if we already have this status effect
	for (x = 0; x < StatusEffects.Length; x++)
		if (StatusEffects[x].Class == EffectClass)
		{
			if (StatusEffects[x].Modifier + ModifierToAdd == 0) 			//Will result in a zero modifier, i.e. no status effect, so stop here
			{
				StatusEffects[x].Destroy();
				return false;
			}
			if (StatusEffects[x].bStackable									//Is the effect stackable?
				|| !StatusEffects[x].bStackable && 
					(StatusEffects[x].Modifier > 0 && ModifierToAdd < 0 || StatusEffects[x].Modifier < 0 && ModifierToAdd > 0) )
			{
				StatusEffects[x].Modifier += ModifierToAdd;
				StatusEffects[x].Lifespan += Lifespan;
			}
			return true;
		}
	Effect = Instigator.Spawn(EffectClass, Instigator);
	if (Effect != None)
	{
		StatusEffects.Insert(0, 1);
		StatusEffects[0] = Effect;
		Effect.StatusEffectInv = self;
		Effect.Modifier = ModifierToAdd;
		Effect.Lifespan = Lifespan;
		Effect.bDispellable = bDispellable;
		Effect.bStackable = bStackable;
		if (Producer != None)
			Effect.Producer = Producer;
		Effect.StartEffect(Instigator);
		
		Switch (EffectClass)
		{
			Case Class'StatusEffect_DamageBonus':
				DamageBonus = Effect;
				break;
			Case Class'StatusEffect_DamageReduction':
				DamageReduction = Effect;
				break;
			Case Class'StatusEffect_Momentum':
				Momentum = Effect;
				break;
			Case Class'StatusEffect_ChanceHit':
				ChanceHit = Effect;
				break;
		}
		
		return true;
	}
	return false;
}

function bool FindStatusEffect(Class<StatusEffect> EffectClass)
{
	local int x;
	
	for (x = 0; x < StatusEffects.Length; x++)
		if (StatusEffects[x].Class == EffectClass)
			return true;
	return false;
}

function int GetStatusEffectModifier(Class<StatusEffect> EffectClass)
{
	local int x;
	
	for (x = 0; x < StatusEffects.Length; x++)
		if (StatusEffects[x].Class == EffectClass)
			return StatusEffects[x].Modifier;
	return 0;
}

//For safety, the StatusEffect's Destroyed() will handle the removal of itself from StatusEffects array
//Here, we will simply call Destroy() on the StatusEffect
function RemoveStatusEffect(Class<StatusEffect> EffectClass)
{
	local int x;
	
	for (x = 0; x < StatusEffects.Length; x++)
		if (StatusEffects[x].Class == EffectClass)
			StatusEffects[x].Destroy();
}

function RemoveAllStatusEffects()
{
	local int x;
	
	for (x = 0; x < StatusEffects.Length; x++)
		StatusEffects[x].Destroy();
}

//RemoveStatusEffect() will remove a status effect w/o regard to whether it is dispellable or not
//DispelStatusEffect() will instead consider dispellable status
function DispelStatusEffect(Class<StatusEffect> EffectClass)
{
	local int x;
	
	for (x = 0; x < StatusEffects.Length; x++)
		if (StatusEffects[x].Class == EffectClass && StatusEffects[x].bDispellable)
			StatusEffects[x].Destroy();
}

function DispelAllStatusEffects()
{
	local int x;
	
	for (x = 0; x < StatusEffects.Length; x++)
		if (StatusEffects[x].bDispellable)
			StatusEffects[x].Destroy();	
}

function DiseplAllAilments()
{
	local int x;
	
	for (x = 0; x < StatusEffects.Length; x++)
		if (StatusEffects[x].bDispellable && StatusEffects[x].Modifier < 0)
			StatusEffects[x].Destroy();
}

simulated function Destroyed()
{
	Super.Destroyed();
	RemoveAllStatusEffects();
}

defaultproperties
{
}
