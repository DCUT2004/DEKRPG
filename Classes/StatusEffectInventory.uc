/*
* StatusEffectInventory is spawned on a Pawn through MutDruidsRPG
* It manages a Pawn's currently applied Status Effects, and properly adds or removes them
*/

class StatusEffectInventory extends Inventory
	config (UT2004RPG);
	
var Array < StatusEffect > StatusEffects;		//The pawn's currently applied status effects

function AddStatusEffect(Class<StatusEffect> EffectClass, int ModifierToAdd)
{
	local int x;
	local StatusEffect Effect;
	
	if (EffectClass == None || ModifierToAdd == 0)
		return;
		
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
				return;
			}
			if (StatusEffects[x].bStackable									//Is the effect stackable?
				|| !StatusEffects[x].bStackable && 
					(StatusEffects[x].Modifier > 0 && ModifierToAdd < 0 || StatusEffects[x].Modifier < 0 && ModifierToAdd > 0) )
			{
				StatusEffects[x].Modifier += ModifierToAdd;
				//Should we also increase the lifespan if stacking on the effect?
			}
			return;
		}
	Effect = Instigator.Spawn(EffectClass, Instigator);
	if (Effect != None)
	{
		StatusEffects.Insert(0, 1);
		StatusEffects[0] = Effect;
		Effect.StatusEffectInv = self;
		Effect.StartEffect(Instigator);
	}
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

defaultproperties
{
}
