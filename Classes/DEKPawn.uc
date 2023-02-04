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

defaultproperties
{
}
