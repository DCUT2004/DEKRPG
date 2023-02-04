/*
* StatusEffectInventory is the first child of StatusEffectData that can be instaniated and placed on a Pawn
* StatusEffectInventory contains the logic for doing the effect of each status effect, e.g. adding health
* Status Effects that modify damage are handled separately in StatusEffectGameRules
*/

#exec  AUDIO IMPORT NAME="Ward" FILE="Sounds\Ward.WAV" GROUP="ComboSounds"

class StatusEffectInventory extends StatusEffectManager
	config(UT2004RPG);

var RPGRules Rules;

var config float DamagePercentPerModifier;

//Adren
var int OriginalMaxAdren;
var config int MaxAdrenMaxIncrease;

//Damage-Over-Time
var config float DoTBasePercentage, DoTCurve, DoTMaxAmount;

var config int WardChancePerModifier;

//Emitters
var Array < Actor > Emitters;
var Class<xEmitter> AttackxEmitterClassBuff, AttackxEmitterClassAilment;
var Class<Emitter> DefenseEmitterClassBuff, DefenseEmitterClassAilment;
var Class<Emitter> BurnEmitterClass, MisfortuneEmitterClass;
var Class<xEmitter> RegenxEmitterClass, FreezexEmitterClass;

//Misfortune variables
var config int MisfortuneMaxModifierWeapons, MisfortuneMaxModifierPickups;
var config float MisfortuneRadius;

//Parasite variables
var int ParasiteHealth;
var int ParasiteHealthMax;
var config int StartingParasiteHealth;
var config int ParasiteHealthAddPerModifier;
var config float ParasiteHealthPercentSteal;

//Regen variables
var config int RegenAdditionalHealthMax;

//Freeze variables
var Sound FreezeSound;

static function float GetDamagePercentPerModifier()
{
	return default.DamagePercentPerModifier;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	CheckRPGRules();
}

function CheckRPGRules()
{
	Local GameRules G;

	if (Level.Game == None)
		return;		//try again later

	for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
		if(G.isA('RPGRules'))
		{
			Rules = RPGRules(G);
			break;
		}

	if(Rules == None)
		Log("WARNING: Unable to find RPGRules in GameRules. EXP will not be properly awarded");
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

//Called when a Pawn receives an ailment.
//Return true if Pawn has MagicalWard and successfully blocks the ailment
function bool CheckMagicalWard()
{
	local int x;
	
	for (x = 0; x < StatusEffects.Length; x++)
		if (StatusEffects[x].StatusEffectName == Class'StatusEffect_MagicalWard'.static.GetName() )
			if (Rand(100) <= StatusEffects[x].Modifier*WardChancePerModifier)
			{
				if (OwningPawn != None && OwningPawn.Controller != None && PlayerController(OwningPawn.Controller) != None)
					PlayerController(OwningPawn.Controller).ClientPlaySound(Sound'DEKRPG999X.ComboSounds.Ward');
				return true;
			}
			
	return false;
}

//Called when this Pawn receives a status effect
//bOnStack is true if this Pawn already had this status effect but was instead stacked
function OnAddDoEffect(int EffectIndx, bool bOnStack)
{
	Switch (StatusEffects[EffectIndx].StatusEffectName)
	{
		Case Class'StatusEffect_Burn'.static.GetName():
			SpawnEmitter(BurnEmitterClass, EffectIndx);
			break;
		Case Class'StatusEffect_DamageBonus'.static.GetName():
			if (StatusEffects[EffectIndx].Modifier > 0)
				SpawnEmitter(AttackxEmitterClassBuff, EffectIndx);
			else
				SpawnEmitter(AttackxEmitterClassAilment, EffectIndx);
			break;
		Case Class'StatusEffect_DamageReduction'.static.GetName():
			if (StatusEffects[EffectIndx].Modifier > 0)
				SpawnEmitter(DefenseEmitterClassBuff, EffectIndx);
			else
				SpawnEmitter(DefenseEmitterClassAilment, EffectIndx);
			break;
		Case Class'StatusEffect_Misfortune'.static.GetName():
			SpawnEmitter(MisfortuneEmitterClass, EffectIndx);
			break;
		Case Class'StatusEffect_Regeneration'.static.GetName():
			SpawnEmitter(RegenxEmitterClass, EffectIndx);
			break;
		Case Class'StatusEffect_Speed'.static.GetName():
			if(!class'DEKRPGWeapon'.static.NullCanTriggerPhysics(OwningPawn))
				RemoveStatusEffect(EffectIndx);
			class'AbilityIncreasedProtection'.static.quickfoot(10 * StatusEffects[EffectIndx].Modifier, OwningPawn);
			if (StatusEffects[EffectIndx].Modifier < 0)
				OwningPawn.PlaySound(FreezeSound,,2.5*OwningPawn.TransientSoundVolume,,OwningPawn.TransientSoundRadius);
			break;
		Case Class'StatusEffect_NullEntropy'.static.GetName():
			if (!class'DEKRPGWeapon'.static.NullCanTriggerPhysics(OwningPawn))
				RemoveStatusEffect(EffectIndx);
			if (StatusEffects[EffectIndx].Modifier < 0)
				OwningPawn.setPhysics(PHYS_NONE);
			break;
		Case Class'StatusEffect_Parasite'.static.GetName():
			DoEffect_Parasite(EffectIndx);
			break;
	}
}

function SpawnEmitter(Class<Actor> EmitterClass, int EffectIndx)
{
	local Actor A;
	local Emitter E;
	local xEmitter X;
	local int y;

	//We only want to spawn one instance of an emitter for a status effect
	//Check to see if we have one already

	for (y = 0; y < Emitters.Length; y++)
		if (Emitters[y].Class == EmitterClass)
			return;
	
	A = Spawn(EmitterClass, OwningPawn,, OwningPawn.Location);
	if (A == None)
		return;

	A.bHardAttach = True;
	A.SetBase(OwningPawn);
	Emitters.Insert(0, 1);
	Emitters[0] = A;
	
	E = Emitter(A);
	X = xEmitter(A);
	if (E == None || X == None)
		return;
	
	if (EmitterClass == BurnEmitterClass)
	{
		E.bOwnerNoSee = true;
		E.Emitters[0].LifetimeRange.Min = StatusEffects[EffectIndx].StatusLifespan;
		E.Emitters[0].LifetimeRange.Max = StatusEffects[EffectIndx].StatusLifespan;	
	}
	else if (EmitterClass == AttackxEmitterClassBuff || EmitterClass == AttackxEmitterClassAilment)
	{
		X.mSizeRange[0] = OwningPawn.CollisionRadius * 0.05;
		X.mSizeRange[1] =1.571 * OwningPawn.CollisionRadius * 0.05;	
	}
}

function DestroyEmitter(int Indx)
{
	local Emitter E;
	if (Indx < 0 || Indx >= Emitters.Length)
		return;
	E = Emitter(Emitters[Indx]);
	if (E != None)
		E.Kill();
	Emitters[Indx].Destroy();
	Emitters.Remove(Indx, 1);
}

//Called when a status effect is removed (Lifespan is up, dispelled, etc.)
//E.g. destroy emiiters, reset values, etc.
function OnRemoveDoEffect(int EffectIndx)
{
	local int x;
	
	Switch(StatusEffects[EffectIndx].StatusEffectName)
	{
		Case Class'StatusEffect_Burn'.static.GetName():
			for (x = 0; x < Emitters.Length; x++)
				if (Emitters[x].Class == BurnEmitterClass)
				{
					DestroyEmitter(x);
					break;
				}
			break;
		Case Class'StatusEffect_DamageBonus'.static.GetName():
			for (x = 0; x < Emitters.Length; x++)
				if (Emitters[x].Class == AttackxEmitterClassBuff || Emitters[x].Class == AttackxEmitterClassAilment)
				{
					DestroyEmitter(x);
					break;
				}
			break;
		Case Class'StatusEffect_DamageReduction'.static.GetName():
			for (x = 0; x < Emitters.Length; x++)
				if (Emitters[x].Class == DefenseEmitterClassBuff || Emitters[x].Class == DefenseEmitterClassAilment)
				{
					DestroyEmitter(x);
					break;
				}
			break;
		Case Class'StatusEffect_Misfortune'.static.GetName():
			for (x = 0; x < Emitters.Length; x++)
				if (Emitters[x].Class == MisfortuneEmitterClass)
				{
					DestroyEmitter(x);
					break;
				}
			break;
		Case Class'StatusEffect_Regeneration'.static.GetName():
			for (x = 0; x < Emitters.Length; x++)
				if (Emitters[x].Class == RegenxEmitterClass)
				{
					DestroyEmitter(x);
					break;
				}
			break;
		Case Class'StatusEffect_Speed'.static.GetName():
			class'AbilityIncreasedProtection'.static.quickfoot(0, OwningPawn);
			break;
		Case Class'StatusEffect_NullEntropy'.static.GetName():
			if(OwningPawn != None && OwningPawn.Physics == PHYS_NONE)
				OwningPawn.SetPhysics(PHYS_Falling);
			break;
	}
}

//Called by Timer each second
function OnTimerDoEffect(int EffectIndx)
{
	Switch(StatusEffects[EffectIndx].StatusEffectName)
	{
		Case Class'StatusEffect_AdrenRegen'.static.GetName():
			DoEffect_AdrenRegen(EffectIndx);
			break;
		Case class'StatusEffect_AdrenMax'.static.GetName():
			DoEffect_AdrenMax(EffectIndx);
			break;
		Case Class'StatusEffect_AmmoRegen'.static.GetName():
			DoEffect_AmmoRegen(EffectIndx);
			break;
		Case Class'StatusEffect_Burn'.static.GetName():
			DoEffect_DamageOverTime(EffectIndx);
			break;
		Case Class'StatusEffect_Poison'.static.GetName():
			DoEffect_DamageoverTime(EffectIndx);
			break;
		Case Class'StatusEffect_DamageBonus'.static.GetName():
			DoEffect_DamageBonus(EffectIndx);
			break;
		Case Class'StatusEffect_DamageReduction'.static.GetName():
			DoEffect_DamageReduction(EffectIndx);
			break;
		Case Class'StatusEffect_Misfortune'.static.GetName():
			DoEffect_Misfortune(EffectIndx);
			break;
		Case Class'StatusEffect_Regeneration'.static.GetName():
			DoEffect_Regen(EffectIndx);
			break;
		Case Class'StatusEffect_Speed'.static.GetName():
			DoEffect_Speed(EffectIndx);
			break;
	}
}

function DoEffect_AdrenRegen(int EffectIndx)
{
	if (OwningPawn.IsA('Monster'))		//Monsters have no use for adrenaline
		return;

	if (OwningPawn.Controller == None)
		return;
		
	if (StatusEffects[EffectIndx].Modifier > 0 && OwningPawn.Controller.Adrenaline + StatusEffects[EffectIndx].Modifier > OwningPawn.Controller.AdrenalineMax )
	{
		if (AddStatusEffect(class'StatusEffect_AdrenMax', 1, False));
			OriginalMaxAdren = OwningPawn.Controller.AdrenalineMax;
		OwningPawn.Controller.AdrenalineMax += StatusEffects[EffectIndx].Modifier;
	}
	OwningPawn.Controller.Adrenaline += StatusEffects[EffectIndx].Modifier;
		
	if (OwningPawn.Controller.Adrenaline < 0)
		OwningPawn.Controller.Adrenaline = 0;

	if (PlayerController(OwningPawn.Controller) != None)
		if (StatusEffects[EffectIndx].Modifier > 0)
			PlayerController(OwningPawn.Controller).ClientPlaySound(Sound'PickupSounds.AdrenelinPickup');
		else
			PlayerController(OwningPawn.Controller).ClientPlaySound(Sound'ONSVehicleSounds-S.PowerNode.PwrNodeStartBuild03');
}

//AdrenMax is added when the pawn has AdrenRegen and regens beyond their MaxAdrenaline
//AdrenMax does nothing but check when the pawn consumes adrenaline below their original Max
//AdrenMax is added as a separate status effect, since we want Pawns to keep their temp max adren even when their AdrenRegen effect is over
function DoEffect_AdrenMax(int EffectIndx)
{
	if (OwningPawn.Controller == None)
		return;
	if (OwningPawn.Controller.Adrenaline > OriginalMaxAdren + MaxAdrenMaxIncrease)	//In case combos increase the max adren cap to a high amount, this will limit the max according to MaxMultiplier
		OwningPawn.Controller.Adrenaline = OriginalMaxAdren + MaxAdrenMaxIncrease;
	if (OwningPawn.Controller.Adrenaline < OwningPawn.Controller.AdrenalineMax)	//Continously reset the max adrenaline when the player consumes/loses adrenaline
		OwningPawn.Controller.AdrenalineMax = OwningPawn.Controller.Adrenaline;
	if (OwningPawn.Controller.Adrenaline < OriginalMaxAdren)	//When the current adrenaline falls below the original starting max adren amount, we no longer need this effect
	{
		OwningPawn.Controller.AdrenalineMax = OriginalMaxAdren;
		StatusEffects.Remove(EffectIndx, 1);
	}
}

function DoEffect_AmmoRegen(int EffectIndx)
{
	local Weapon W;
	local int Modifier;
	
	W = OwningPawn.Weapon;
	
	if (W == None || W.IsA('RuneWeapon') || W.IsA('NecromancerBloodWeapon') || W.IsA('NecromancerSoulWeapon') || W.IsA('NecromancerWeapon') )
		return;
		
	Modifier = StatusEffects[EffectIndx].Modifier;
	
	if (W.bNoAmmoInstances && W.AmmoClass[0] != None && !class'MutUT2004RPG'.static.IsSuperWeaponAmmo(W.AmmoClass[0]))
	{
		if (Modifier > 0)
		{
			W.AddAmmo(Modifier * (1 + W.AmmoClass[0].default.MaxAmmo / 100), 0);
			if (W.AmmoClass[0] != W.AmmoClass[1] && W.AmmoClass[1] != None)
				W.AddAmmo(Modifier * (1 + W.AmmoClass[1].default.MaxAmmo / 100), 1);

		}
		else if (Modifier < 0)
		{
			W.ConsumeAmmo(0, -Modifier * (1 + W.AmmoClass[0].default.MaxAmmo / 100));
			if (W.AmmoClass[0] != W.AmmoClass[1] && W.AmmoClass[1] != None)
				W.ConsumeAmmo(1, -Modifier * (1 + W.AmmoClass[1].default.MaxAmmo / 100));
		}
	}
	
	if (OwningPawn.Controller != None && PlayerController(OwningPawn.Controller) != None)
	{
		if (Modifier > 0)
			PlayerController(OwningPawn.Controller).ClientPlaySound(Sound'WeaponSounds.BaseGunTech.BReload9');
		else if (Modifier < 0)
			PlayerController(OwningPawn.Controller).ClientPlaySound(Sound'MenuSounds.MS_Edit');
	}
}

//Poison, Burn, etc.
function DoEffect_DamageOverTime(int EffectIndx)
{
	local int DamageAmount;
	local Pawn Producer;
	
	if (StatusEffects[EffectIndx].Modifier > 0)		//This is an ailment only
		StatusEffects.Remove(EffectIndx, 1);
		
	DamageAmount = int(float(OwningPawn.Health) * (DoTCurve **(abs(StatusEffects[EffectIndx].Modifier)-1)*DoTBasePercentage));
	if (DamageAmount > DoTMaxAmount)
		DamageAmount = DoTMaxAmount;
	if(DamageAmount > 0)
	{
		if(OwningPawn != None && OwningPawn.Controller != None && OwningPawn.Controller.bGodMode == False
			&& InvulnerabilityInv(OwningPawn.FindInventoryType(class'InvulnerabilityInv')) == None)
		{
			if (OwningPawn.Health <= DamageAmount)
				DamageAmount = OwningPawn.Health -1;
			OwningPawn.Health -= DamageAmount;
			
			Producer = StatusEffects[EffectIndx].Producer;
			if(Producer != None && Producer.Controller != None && OwningPawn != Producer) //exp only for harming others.
			{
				if (Rules != None)
					Rules.AwardEXPForDamage(Producer.Controller, RPGStatsInv(Producer.FindInventoryType(class'RPGStatsInv')), OwningPawn, DamageAmount);
				// and add the damage as healable
				class'StatusEffectInventory'.static.AddHealableDamage(DamageAmount, OwningPawn);
			}
			if (StatusEffects[EffectIndx].StatusEffectName == Class'StatusEffect_Burn'.static.GetName())
			{
				if (Level.NetMode != NM_DedicatedServer && OwningPawn != None)
					if (OwningPawn.IsLocallyControlled() && OwningPawn.Controller != None && PlayerController(OwningPawn.Controller) != None)
						PlayerController(OwningPawn.Controller).ReceiveLocalizedMessage(class'SuperHeatConditionMessage', 0);
			}
			else if (StatusEffects[EffectIndx].StatusEffectName == Class'StatusEffect_Poison'.static.GetName())
			{
				OwningPawn.Spawn(Class'GoopSmoke');
				if (Level.NetMode != NM_DedicatedServer && OwningPawn != None)
					if (OwningPawn.IsLocallyControlled() && OwningPawn.Controller != None && PlayerController(OwningPawn.Controller) != None)
						PlayerController(OwningPawn.Controller).ReceiveLocalizedMessage(class'PoisonBlastConditionMessage', 0);
			}
		}
	}
}

function DoEffect_DamageBonus(int EffectIndx)
{
	local int x;
	
	for (x = 0; x < Emitters.Length; x++)
	{
		if (StatusEffects[EffectIndx].Modifier > 0 && Emitters[x].Class == AttackxEmitterClassAilment)		//Change xEmitter to buff
		{
			DestroyEmitter(x);
			SpawnEmitter(AttackxEmitterClassBuff, EffectIndx);
			break;
		}
		else if (StatusEffects[EffectIndx].Modifier < 0 && Emitters[x].Class == AttackxEmitterClassBuff)	//Change xEmitter to ailment
		{
			DestroyEmitter(x);
			SpawnEmitter(AttackxEmitterClassAilment, EffectIndx);
			break;
		}
	}
}

function DoEffect_DamageReduction(int EffectIndx)
{
	local int x;
	
	for (x = 0; x < Emitters.Length; x++)
	{

		if (StatusEffects[EffectIndx].Modifier > 0 && Emitters[x].Class == DefenseEmitterClassAilment)		//Change Emitter to buff
		{
			DestroyEmitter(x);
			SpawnEmitter(DefenseEmitterClassBuff, EffectIndx);
			break;
		}
		else if (StatusEffects[EffectIndx].Modifier < 0 && Emitters[x].Class == DefenseEmitterClassBuff)	//Change Emitter to ailment
		{
			DestroyEmitter(x);
			SpawnEmitter(DefenseEmitterClassAilment, EffectIndx);
			break;
		}
	}	
}

function DoEffect_Misfortune(int EffectIndx)
{
	local Pickup P;
	
	if (StatusEffects[EffectIndx].Modifier >= 0)
	{
		RemoveStatusEffect(EffectIndx);
		return;
	}

	foreach OwningPawn.CollidingActors(class'Pickup', P, MisfortuneRadius)
	if ( P.ReadyToPickup(0) && WeaponLocker(P) == None )
	{
		if (-StatusEffects[EffectIndx].Modifier >= -MisfortuneMaxModifierPickups && P.IsA('AdrenalinePickup') || ClassIsChildOf(P.Class, Class'TournamentHealth') || ClassIsChildOf(P.Class, Class'ShieldPickup') )
			DestroyPickup(P);
		else if (-StatusEffects[EffectIndx].Modifier >= -MisfortuneMaxModifierWeapons && P.IsA('AdrenalinePickup') || ClassIsChildOf(P.Class, Class'TournamentHealth') || ClassIsChildOf(P.Class, Class'ShieldPickup') || P.IsA('WeaponPickup') || P.IsA('UDamagePack'))
			DestroyPickup(P);
		else if ( P.IsA('AdrenalinePickup') || ClassIsChildOf(P.Class, Class'TournamentHealth') || ClassIsChildOf(P.Class, Class'ShieldPickup') || P.IsA('WeaponPickup') || P.IsA('UDamagePack') || P.IsA('RPGArtifactPickup'))
			DestroyPickup(P);
	}
	OwningPawn.ReceiveLocalizedMessage(class'MisfortuneMessage');
}

function DestroyPickup(Pickup P)
{
	local Actor A;
	
	if (!P.bDropped && WeaponPickup(P) != None && WeaponPickup(P).bWeaponStay && P.RespawnTime != 0.0)
		P.GotoState('Sleeping');
	else
		P.SetRespawn();
		
	A = spawn(class'RocketExplosion',,, P.Location);
	if (A != None)
	{
		A.RemoteRole = ROLE_SimulatedProxy;
		A.PlaySound(sound'WeaponSounds.BExplosion3',,2.5*P.TransientSoundVolume,,P.TransientSoundRadius);
	}
}

function DoEffect_Parasite(int EffectIndx)
{
	SetParasiteHealthMax(EffectIndx);
	if (ParasiteHealth > 0)
		AddParasiteHealth(StatusEffects[EffectIndx].Modifier * ParasiteHealthAddPerModifier);
	else
		ParasiteHealth = ParasiteHealthMax;
}

function SetParasiteHealthMax(int EffectIndx)
{
	ParasiteHealthMax = (abs(StatusEffects[EffectIndx].Modifier) + 3 )/10.0 * OwningPawn.HealthMax;
}

function AddParasiteHealth(int Amount)
{
	ParasiteHealth = Min(ParasiteHealthMax, ParasiteHealth+abs(Amount));
}

function int RemoveParasiteHealth(int Amount, int Index)
{
	local int ParasiteStealAmount;

	ParasiteStealAmount = Amount*ParasiteHealthPercentSteal;
	ParasiteHealth -= ParasiteStealAmount;
	if (ParasiteHealth <= 0)
		RemoveStatusEffect(Index);
	return Max(0, Amount - ParasiteStealAmount);
}

function DoEffect_Regen(int EffectIndx)
{
	if (OwningPawn.IsA('Monster'))
		OwningPawn.GiveHealth(StatusEffects[EffectIndx].Modifier*2, OwningPawn.HealthMax + RegenAdditionalHealthMax);
	else
		OwningPawn.GiveHealth(StatusEffects[EffectIndx].Modifier, OwningPawn.HealthMax + RegenAdditionalHealthMax);
	if (OwningPawn.Controller != None && PlayerController(OwningPawn.Controller) != None)
		PlayerController(OwningPawn.Controller).ClientPlaySound(Sound'PickupSounds.HealthPack');
}

function DoEffect_Speed(int EffectIndx)
{
	if(!class'DEKRPGWeapon'.static.NullCanTriggerPhysics(OwningPawn))
		RemoveStatusEffect(EffectIndx);
	if (StatusEffects[EffectIndx].Modifier < 0)
		OwningPawn.Spawn(FreezexEmitterClass, OwningPawn,, OwningPawn.Location, OwningPawn.Rotation);
	if (Level.NetMode != NM_DedicatedServer && OwningPawn != None)
		if (OwningPawn.IsLocallyControlled() && OwningPawn.Controller != None && PlayerController(OwningPawn.Controller) != None)
			PlayerController(OwningPawn.Controller).ReceiveLocalizedMessage(class'FreezeConditionMessage', 0);
}

defaultproperties
{
	DamagePercentPerModifier=0.02000
	
    DoTBasePercentage=0.050000
	DoTCurve=1.300000
	DoTMaxAmount=100.000
	WardChancePerModifier=10
	
	MaxAdrenMaxIncrease=100
	
	BurnEmitterClass=Class'DEKRPG999X.SuperHeatFX'
	
	AttackxEmitterClassBuff=Class'DEKRPG999X.ComboAttackUpEffect'
	AttackxEmitterClassAilment=Class'DEKRPG999X.ComboAttackDownEffect'
	
	DefenseEmitterClassBuff=Class'DEKRPG999X.ComboDefenseUpEffect'
	DefenseEmitterClassAilment=Class'DEKRPG999X.ComboDefenseDownEffect'
	
	MisfortuneMaxModifierPickups=1		//Modifier must be 1 to destroy pickups
	MisfortuneMaxModifierWeapons=2		//Modifier must be 2 to destroy pickups and weapons; 3 to destroy all the above and artifacts
	MisfortuneEmitterClass=Class'DEKRPG999X.MisfortuneEffect'
	
	StartingParasiteHealth=200					//Parasite starting health
	ParasiteHealthAddPerModifier=50		//If a player already has a Parasite, and the same effect gets applied (i.e. stacked), how much health per modifier to add to parasite
	ParasiteHealthPercentSteal=0.500	//When a player is healed and has a parasite, how much % of the healing is stolen
	
	RegenAdditionalHealthMax=100		//Regen buff will heal beyond max health by this amount
	RegenxEmitterClass=Class'XEffects.RegenCrosses'
	
	FreezexEmitterClass=Class'DEKRPG999X.IceSmoke'
	FreezeSound=Sound'Slaughtersounds.Machinery.Heavy_End'

	MisfortuneRadius=400.00
}
