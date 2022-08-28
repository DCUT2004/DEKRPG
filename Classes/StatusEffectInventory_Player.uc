/*
* StatusEffectInventory_Player is spawned on a Player through RPGClass
* It manages a Pawn's currently applied Status Effects, and properly adds or removes them
* Additionally, it holds an array for the Player's purchased Combos
*/

class StatusEffectInventory_Player extends StatusEffectInventory
	config (UT2004RPG);
	
struct StatusCombo
{
	var Class<StatusEffect> EffectClass;
	var int Modifier;
	var int Lifespan;
	var bool bDispellable;
	var bool bStackable;
};
var Array < StatusCombo > Combos;		//Array that is populated by each combo ability purchased by the player

struct AttackingCombo
{
	var Class<OffenseCombo> OffenseClass;
	var int NumTargets;					//How many targets do we damage per hit? 0 for all enemies
	var int NumHits;					//How many hits does a target receive?
	var int DamagePerHit;				//How much damage does each hit do?
	var Class<DamageType> DamageType;
	var int TimeBetweenHits;
};
var AttackingCombo AttackCombo;

//Called by the ComboAbility purchased by player
function AddCombo(Class<StatusEffect> EffectClass, int Modifier, int LifespanToAdd, bool bDispellable, bool bStackable)
{
	local int x;
	
	for (x = 0; x < Combos.Length; x++)
	{
		if (Combos[x].EffectClass == EffectClass)	//In the event ModifyPawn() of abilities get called multiple times while a player is alive
			return;
	}
	
	Combos.Insert(0, 1);
	Combos[0].EffectClass = EffectClass;
	Combos[0].Modifier = Modifier;
	Combos[0].Lifespan = LifespanToAdd;
	Combos[0].bDispellable = bDispellable;
	Combos[0].bStackable = bStackable;
}

//Called by the ComboAbilityOffense purchased by player
function AddAttackCombo(Class<OffenseCombo> OffenseClass, int NumTargets, int NumHits, int DamagePerHit, Class<DamageType> DamageType, int TimeBetweenHits)
{
	AttackCombo.OffenseClass = OffenseClass;
	AttackCombo.NumTargets = NumTargets;
	AttackCombo.NumHits = NumHits;
	AttackCombo.DamagePerHit = DamagePerHit;
	AttackCombo.DamageType = DamageType;
	AttackCombo.TimeBetweenHits = TimeBetweenHits;
}

//Called by DEKComboSpecial when player executes combo with BBFF
function ExecuteCombos()
{
	local int x;
	local Controller C, NextC;
	local StatusEffectInventory StatusInv;
	local OffenseCombo AttackComboInst;
	
	if (Instigator == None || Instigator.Controller == None || Instigator.Health <= 0)
		return;
	
	for (x = 0; x < Combos.Length; x++)
	{
		C = Level.ControllerList;
		while (C != None)
		{
			NextC = C.NextController;
			
			if (C != None && C.Pawn != None && C.Pawn.Health > 0)
			{
				if ( (Combos[x].Modifier > 0 && C.Pawn.GetTeamNum() == Instigator.GetTeamNum() )
					|| ( Combos[x].Modifier < 0 && C.Pawn.GetTeamNum() != Instigator.GetTeamNum() )
				)
				{
					StatusInv = StatusEffectInventory(C.Pawn.FindInventoryType(Class'StatusEffectInventory'));
					if (StatusInv != None)
						StatusInv.AddStatusEffect(Combos[x].EffectClass, Combos[x].Modifier, Combos[x].Lifespan, Combos[x].bDispellable, Combos[x].bStackable, Instigator);
				}
			}
			
			C = NextC;
		}
	}
	
	if (AttackCombo.OffenseClass == None)
		return;
	AttackComboInst = Instigator.Spawn(AttackCombo.OffenseClass, Instigator);
	if (AttackComboInst == None)
		return;
	AttackComboInst.NumTargets = AttackCombo.NumTargets;
	AttackComboInst.NumHits = AttackCombo.NumHits;
	AttackComboInst.DamagePerHit = AttackCombo.DamagePerHit;
	AttackComboInst.DamageType = AttackCombo.DamageType;
	AttackComboInst.TimeBetweenHits = AttackCombo.TimeBetweenHits;
	AttackComboInst.StartDamage();
}

function DoOffensiveCombo()
{
	
}

defaultproperties
{
}
