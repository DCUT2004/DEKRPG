class DruidHealthRegenInv extends Inventory;

var int RegenAmount;
var int RegenTime;
var int HealthMaxPlus;
var RPGRules Rules;
var float EXPMultiplier;
var Controller InvPlayerController;
var bool ShamanActivated;
var config int ShamanMinHealth;

var int CountDown;
var Material EffectOverlay;

function PostBeginPlay()
{
	SetTimer(1.0, true);
	
	CountDown = RegenTime;	// since healing twice a second

	Super.PostBeginPlay();
}

function Timer()
{
	Local int HealthGiven;
	local Pawn P;

	if ((Owner == None) || (Pawn(Owner) == None) ||  Pawn(Owner).Health <= 0 || Pawn(Owner).Controller == None 
		|| InvPlayerController == None || InvPlayerController.Pawn == None)
	{	// got problems. If dead not much point trying to heal
		Destroy();
		return;
	}
	P = Pawn(Owner);
	
	CountDown--;
	if (CountDown <= 0)
	{
		// finish our healing time
		Destroy();
		return;
	}
	
	if (Vehicle(P) != None)
		return;		// only works if driving a vehicle. But don't destroy, just pause.
		
	HealthGiven =
		Min
		(
			(P.HealthMax + HealthMaxPlus) - P.Health,
			RegenAmount
		);
	
	if(HealthGiven > 0)
	{
		P.GiveHealth(HealthGiven, P.HealthMax + HealthMaxPlus);
		P.SetOverlayMaterial(EffectOverlay, 0.5, false);
		if(P.Controller != None && !P.Controller.isA('DEKFriendlyMonsterController'))
			doHealed(HealthGiven, P);	// no exp for healing pets

		if(PlayerController(P.Controller) != None)	
		{
			PlayerController(P.Controller).ReceiveLocalizedMessage(class'HealedConditionMessage', 0, InvPlayerController.Pawn.PlayerReplicationInfo);
	
			P.PlaySound(sound'PickupSounds.HealthPack',, 2 * P.TransientSoundVolume,, 1.5 * P.TransientSoundRadius);
		}
		if (ShamanActivated)	//This niche sacrifices their HP to help others
		if (InvPlayerController.Pawn.Health > default.ShamanMinHealth)	//Keep a minimum on
			InvPlayerController.Pawn.Health -= HealthGiven;
	}

	//dont call super. Bad things will happen.
}

//this function does no healing. it serves to figure out the correct amount of exp to grant to the player, and grants it.
function doHealed(int HealthGiven, Pawn Victim)
{
	Local HealableDamageInv Inv;
	local int ValidHealthGiven;
	local float GrantExp;
	local RPGStatsInv StatsInv;
	
	Inv = HealableDamageInv(Victim.FindInventoryType(class'HealableDamageInv'));
	if(Inv != None)
	{
		ValidHealthGiven = Min(HealthGiven, Inv.Damage);
		if(ValidHealthGiven > 0)
		{
			StatsInv = RPGStatsInv(InvPlayerController.Pawn.FindInventoryType(class'RPGStatsInv'));
			if (StatsInv == None)
			{
				log("Warning: No stats inv found. Healing exp not granted.");
				return;
			}

			GrantExp = EXPMultiplier * float(ValidHealthGiven);

			Inv.Damage -= ValidHealthGiven;
			
			Rules.ShareExperience(StatsInv, GrantExp);
		}

		//help keep things in check so a player never has surplus damage in storage.
		if(Inv.Damage > (Victim.HealthMax + Class'HealableDamageGameRules'.default.MaxHealthBonus) - Victim.Health)
			Inv.Damage = Max(0, (Victim.HealthMax + Class'HealableDamageGameRules'.default.MaxHealthBonus) - Victim.Health); //never let it go negative.
	}
	CheckMissionLifeMend(ValidHealthGiven, Victim);
}

simulated function CheckMissionLifeMend(int ValidHealthGiven, Pawn Victim)
{
	local MissionInv MiInv;
	local Mission1Inv M1Inv;
	local Mission2Inv M2Inv;
	local MIssion3Inv M3Inv;
	
	if (InvPlayerController != None && InvPlayerController.Pawn != None)
	{
		MiInv = MissionInv(InvPlayerController.Pawn.FindInventoryType(class'MissionInv'));
		M1Inv = Mission1Inv(InvPlayerController.Pawn.FindInventoryType(class'Mission1Inv'));
		M2Inv = Mission2Inv(InvPlayerController.Pawn.FindInventoryType(class'Mission2Inv'));
		M3Inv = Mission3Inv(InvPlayerController.Pawn.FindInventoryType(class'Mission3Inv'));
		
		if (ValidHealthGiven > 0)
		{
			if (InvPlayerController != None && InvPlayerController != Victim && MiInv != None && !MiInv.LifeMendComplete)
			{
				if (M1Inv != None && !M1Inv.Stopped && M1Inv.LifemendActive)
				{
					M1Inv.MissionCount += ValidHealthGiven;
				}
				if (M2Inv != None && !M2Inv.Stopped && M2Inv.LifemendActive)
				{
					M2Inv.MissionCount += ValidHealthGiven;
				}
				if (M3Inv != None && !M3Inv.Stopped && M3Inv.LifemendActive)
				{
					M3Inv.MissionCount += ValidHealthGiven;
				}
				else
					return;
			}
		}
	}
}

defaultproperties
{
     RegenAmount=10
     RegenTime=30
     HealthMaxPlus=150
     EXPMultiplier=0.030000
     ShamanMinHealth=50
     EffectOverlay=Shader'UTRPGTextures2.Overlays.PulseBlueShader1'
}
