class NecroInv extends Inventory;

var RPGRules Rules;
var RPGStatsInv StatsInv;
var MutUT2004RPG RPGMut;
var int BeginningXP, EndingXP;

var Pawn PawnOwner;
var bool PhantomDeath;

var Material ModifierOverlay;

var bool stopped;
var Controller NecromancerController;
var class<DamageType> NecroDamageType;
var config float XPMultiplier;
var int TimeCounter;
var ArtifactResurrect AR;
var sound RevenantSound;

var bool bVampireResurrect, bPowerResurrect;
var config float VampirePerc, PowerPerc;

#exec OBJ LOAD FILE=..\Textures\DEKMonstersTexturesMaster208.utx
#exec OBJ LOAD FILE=..\Textures\H_E_L_Ltx.utx


replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner, NecromancerController;
	reliable if (Role == ROLE_Authority)
		stopped,TimeCounter,PhantomDeath, bVampireResurrect, VampirePerc, bPowerResurrect, PowerPerc;
}

simulated function PostBeginPlay()
{
	local Mutator m;

	if (Level.Game != None)
		for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
			if (MutUT2004RPG(m) != None)
			{
				RPGMut = MutUT2004RPG(m);
				break;
			}
		
	CheckRPGRules();
	bVampireResurrect=False;
	bPowerResurrect=False;
	Super.PostBeginPlay();
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
	if(Other == None)
	{
		destroy();
		return;
	}

	stopped = false;

	PawnOwner = Other;
	
	if (PawnOwner != None)
	{
		StatsInv = RPGStatsInv(PawnOwner.FindInventoryType(class'RPGStatsInv'));	//Must come before SwitchOnInvul
		
		SwitchOnInvulnerability();
	
		if (PawnOwner.PlayerReplicationInfo != None)
			PawnOwner.PlayerReplicationInfo.bOutOfLives = False;
	
		AR = ArtifactResurrect(NecromancerController.Pawn.FindInventoryType(class'ArtifactResurrect'));
		
		SetTimer(0.5, true);
		
		PawnOwner.AmbientSound = RevenantSound;
	}
	
	Super.GiveTo(Other);
}

simulated function SwitchOnInvulnerability()
{
	if (PawnOwner.Controller != None)
	{
		PawnOwner.Controller.bGodMode = true;
		PawnOwner.Spawn(class'ReviveEffectB', PawnOwner,, PawnOwner.Location, PawnOwner.Rotation);
		PawnOwner.PlaySound(Sound'DDAverted', SLOT_None, 400.0);
		PawnOwner.Controller.Adrenaline = PawnOwner.Controller.AdrenalineMax;
		
		if (StatsInv != None)
			BeginningXP = StatsInv.DataObject.Experience;
	}
}

function SwitchOffInvulnerability()
{
	if (PawnOwner != None)
	{
		if (PawnOwner.Controller != None)
			PawnOwner.Controller.bGodMode = false;
		PawnOwner.setOverlayMaterial(ModifierOverlay, 10, true);
		
		if (StatsInv != None)
			EndingXP = StatsInv.DataObject.Experience;
		RewardXP();
	}
}

function SendBackToGrave()
{
	local Controller C;
	local ArtifactResurrect ARLocal;
	
	if (PawnOwner != None && PawnOwner.Controller != None)
	{
		PawnOwner.Controller.bGodMode = false;
		PawnOwner.Died(NecromancerController, NecroDamageType, PawnOwner.Location);
	}
	C = Level.ControllerList;
	while (C != None)
	{
		if (C != None && NecromancerController != None && C.SameTeamAs(NecromancerController) && C.Pawn != None && C.Pawn.Health > 0)
		{
			ARLocal = ArtifactResurrect(C.Pawn.FindInventoryType(class'ArtifactResurrect'));
			if (ARLocal != None)
				ARLocal.SetRecoveryTime(ARLocal.TimeBetweenUses*ARLocal.AdrenalineUsage);
		}
		C = C.NextController;
	}
	Destroy();
}

function RewardXP()
{
	local float XPGained;
	
	XPGained = (EndingXP - BeginningXP);
	if (XPGained < 0)	//Player must have leveled up
	{
		if (StatsInv != None)
		{
			XPGained = abs((StatsInv.DataObject.NeededExp - BeginningXP) + EndingXP);	//Not entirely correct since NeededExp may differ now that player has leveled
		}
	}
	if (XPGained > 0 && NecromancerController != None && NecromancerController.Pawn != None)
	{
		if (Rules != None)
		{
			Rules.ShareExperience(RPGStatsInv(NecromancerController.Pawn.FindInventoryType(class'RPGStatsInv')), XPGained);
		}
	}
}

simulated function Timer()
{
	Local Vehicle Vehicle;
	local PhantomDeathGhostInv PInv;
	
	Vehicle = PawnOwner.DrivenVehicle;
	
	if (AR != None)
	{
		TimeCounter = AR.RevenantLifespan;
	}
	
	if(!stopped)
	{
		TimeCounter--;
		if (PawnOwner != None)
		{
			PawnOwner.ReceiveLocalizedMessage(class'NecroConditionMessage', 0);
			PawnOwner.ReceiveLocalizedMessage(class'NecroTimerMessage', Lifespan);
		}
		if (NecromancerController != None && NecromancerController.Pawn != None)
		{
			PInv = PhantomDeathGhostInv(NecromancerController.Pawn.FindInventoryType(class'PhantomDeathGhostInv'));
			if (PInv != None && !PInv.Stopped)
				if (Vehicle != None)
				{
					Vehicle.EjectDriver();
					SendBackToGrave();
					return;
				}
				else
				{
					SendBackToGrave();
					return;
				}
		}
		if (Role == ROLE_Authority)
		{
			if(LifeSpan <= 0.5)
			{
				if (Invasion(Level.Game) != None)
				{
					if (!PhantomDeath)
					{
						if(Vehicle != None)
						{
							Vehicle.EjectDriver();
							SendBackToGrave();
							return;
							
						}
						else
						{
							SendBackToGrave();
							return;
						}
					}
					else
					{
						if(Vehicle != None)
						{
							Vehicle.EjectDriver();
							Destroy();
							return;
							
						}
						else
						{
							Destroy();
							return;
						}
					}
				}
				else
				{
					Destroy();
					return;
				}
			}

			if (Owner == None)
			{
				Destroy();
				return;
			}
			
			if (NecromancerController == None || NecroMancerController.Pawn.Health <= 0)
			{
				if (Invasion(Level.Game) != None)
				{
					if (!PhantomDeath)
					{
						if(Vehicle != None)
						{
							Vehicle.EjectDriver();
							SendBackToGrave();
							return;
							
						}
						else
						{
							SendBackToGrave();
							return;
						}
					}
					else
					{
						if(Vehicle != None)
						{
							Vehicle.EjectDriver();
							Destroy();
							return;
							
						}
						else
						{
							Destroy();
							return;
						}
					}
				}
				else
				{
					Destroy();
					return;
				}
			}
			
			if (!Invasion(Level.Game).bWaveInProgress && Invasion(Level.Game).WaveCountDown > 1)
			{
					if(Vehicle != None)
					{
						Vehicle.EjectDriver();
						SendBackToGrave();
						return;
					}
					else
					{
						Destroy();
						return;
					}
			}

			if(PawnOwner != None)		//change from else if to if - 3/28/20 208A
			{
				class'AbilityIncreasedProtection'.static.quickfoot(-7, PawnOwner);
				PawnOwner.setOverlayMaterial(ModifierOverlay, LifeSpan, true);
			}
		}
	}
}

function stopEffect()
{
	local PhantomDeathGhostInv PInv;
	
	if(stopped)
		return;
	else
		stopped = true;
	if (NecromancerController != None)
	{
		if (Invasion(Level.Game) != None)
		{
			NecromancerController.PlayerReplicationInfo.Score += 10;	//even out the score for "team killing"
		}
		else //Probably Freon or Monster Assault
		{
			NecromancerController.PlayerReplicationInfo.Score += 1;
		}
	}
	if(PawnOwner != None)
	{
		class'AbilityIncreasedProtection'.static.quickfoot(0, PawnOwner);
		SwitchOffInvulnerability();
		PawnOwner.AmbientSound = None;
		if (PhantomDeath)	//Return this player back to his phantom state
		{
			PInv = PhantomDeathGhostInv(PawnOwner.FindInventoryType(class'PhantomDeathGhostInv'));
			if (PInv != None)
				PInv.Destroy();
			PInv = PawnOwner.Spawn(class'PhantomDeathGhostInv', PawnOwner);
			PInv.GiveTo(PawnOwner);
			class'AbilityIncreasedProtection'.static.quickfoot(0, PawnOwner);
		}
	}
}

simulated function destroyed()
{
	stopEffect();
	super.destroyed();
}

defaultproperties
{
     ModifierOverlay=Shader'AWGlobal.Shaders.FlowingBlood02'
     NecroDamageType=Class'DEKRPG999X.DamTypeNecroSuicide'
     XPMultiplier=1.000000
     RevenantSound=Sound'GeneralAmbience.tortureloop3'
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
