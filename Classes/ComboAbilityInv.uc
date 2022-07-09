//The combo that the player has purchased
class ComboAbilityInv extends Inventory
	config(UT2004RPG)
	abstract;

var ComboInv Combo;
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
var int TickCount;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	Super.GiveTo(Other);
	if (Other != None)
	{
		Combo = ComboInv(Other.FindInventoryType(class'ComboInv'));
	}
	TickCount = 0;
	Enable('Tick');
}

function DoEffect();

//Tick creates a Linked List of combos on the player's GiveItems inventory
//If a linked list already exists, the combo is added at the end
//This method is invoked by the derived classes
simulated function Tick(float DeltaTime)
{
	local ComboAbilityInv CAInv;
	local GiveItemsInv GInv;
	
	if (Pawn(Owner) != None && Pawn(Owner).Controller != None)
	{
		GInv = class'GiveItemsInv'.static.GetGiveItemsInv(Pawn(Owner).Controller);
		//Create combo list for GInv
		if (GInv != None)
		{
			//An empty list. Set Inv as the first combo in the linked list
			if (GInv.Combo == None)
			{
				GInv.Combo = Self;
				Disable('Tick');
			}
			else	//We have some combos in the list. Move to the back of the list and add it there
			{
				for (CAInv = GInv.Combo; CAInv.ComboAbilityInv != None; CAInv = CAInv.ComboAbilityInv)
				{
				}
				CAInv.ComboAbilityInv = Self;
				Disable('Tick');
			}			
		}
	}
	TickCount++;
	if (TickCount > 1000)
		Disable('Tick');
}

defaultproperties
{
	ComboDamageType=Class'DEKRPG209F.DamTypeCombo'
	bOnlyRelevantToOwner=False
	bAlwaysRelevant=True
	bReplicateInstigator=True
	MessageClass=Class'UnrealGame.StringMessagePlus'
}
