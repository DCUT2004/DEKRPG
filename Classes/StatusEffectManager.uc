/*
* StatusEffectManager is the parent class for any instantiated StatusEffect inventory object
* It contains an array of StatusEffect structs representing the pawn's currently applied status effects
* It contains functions to add and remove status effects
* It also manages the lifespan of each status effect
*/

class StatusEffectManager extends Inventory
	config (UT2004RPG);

struct StatusEffect
{
	var string StatusEffectName;
	var Pawn Producer;								//Who gave this status effect to this pawn?
	var int Modifier;								//Intensity of this status effect. > 0 is a buff, < 0 is an ailment
	var config int MaxModifier;
	var int StatusLifespan;							//How long this StatusEffect lasts
	var bool bDispellable;							//Whether this status effect can be removed before its Lifespan duration
	var bool bStackable;							//If true, the Modifier will fluctuate when new status effects are given
	var bool bOnlyPositiveModifier, bOnlyNegativeModifier;
};

var Array < StatusEffect > StatusEffects;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer(1, True);
}

static final function StatusEffectManager GetStatusEffectManager(Pawn P)
{
	local StatusEffectManager StatusInventory;

	if (P == None)
		return None;
	
	StatusInventory = StatusEffectManager(P.FindInventoryType(Class'StatusEffectManager'));
	return StatusInventory;
}

static function AddHealableDamage(int Damage, Pawn Injured)
{
	Local HealableDamageInv Inv;

	if(Injured == None || Injured.Controller == None || Injured.Health <= 0 || Damage < 1)
		return; // Not EXP Healable

	if(Injured.isA('Monster') && !Injured.Controller.isA('DEKFriendlyMonsterController'))
		return; 	// No tracking for not friendly monsters.

	Inv = HealableDamageInv(Injured.FindInventoryType(class'HealableDamageInv'));
	if(Inv == None)
	{
		Inv = Injured.spawn(class'HealableDamageInv');
		Inv.giveTo(Injured);
	}

	if(Inv == None)
	    return;

	Inv.Damage += Damage;

	if(Inv.Damage > Injured.HealthMax + Class'HealableDamageGameRules'.default.MaxHealthBonus)
		Inv.Damage = Injured.HealthMax + Class'HealableDamageGameRules'.default.MaxHealthBonus;
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
			RemoveStatusEffect(x);
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
function bool AddStatusEffect(Class<StatusEffectData> StatusEffectClass, int Modifier, optional bool Override, optional int StatusLifespan, optional bool bDispellable, optional bool bStackable, optional Pawn Producer)
{
	local int x;
	
	if (StatusEffectClass == None || Modifier == 0 || Modifier < 0 && CheckMagicalWard())
		return False;

	//Before adding a status effect, check to see if this pawn already has one and whether it is stackable
	for (x = 0; x < StatusEffects.Length; x++)
	{
		if (StatusEffects[x].StatusEffectName == StatusEffectClass.static.GetName())	//How we uniquely identify a status effect
		{
			if (StatusEffects[x].bStackable)
			{
				//Stop if we'll get a 0 Modifier
				if (StatusEffects[x].Modifier + Modifier == 0)
				{
					RemoveStatusEffect(x);
					return False;
				}
					
				//StatusEffect is stackable. Add to Modifier (which can be + or -)
				StatusEffects[x].Modifier += Modifier;
				
				//Adjust for MaxModifier if over the limit
				if (StatusEffects[x].Modifier > 0 && StatusEffects[x].Modifier > StatusEffectClass.static.GetMaxModifier())
					StatusEffects[x].Modifier = StatusEffectClass.static.GetMaxModifier();
				if (StatusEffects[x].Modifier < 0 && StatusEffects[x].Modifier < -(StatusEffectClass.static.GetMaxModifier()))
					StatusEffects[x].Modifier = -StatusEffectClass.static.GetMaxModifier();
					
				OnAddDoEffect(x, true);
			}
			
			return False;
		}
	}
	
	//Pawn does not have this StatusEffect. Add it
	StatusEffects.Insert(0, 1);
	StatusEffects[0].StatusEffectName = StatusEffectClass.static.GetName();
	StatusEffects[0].Modifier = Modifier;
	//For the remaining values, we use the default values of StatusEffectClass
	//Otherwise, use the provided values in the parameter
	if (Override)
	{
		StatusEffects[0].StatusLifespan = StatusLifespan;
		StatusEffects[0].bDispellable = bDispellable;
		StatusEffects[0].bStackable = bStackable;
	}
	else	//Use defaut values in class
	{
		StatusEffects[0].StatusLifespan = StatusEffectClass.static.GetStatusLifespan();
		StatusEffects[0].bDispellable = StatusEffectClass.static.IsDispellable();
		StatusEffects[0].bStackable = StatusEffectClass.static.IsStackable();
	}
	if (Producer != None)
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

function int GetIndex(Class<StatusEffectData> StatusEffectClass)
{
	local int x;
	if (StatusEffectClass == None)
		return -1;
	for (x = 0; x < StatusEffects.Length; x++)
		if (StatusEffects[x].StatusEffectName == StatusEffectClass.static.GetName())
			return x;
	return -1;
}

//This function should be overridden in a child subclass
function bool CheckMagicalWard();

//This function should be overridden in a child subclass
function OnAddDoEffect(int EffectIndx, bool bOnStack);

//Remove a particular status effect, w/o regard to dispellable status
function RemoveStatusEffect(int index)
{
	if (index < 0 || index >= StatusEffects.Length)
		return;
	OnRemoveDoEffect(index);
	StatusEffects.Remove(index, 1);
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
