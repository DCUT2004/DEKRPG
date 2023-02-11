/*
	DEKMonsterUtility is an Object that acts as a helper for most monsters
	Provides all monsters with a StatusEffectInventory item when spawning
	Adjusts damage for StatusEffects by calling StatusEffectDamageRules.HandleDamage()
 */

class DEKMonsterUtility extends Object;

static function StatusEffectInventory SpawnStatusEffectInventory(DCMonsterController MonsterController)
{
	if (MonsterController == None)
		return None;

	if (MonsterController.StatusManager != None)
		return MonsterController.StatusManager;

	return MonsterController.Spawn(Class'StatusEffectInventory');
}

static function int AdjustDamage(int Damage, Pawn EventInstigator, Monster Victim, vector HitLocation, vector Momentum, Class<DamageType> DamageType)
{
	local StatusEffectInventory EventInstigatorStatusManager;

	if (Victim == None || Victim.Controller == None || DCMonsterController(Victim.Controller) == None)
		return Damage;

	EventInstigatorStatusManager = StatusEffectInventory(Class'StatusEffectManager'.static.GetStatusEffectManager(EventInstigator));

	return Class'StatusEffectDamageRules'.static.HandleDamage(Damage, EventInstigator, EventInstigatorStatusManager, Victim, DCMonsterController(Victim.Controller).StatusManager, HitLocation, Momentum, DamageType);
}

defaultproperties
{
}
