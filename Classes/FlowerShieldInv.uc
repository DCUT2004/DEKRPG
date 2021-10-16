class FlowerShieldInv extends Inventory;

var Pawn PawnOwner;
var config float Interval;
var config float HealRadius;
var config float HealAmount, MaxHealAmount;
var config float MaxLifespan;
var FlowerShieldFX FX;
var Material EffectOverlay;
var float EXPMultiplier;
var RPGRules Rules;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
}

function PreBeginPlay()
{
	local GameRules G;
	Local HealableDamageGameRules SG;
	super.PreBeginPlay();

	if (Level.Game == None)
		return;

	if ( Level.Game.GameRulesModifiers == None )
	{
		SG = Level.Game.Spawn(class'HealableDamageGameRules');
		if(SG == None)
			log("Warning: Unable to spawn HealableDamageGameRules for Sphere of healing. EXP for Healing will not occur.");
		else
			Level.Game.GameRulesModifiers = SG;
	}
	else
	{
		for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
		{
			if(G.isA('HealableDamageGameRules'))
			{
				SG = HealableDamageGameRules(G);
				break;
			}
			if(G.NextGameRules == None)
			{
				SG = Level.Game.Spawn(class'HealableDamageGameRules');
				if(SG == None)
				{
					log("Warning: Unable to spawn HealableDamageGameRules for Sphere of healing. Healing for EXP will not occur.");
					return; //try again next time?
				}

				//this will also add it after UT2004RPG, which will be necessary.
				Level.Game.GameRulesModifiers.AddGameRules(SG);
				break;
			}
		}
	}
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	CheckRPGRules();
}

function CheckRPGRules()
{
	Local GameRules G;

	if (Level.Game == None)
		return;		//try again later

	for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
	{
		if(G.isA('RPGRules'))
		{
			Rules = RPGRules(G);
			break;
		}
	}

	if(Rules == None)
		Log("WARNING: Unable to find RPGRules in GameRules. EXP will not be properly awarded");
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	if (Other != None)
		PawnOwner = Other;
	SetTimer(Interval,True);
	FX = PawnOwner.Spawn(class'FlowerShieldFX');
	if (FX != None)
	{
		FX.SetBase(PawnOwner);
		FX.RemoteRole = ROLE_SimulatedProxy;
	}
	Super.GiveTo(Other);
}

function Timer()
{
	Local Controller C;

	if (HealAmount > MaxHealAmount)
		HealAmount = MaxHealAmount;
	if (Lifespan > MaxLifespan)
		Lifespan = MaxLifespan;
		
	if (FX == None)
	{
		FX = PawnOwner.Spawn(class'FlowerShieldFX');
		if (FX != None)
		{
			FX.SetBase(PawnOwner);
			FX.RemoteRole = ROLE_SimulatedProxy;
		}
	}
	
	C = Level.ControllerList;
	while (C != None)
	{
		// loop round finding all players on same team
		if ( C.Pawn != None && C.Pawn.Health > 0 && C.SameTeamAs(Instigator.Controller)
			 && VSize(C.Pawn.Location - PawnOwner.Location) <= HealRadius && HardCoreInv(C.Pawn.FindInventoryType(class'HardCoreInv')) == None && PhantomDeathGhostInv(C.Pawn.FindInventoryType(class'PhantomDeathGhostInv')) == None )
		{
			if (C.Pawn == PawnOwner)
				PlayerController(C).ReceiveLocalizedMessage(class'FlowerShieldMessage', 0);
			if (C.Pawn.ShieldStrength < C.Pawn.GetShieldStrengthMax())
			{
				C.Pawn.AddShieldStrength((HealAmount * C.Pawn.GetShieldStrengthMax())/100.0);
				C.Pawn.PlaySound(sound'PickupSounds.ShieldPack',, 0.75 * C.Pawn.TransientSoundVolume,, 0.75 * C.Pawn.TransientSoundRadius);
				if (C.Pawn != PawnOwner)
				{
					PlayerController(C).ReceiveLocalizedMessage(class'FlowerShieldMessage', 0);
					if(C != None && !C.isA('DEKFriendlyMonsterController'))
						doHealed((HealAmount * C.Pawn.GetShieldStrengthMax())/100.0, C.Pawn);	// no exp for healing pets
				}
				C.Pawn.SetOverlayMaterial(EffectOverlay, 0.5, false);
			}
		}
		C = C.NextController;
	}
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
			StatsInv = RPGStatsInv(Instigator.FindInventoryType(class'RPGStatsInv'));
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
	
	MiInv = MissionInv(Instigator.FindInventoryType(class'MissionInv'));
	M1Inv = Mission1Inv(Instigator.FindInventoryType(class'Mission1Inv'));
	M2Inv = Mission2Inv(Instigator.FindInventoryType(class'Mission2Inv'));
	M3Inv = Mission3Inv(Instigator.FindInventoryType(class'Mission3Inv'));
	
	if (ValidHealthGiven > 0)
	{
		if (Instigator != None && Instigator != Victim && MiInv != None && !MiInv.LifeMendComplete)
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

simulated function destroyed()
{
	if (FX != None)
	{
		FX.Destroy();
	}
	Super.Destroyed();
}

defaultproperties
{
     Interval=1.000000
     HealRadius=600.000000
     HealAmount=3.000000
     MaxHealAmount=10.000000
     MaxLifespan=20.000000
     EffectOverlay=Shader'DEKRPGTexturesMaster209B.fX.PulseYellowShader1'
     EXPMultiplier=0.030000
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
     LifeSpan=10.000000
}
