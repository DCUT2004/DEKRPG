/*
Extended class of xPawn that players spawn with
Spawns a StatusEffectInventory item for the player and keeps a reference to it for constant access
Adjusts damage for StatusEffects through StatusEffectDamageRules.HandleDamage()
 */

class DEKPawn extends xPawn;

var StatusEffectInventory StatusManager;
var MissionInvBETA MissionInv;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	StatusManager = StatusEffectInventory_Player(Instigator.FindInventoryType(Class'StatusEffectInventory_Player'));
	if (StatusManager == None)
	{
		StatusManager = Instigator.Spawn(Class'StatusEffectInventory_Player');
		StatusManager.GiveTo(Instigator);
	}
}

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
	local StatusEffectInventory EventInstigatorStatusManager;

	EventInstigatorStatusManager = StatusEffectInventory(Class'StatusEffectManager'.static.GetStatusEffectManager(EventInstigator));
	Damage = class'StatusEffectDamageRules'.static.HandleDamage(Damage, EventInstigator, EventInstigatorStatusManager, Instigator, StatusManager, HitLocation, Momentum, DamageType);
	Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
}

defaultproperties
{
}
