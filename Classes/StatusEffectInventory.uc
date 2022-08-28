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

var config int ParasiteHealAmount;

//Add a status effect to this Pawn
//If Pawn already has a similar status effect, check if the status effect can be stackable
//Return instances of newly added status effects
function StatusEffect AddStatusEffect(Class<StatusEffect> EffectClass, int ModifierToAdd, int LifespanToAdd, bool bDispellable, bool bStackable, optional Pawn Producer)
{
	local int x;
	local StatusEffect Effect;
	local StatusEffect_MagicalWard Ward;
	local StatusEffect_Parasite Parasite;
	
	if (EffectClass == None || ModifierToAdd == 0)
		return None;
	
	if (ModifierToAdd < 0)
	{
		Ward = StatusEffect_MagicalWard(GetStatusEffect(Class'StatusEffect_MagicalWard'));
		if (Ward != None && Rand(100) <= Ward.Modifier * Ward.WardChancePerModifier)
		{
			Ward.PlayWardEffect();
			return None;
		}
	}
	
	//See if we already have this status effect
	for (x = 0; x < StatusEffects.Length; x++)
		if (StatusEffects[x].Class == EffectClass)
		{
			if (StatusEffects[x].Modifier + ModifierToAdd == 0) 			//Will result in a zero modifier, i.e. no status effect, so stop here
			{
				StatusEffects[x].Destroy();
				return None;
			}
			if (StatusEffects[x].bStackable									//Is the effect stackable?
				|| !StatusEffects[x].bStackable && 
					(StatusEffects[x].Modifier > 0 && ModifierToAdd < 0 || StatusEffects[x].Modifier < 0 && ModifierToAdd > 0) )
			{
				StatusEffects[x].Modifier += ModifierToAdd;
				if (StatusEffects[x].Modifier > 0 && StatusEffects[x].Modifier > StatusEffects[x].MaxModifier)
					StatusEffects[x].Modifier = StatusEffects[x].MaxModifier;
				else if (StatusEffects[x].Modifier < 0 && StatusEffects[x].Modifier < -(StatusEffects[x].MaxModifier))
					StatusEffects[x].Modifier = -(StatusEffects[x].MaxModifier);
				if (LifespanToAdd != 0)
					StatusEffects[x].Lifespan += LifespanToAdd;
				if (StatusEffects[x].IsA('StatusEffect_Parasite'))
				{
					Parasite = StatusEffect_Parasite(StatusEffects[x]);
					if (Parasite != None)
						Parasite.AddHealth(ParasiteHealAmount);
				}
			}
			return None;	//Return None here, because we only want this function to return newly added StatusEffects. Proper use for finding current StatusEffects is GetStatusEffect()
		}
	Effect = Instigator.Spawn(EffectClass, Instigator);
	if (Effect != None)
	{
		StatusEffects.Insert(0, 1);
		StatusEffects[0] = Effect;
		Effect.StatusEffectInv = self;
		Effect.Modifier = ModifierToAdd;
		Effect.Lifespan = LifespanToAdd;
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
		
		return Effect;
	}
	return None;
}

function bool HasStatusEffect(Class<StatusEffect> EffectClass)
{
	local int x;
	
	for (x = 0; x < StatusEffects.Length; x++)
		if (StatusEffects[x].Class == EffectClass)
			return true;
	return false;
}

function StatusEffect GetStatusEffect(Class<StatusEffect> EffectClass)
{
	local int x;
	
	for (x = 0; x < StatusEffects.Length; x++)
		if (StatusEffects[x].Class == EffectClass)
			return StatusEffects[x];
	return None;
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

function DispelBuffs()
{
	local int x;
	
	for (x = 0; x < StatusEffects.Length; x++)
		if (StatusEffects[x].bDispellable && StatusEffects[x].Modifier > 0)
			StatusEffects[x].Destroy();	
}

function DispelAilments()
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
	ParasiteHealAmount=100
}
