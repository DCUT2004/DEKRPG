class PhantomGhostInv extends Inventory
	config(UT2004RPG);

var Pawn PawnOwner;
var bool stopped;
var int RegenAmount;
var MagicShieldInv Inv;
var config int PhantomLifespan;
var Material ModifierOverlay;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
	reliable if (Role == ROLE_Authority)
		stopped;
}

simulated function GiveTo(Pawn Other, optional Pickup Pickup)
{
	local FatalInv FInv;
	
	if(Other == None)
	{
		destroy();
		return;
	}
	
	FInv = FatalInv(Other.FindInventoryType(class'FatalInv'));
	if (FInv != None)
	{
		PhantomLifespan /= 2;
		RegenAmount *= 2;
	}

	stopped = false;
	PawnOwner = Other;
	
	//Set the Timer
	SetTimer(0.5, true);
	
	//Set GodMode
	SwitchOnInvulnerability();
	
	//Give Magic Shield.
	Inv = MagicShieldInv(PawnOwner.FindInventoryType(class'MagicShieldInv'));
	if (Inv == None)
	{
		Inv = spawn(class'MagicShieldINv', PawnOwner,,, rot(0,0,0));
		Inv.GiveTo(PawnOwner);
	}
	
	Super.GiveTo(Other);
}

simulated function SwitchOnInvulnerability()
{
	PawnOwner.Controller.bGodMode = true;
	PawnOwner.SetCollision(false,false,false);
	PawnOwner.bCollideWorld = true;
	PawnOwner.Mass = 1000.000000;
}

simulated function SwitchOffInvulnerability()
{
	PawnOwner.Controller.bGodMode = false;
	PawnOwner.SetCollision(true,true,true);
	PawnOwner.bCollideWorld = true;
	PawnOwner.Mass = PawnOwner.Default.Mass;
	
	PawnOwner.setOverlayMaterial(ModifierOverlay, 0.5, true);
}

simulated function Timer()
{
	local StatusEffectManager StatusManager;
	Local DamageInv DInv;
	Local InvulnerabilityInv IInv;
	Local Vehicle Vehicle;
	local PlagueInv PlInv;
	
	Vehicle = PawnOwner.DrivenVehicle;
	
	if (Invasion(Level.Game) != None && !Invasion(Level.Game).bWaveInProgress && Invasion(Level.Game).WaveCountDown > 11)
	{
		Destroy();
		return;
	}
	
	if(!stopped)
	{
		PhantomLifespan--;
		if (Owner == None || PawnOwner == None)
		{
			Destroy();
			return;
		}
		if (PawnOwner != None)
		{
			PlayerController(PawnOwner.Controller).ReceiveLocalizedMessage(class'PhantomGhostMessage', 0);
			PlayerController(PawnOwner.Controller).ReceiveLocalizedMessage(class'PhantomGhostTimer', PhantomLifespan/2);
			PawnOwner.setOverlayMaterial(ModifierOverlay, 10, true);
		}
		if (Role == ROLE_Authority)
		{
			if (Invasion(Level.Game) != None && !Invasion(Level.Game).bWaveInProgress && Invasion(Level.Game).WaveCountDown > 11)
			{
				Destroy();
				return;
			}
			if (PhantomLifespan <= 0)
			{
				stopEffect();
			}
			
			if (PawnOwner != None)
			{	
				PawnOwner.GiveHealth(RegenAmount, PawnOwner.HealthMax);

				StatusManager = Class'StatusEffectManager'.static.GetStatusEffectmanager(PawnOwner);
				if (StatusManager != None)
				{
					StatusManager.RemoveAllStatusEffects();
				}
				
				DInv = DamageInv(PawnOwner.FindInventoryType(class'DamageInv'));
				if(DInv != None)
				{
					DInv.SwitchOffDamage();
					DInv.Destroy();
				}	
				IInv = InvulnerabilityInv(PawnOwner.FindInventoryType(class'InvulnerabilityInv'));
				if(IInv != None)
				{
					IInv.SwitchOffInvulnerability();
					IInv.Destroy();
				}
				PlInv = PlagueInv(PawnOwner.FindInventoryType(class'PlagueInv'));
				if(PlInv != None)
				{
					PlInv.Destroy();
				}
			}
		}
	}
}

simulated function Tick(float deltaTime)
{
	local Vehicle V;
	
	if (!stopped)
	{
		if (PawnOwner != None)
		{
			V = PawnOwner.DrivenVehicle;
			if (V != None)
			{
				V.EjectDriver();
			}
		}
	}
}

simulated function stopEffect()
{	
	if(stopped)
		return;
	else
		stopped = true;
	if(PawnOwner != None)
	{
		//Switch off GodMode
		SwitchOffInvulnerability();
		
		//Remove MagicShield
		if (Inv != None)
		{
			Inv.Destroy();
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
     RegenAmount=10
     PhantomLifespan=20
     ModifierOverlay=FinalBlend'DEKMonstersTexturesMaster208.GhostMonsters.InvshadeFB'
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
