//The actual buff or ailment applied to the Pawn

class ComboEffectInv extends Inventory
	config(UT2004RPG);

var Pawn PawnOwner;	//The Pawn that has this effect(buff or ailment)
var Pawn Enemy;		//The Pawn that gave this effect(buff or ailment) to PawnOwner
var bool bBuff;		//True if buff, false if ailment
var float EffectMultiplier;	//The intensity of the buff or ailment
var config class<Emitter> EffectEmitterClass;
var Emitter EffectEmitter;
var config class<xEmitter> EffectxEmitterClass;
var xEmitter EffectxEmitter;
var bool bDispellable;	//True if this buff or ailment can be dispelled
var localized string ComboNameMessage, SecondsMessage;
var float ApplyCounter;	//The number of times this effect has been applied. Used to calculate the diminishing effect on the EffectMultipier

replication
{
	reliable if (ROLE == ROLE_Authority)
		EffectMultiplier;
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	PawnOwner = Other;
	ApplyCounter = 1.00000;
	SetTimer(1, True);
	Super.GiveTo(Other);
}

simulated function Timer()
{
	if (PawnOwner != None)
	{
		if (Vehicle(PawnOwner) != None)
			PawnOwner = Vehicle(PawnOwner).Driver;
		if (EffectEmitter == None)
		{
			EffectEmitter = PawnOwner.Spawn(EffectEmitterClass, PawnOwner,,PawnOwner.Location);
			if (EffectEmitter != None)
			{
				EffectEmitter.bHardAttach = True;
				EffectEmitter.SetBase(PawnOwner);
			}
		}
		if (EffectxEmitter == None)
		{
			EffectxEmitter = PawnOwner.Spawn(EffectxEmitterClass, PawnOwner,,PawnOwner.Location);
			if (EffectxEmitter != None)
			{
				EffectxEmitter.bHardAttach = True;
				EffectxEmitter.SetBase(PawnOwner);
			}
		}
	}
}

simulated function Destroyed()
{
	if (EffectEmitter != None)
		EffectEmitter.Destroy();
	if (EffectxEmitter != None)
		EffectxEmitter.Destroy();
	Super.Destroyed();
}

defaultproperties
{
	 MessageClass=Class'UnrealGame.StringMessagePlus'
	 SecondsMessage=" seconds"
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
