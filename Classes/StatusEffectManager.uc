/*
* StatusEffectManager is the parent class for any instantiated StatusEffect inventory object
* It contains an array of StatusEffect structs representing the pawn's currently applied status effects
* It contains functions to add and remove status effects
* It also manages the lifespan of each status effect
*/

class StatusEffectManager extends Inventory
	config (UT2004RPG);
	
var Array < StatusEffectData > StatusEffects;			//The pawn's currently applied status effects

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer(1, True);
}

//Timer will manage each StatusEffect's lifespan
function Timer()
{
	local int x;
	
	if (Instigator == None || Instigator.Health <= 0 || Instigator.Controller == None)
		Destroy();
	
	for (x = 0; x < StatusEffects.Length; x++)
	{
		if (StatusEffects[x].Modifier == 0)
			RemoveStatusEffect(StatusEffects[x].StatusEffectName);
		else
		{
			OnTimerDoEffect(x);
			if (StatusEffects[x].StatusLifespan > 0 && --StatusEffects[x].StatusLifespan <= 0)
			{
				OnRemoveDoEffect(x);
				StatusEffects.Remove(x, 1);
			}
		}
	}
}

//This function should be overridden in a child subclass
function OnTimerDoEffect(int EffectIndx);

//This function should be overridden in a child subclass
function OnRemoveDoEffect(int EffectIndx);

//Adds a status effect
//Returns True for new status effects, not previously existing ones that were stacked on
function bool AddStatusEffect(string StatusEffectName, int Modifier, int StatusLifespan, bool bDispellable, bool bStackable, optional Pawn Producer)
{
	local int x;
	
	if (StatusEffectName == "" || Modifier == 0 || Modifier < 0 && CheckMagicalWard())
		return False;
	
	//Before adding a status effect, check to see if this pawn already has one and whether it is stackable
	for (x = 0; x < StatusEffects.Length; x++)
	{
		if (StatusEffects[x].StatusEffectName == StatusEffectName)
		{
			if (StatusEffects[x].bStackable)
			{
				//Stop if we'll get a 0 Modifier
				if (StatusEffects[x].Modifier + Modifier == 0)
				{
					RemoveStatusEffect(StatusEffects[x].StatusEffectName);
					return False;
				}
					
				//StatusEffect is stackable. Add to Modifier (which can be + or -)
				StatusEffects[x].Modifier += Modifier;
				
				//Adjust for MaxModifier if over the limit
				if (StatusEffects[x].Modifier > 0 && StatusEffects[x].Modifier > StatusEffects[x].MaxModifier)
					StatusEffects[x].Modifier = StatusEffects[x].MaxModifier;
				if (StatusEffects[x].Modifier < 0 && StatusEffects[x].Modifier < -(StatusEffects[x].MaxModifier))
					StatusEffects[x].Modifier = -StatusEffects[x].MaxModifier;
					
				OnAddDoEffect(x, true);
			}
			
			return False;
		}
	}
	
	//Pawn does not have this StatusEffect. Add it
	StatusEffects.Insert(0, 1);
	StatusEffects[0].StatusEffectName = StatusEffectName;
	StatusEffects[0].Modifier = Modifier;
	StatusEffects[0].StatusLifespan = StatusLifespan;
	StatusEffects[0].bDispellable = bDispellable;
	StatusEffects[0].bStackable = bStackable;
	StatusEffects[0].Producer = Producer;
	OnAddDoEffect(0, false);
	return True;
}

function bool HasStatusEffect(string StatusEffectName)
{
	local int x;
	
	for (x = 0; x < StatusEffects.Length; x++)
		if (StatusEffects[x].StatusEffectName == StatusEffectName)
			return true;
	return false;
}

function int GetStatusEffectIndex(string StatusEffectName)
{
	local int x;
	
	for (x = 0; x < StatusEffects.Length; x++)
		if (StatusEffects[x].StatusEffectName == StatusEffectName)
			return x;
	return -1;
}

//This function should be overridden in a child subclass
function bool CheckMagicalWard();

//This function should be overridden in a child subclass
function OnAddDoEffect(int EffectIndx, bool bOnStack);

//Remove a particular status effect, w/o regard to dispellable status
function RemoveStatusEffect(String StatusEffectName)
{
	local int x;
	
	for (x = 0; x < StatusEffects.Length; x++)
		if (StatusEffects[x].StatusEffectName == StatusEffectName)
		{
			OnRemoveDoEffect(x);
			StatusEffects.Remove(x, 1);
		}
}

//Remove all status effects w/o regard to dispellable status
function RemoveAllStatusEffects()
{
	local int x;
	
	for (x = 0; x < StatusEffects.Length; x++)
		OnRemoveDoEffect(x);
	StatusEffects.Length = 0;		//Clears the array
}

//Remove any dispellable status buff on this pawn
function DispelBuffs()
{
	local int x;
	
	for (x = 0; x < StatusEffects.Length; x++)
		if (StatusEffects[x].Modifier > 0 && StatusEffects[x].bDispellable)
		{
			OnRemoveDoEffect(x);
			StatusEffects.Remove(x, 1);	
		}
}

//Remove any dispellable status ailments on this pawn
function DispelAilments()
{
	local int x;
	
	for (x = 0; x < StatusEffects.Length; x++)
		if (StatusEffects[x].Modifier < 0 && StatusEffects[x].bDispellable)
		{
			OnRemoveDoEffect(x);
			StatusEffects.Remove(x, 1);
		}
}

simulated function Destroyed()
{
	Super.Destroyed();
	RemoveAllStatusEffects();
}

defaultproperties
{
}
