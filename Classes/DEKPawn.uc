/*
Extended class of xPawn that players spawn with
Spawns a StatusEffectInventory item for the player and keeps a reference to it for constant access
Adjusts damage for StatusEffects through StatusEffectDamageRules.HandleDamage()
 */

class DEKPawn extends xPawn;

var StatusEffectInventory StatusManager;

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

	if (DEKPawn(EventInstigator) != None)
		EventInstigatorStatusManager = DEKPawn(EventInstigator).StatusManager;
	else if (EventInstigator.Controller != None && DCMonsterController(EventInstigator.Controller) != None)
		EventInstigatorStatusManager = DCMonsterController(EventInstigator.Controller).StatusManager;
	Damage = class'StatusEffectDamageRules'.static.HandleDamage(Damage, EventInstigator, EventInstigatorStatusManager, Instigator, StatusManager, HitLocation, Momentum, DamageType);
	Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
}

defaultproperties
{
}
