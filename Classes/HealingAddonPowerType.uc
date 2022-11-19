class HealingAddonPowerType extends AddonPowerType
	config(UT2004RPG);

var config float HealingPercent;

static function bool AllowedFor(Weapon W)
{
	// In theory ought to only allow healing in on projectile weapons for non-team games.
	// however, at the moment can't work out if a team game in a static function
	// so ignore for the moment
	if (W == None)
		return false;

	if
	(
		(
			W.default.FireModeClass[0] != None && 
			W.default.FireModeClass[0].default.AmmoClass != None && 
			W.default.AmmoClass[0] != None &&
			W.default.AmmoClass[0].default.MaxAmmo > 0 &&
			class'MutUT2004RPG'.static.IsSuperWeaponAmmo(W.default.FireModeClass[0].default.AmmoClass)
		) ||
		(
			W.default.FireModeClass[1] != None && 
			W.default.FireModeClass[1].default.AmmoClass != None && 
			W.default.AmmoClass[1] != None &&
			W.default.AmmoClass[1].default.MaxAmmo > 0 &&
			class'MutUT2004RPG'.static.IsSuperWeaponAmmo(W.default.FireModeClass[1].default.AmmoClass)
		)
	)
		return false;
		
	if(instr(caps(W), "TRANSLAUNCHER") > -1)
		return false;	
	
	if(instr(caps(W), "MERCURY") > -1)
		return false;		

	if(instr(caps(W), "MEGABLAST") > -1)
		return false;		

	return true;
}

function AdjustDamage(out int Damage, int OriginalDamage, Actor Victim, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
	local Pawn P;

	Super.AdjustDamage(Damage, OriginalDamage, Victim, HitLocation, Momentum, DamageType);

	if (Pawn(Victim) == None)
		return;
	P = Pawn(Victim);

	if (TheWeapon.Instigator == None || P == None)
		return;

	if (P.GetTeam() != TheWeapon.Instigator.GetTeam() || TheWeapon.Instigator.GetTeam() == None)
		return;		// different team

	// we are going to heal this Victim, so set Damage to best of Damage and OriginalDamage
	Damage = Max(Damage, OriginalDamage);	
}

// DoPowerEffect - use the damage here (e.g. energy vampire etc)
function DoPowerEffect(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	local Pawn P;
	local XPawn xP;
	local int HealthGiven;
	local int localMaxHealth;
	local StatusEffectInventory StatusInv;
	local int ParasiteIndex;

	Super.DoPowerEffect(Damage, Victim, HitLocation, Momentum, DamageType);

	if (Pawn(Victim) == None)
		return;
	P = Pawn(Victim);

	if (TheWeapon.Instigator == None || P == None)
		return;

	if (P.GetTeam() != TheWeapon.Instigator.GetTeam() || TheWeapon.Instigator.GetTeam() == None)
		return;		// different team

	if (P.isA('Vehicle'))
		P = Vehicle(P).Driver;
	if (P == None)
		return;
	
	HealthGiven = 0;
	if (Damage > 0 && TheWeapon.Instigator != None)
	{
		localMaxHealth = TheWeapon.getMaxHealthBonus();
		// limit if booster in progress
		xP = xPawn(P);
		if ( xP != None && xP.CurrentCombo != None && xP.CurrentCombo.Name == 'ComboDefensive' )
			localMaxHealth = class'RW_Healer'.default.MaxHealth;	// in booster, lets not mess it up

		if ( P == TheWeapon.Instigator || (P.GetTeam() == TheWeapon.Instigator.GetTeam() && TheWeapon.Instigator.GetTeam() != None) )
		{
			HealthGiven = Max(1, Damage * ((HealingPercent/100.0) * TheWeapon.GetModifier() *PerformanceIncrease));
			
			HealthGiven = Min((P.HealthMax + localMaxHealth) - P.Health, HealthGiven );
				
			if(HardCoreInv(P.FindInventoryType(class'HardCoreInv')) != None && P != TheWeapon.Instigator)
					HealthGiven = 0;

			StatusInv = StatusEffectInventory(P.FindInventoryType(Class'StatusEffectInventory'));
			if (StatusInv != None)
			{
				ParasiteIndex = StatusInv.GetStatusEffectIndex(class'StatusEffect_Parasite'.static.GetName());
				if (ParasiteIndex >= 0)
				{
					if (StatusInv.ParasiteHealth > 0)
					{
						if (StatusInv.ParasiteHealth > HealthGiven)
						{
							StatusInv.RemoveParasiteHealth(HealthGiven);
							HealthGiven = 0;
						}
						else
						{
							HealthGiven -= StatusInv.ParasiteHealth;
							StatusInv.ParasiteHealth = 0;
						}
					}
				}
			}

            if(HealthGiven > 0)
			{
				P.GiveHealth(HealthGiven, P.HealthMax + localMaxHealth);
				P.SetOverlayMaterial(PowerOverlay, 1.0, false);
				TheWeapon.doHealed(HealthGiven, P, localMaxHealth);
				CheckMissionLifeMend(HealthGiven, P);
			}

			Momentum = vect(0,0,0);
			Damage = 0;
		}
	}

	if (HealthGiven > 0 && PlayerController(P.Controller) != None)	
	{
		PlayerController(P.Controller).ReceiveLocalizedMessage(class'HealedConditionMessage', 0, TheWeapon.Instigator.PlayerReplicationInfo);

		P.PlaySound(sound'PickupSounds.HealthPack',, 2 * P.TransientSoundVolume,, 1.5 * P.TransientSoundRadius);
		
		P.spawn(class'DEKEffectHealer', P,, P.Location, P.Rotation); 		
	}
}

simulated function CheckMissionLifeMend(int ValidHealthGiven, Pawn Victim)
{
	local MissionInvBETA MissionInv;
	
	if (ValidHealthGiven <= 0)
		return;

	if (TheWeapon.Instigator == None || TheWeapon.Instigator.Controller == None || TheWeapon.Instigator == Victim)
		return;

	MissionInv = class'MissionInvBETA'.static.GetMissionInv(TheWeapon.Instigator.Controller);
	if (MissionInv == None)
		return;
		
	if (!MissionInv.IsMissionActive("Life Mend"))
		return;
	MissionInv.TickMission(MissionInv.GetMissionIndex("Life Mend"), ValidHealthGiven);
}

function bool CanCoexist( class<AddonPowerType> NewType )
{
	if (!Super.CanCoexist(NewType ))
		return false;

	// Put in a test for rage Power type, and bounce
	if (NewType == class'RageAddonPowerType')
		return false;
	return true;
}

defaultproperties
{
	HealingPercent=3.0
	PosName="Healing"
	ZeroName="Healing"
	NegName="Healing"
	CanHaveZeroModifier=false
	CanHaveNegativeModifier=false
	AIBonus=0.1
	PowerOverlay=Shader'UTRPGTextures2.Overlays.PulseBlueShader1'
	ThisPickupClass=Class'HealingAddonPowerPickup'
}

