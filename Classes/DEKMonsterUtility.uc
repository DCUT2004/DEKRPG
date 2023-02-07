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
	local DEKPawn Other;
	local DCMonsterController OtherController;

	if (EventInstigator == None || Victim == None || Victim.Controller == None || DCMonsterController(Victim.Controller) == None)
		return Damage;

	Other = DEKPawn(EventInstigator);
	if (Other != None)		//Player or bot dealing damage to this monster
		return Class'StatusEffectDamageRules'.static.HandleDamage(Damage, Other, Other.StatusManager, Victim, DCMonsterController(Victim.Controller).StatusManager, HitLocation, Momentum, DamageType);
	else if (EventInstigator.Controller != None)
	{
		OtherController = DCMonsterController(EventInstigator.Controller);
		if (OtherController != None)
			return Class'StatusEffectDamageRules'.static.HandleDamage(Damage, EventInstigator, OtherController.StatusManager, Victim, DCMonsterController(Victim.Controller).StatusManager, HitLocation, Momentum, DamageType);
	}
	return Damage;
}

/*static function int AdjustDamage(int Damage, Pawn EventInstigator, Pawn Victim, StatusEffectInventory VictimStatusManager, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
	local DEKPawn Other;
	local StatusEffectInventory EventInstigatorStatusManager;

	Other = DEKPawn(EventInstigator);
	if (Other != None)		//Player dealing damage
		Damage = class'StatusEffectDamageRules'.static.HandleDamage(Damage, Other, Other.StatusManager, Victim, VictimStatusManager, HitLocation, Momentum, DamageType);
	else					//Must be a monster or pet dealing damage
	{
		if (DEKMonster(EventInstigator) != None)
			EventInstigatorStatusManager = DEKMonster(EventInstigator).StatusManager;
		else if (DCAldebaran(EventInstigator) != None)
			EventInstigatorStatusManager = DCAldebaran(EventInstigator).StatusManager;
		else if (Fenrir(EventInstigator) != None)
			EventInstigatorStatusManager = Fenrir(EventInstigator).StatusManager;
		else if (DCBehemoth(EventInstigator) != None)
			EventInstigatorStatusManager = DCBehemoth(EventInstigator).StatusManager;
		else if (DCBrute(EventInstigator) != None)
			EventInstigatorStatusManager = DCBrute(EventInstigator).StatusManager;
		else if (DCChildGasbag(EventInstigator) != None)
			EventInstigatorStatusManager = DCChildGasbag(EventInstigator).StatusManager;
		else if (DCChildPupae(EventInstigator) != None)
			EventInstigatorStatusManager = DCChildPupae(EventInstigator).StatusManager;
		else if (DCDevilFish(EventInstigator) != None)
			EventInstigatorStatusManager = DCDevilFish(EventInstigator).StatusManager;
		else if (DCEliteKrall(EventInstigator) != None)
			EventInstigatorStatusManager = DCEliteKrall(EventInstigator).StatusManager;
		else if (DCFireSkaarj(EventInstigator) != None)
			EventInstigatorStatusManager = DCFireSkaarj(EventInstigator).StatusManager;
		else if (DCGasbag(EventInstigator) != None)
			EventInstigatorStatusManager = DCGasbag(EventInstigator).StatusManager;
		else if (DCGiantGasbag(EventInstigator) != None)
			EventInstigatorStatusManager = DCGiantGasbag(EventInstigator).StatusManager;
		else if (DCGiantRazorfly(EventInstigator) != None)
			EventInstigatorStatusManager = DCGiantRazorfly(EventInstigator).StatusManager;
		else if (DCIceSkaarj(EventInstigator) != None)
			EventInstigatorStatusManager = DCIceSkaarj(EventInstigator).StatusManager;
		else if (DCKrall(EventInstigator) != None)
			EventInstigatorStatusManager = DCKrall(EventInstigator).StatusManager;
		else if (DCManta(EventInstigator) != None)
			EventInstigatorStatusManager = DCManta(EventInstigator).StatusManager;
		else if (DCMercenary(EventInstigator) != None)
			EventInstigatorStatusManager = DCMercenary(EventInstigator).StatusManager;
		else if (DCMercenaryElite(EventInstigator) != None)
			EventInstigatorStatusManager = DCMercenaryElite(EventInstigator).StatusManager;
		else if (DCMetalSkaarj(EventInstigator) != None)
			EventInstigatorStatusManager = DCMetalSkaarj(EventInstigator).StatusManager;
		else if (DCPupae(EventInstigator) != None)
			EventInstigatorStatusManager = DCPupae(EventInstigator).StatusManager;
		else if (DCQueen(EventInstigator) != None)
			EventInstigatorStatusManager = DCQueen(EventInstigator).StatusManager;
		else if (DCRazorfly(EventInstigator) != None)
			EventInstigatorStatusManager = DCRazorfly(EventInstigator).StatusManager;
		else if (DCSkaarj(EventInstigator) != None)
			EventInstigatorStatusManager = DCSkaarj(EventInstigator).StatusManager;
		else if (DCSkaarjTrooper(EventInstigator) != None)
			EventInstigatorStatusManager = DCSkaarjTrooper(EventInstigator).StatusManager;
		else if (DCSlith(EventInstigator) != None)
			EventInstigatorStatusManager = DCSlith(EventInstigator).StatusManager;
		else if (DCStoneTitan(EventInstigator) != None)
			EventInstigatorStatusManager = DCStoneTitan(EventInstigator).StatusManager;
		else if (DCTarantula(EventInstigator) != None)
			EventInstigatorStatusManager = DCTarantula(EventInstigator).StatusManager;
		else if (DCTitan(EventInstigator) != None)
			EventInstigatorStatusManager = DCTitan(EventInstigator).StatusManager;
		else if (DCWarlord(EventInstigator) != None)
			EventInstigatorStatusManager = DCWarlord(EventInstigator).StatusManager;
		Damage = class'StatusEffectDamageRules'.static.HandleDamage(Damage, EventInstigator, EventInstigatorStatusManager, Victim, VictimStatusManager, HitLocation, Momentum, DamageType);
	}
	return Damage;
}
*/

defaultproperties
{
}
