class FreezeInv extends Inventory;

var Controller InstigatorController;
var Pawn PawnOwner;
var int Modifier;

var class <xEmitter> FreezeEffectClass;
var Material ModifierOverlay;

var bool stopped;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
	reliable if (Role == ROLE_Authority)
		stopped;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (Instigator != None)
		InstigatorController = Instigator.Controller;

	SetTimer(0.5, true);
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	local Pawn OldInstigator;
	local NecroInv NInv;
	local MissionInv MiInv;
	local Mission1Inv M1Inv;
	local Mission2Inv M2Inv;
	local MIssion3Inv M3Inv;
	local RW_MagicalWard W;
	local MagicalWardProtectionInv MWInv;
	local ComboWardInv WardInv;

	if(Other == None)
	{
		destroy();
		return;
	}

	stopped = false;
	if (InstigatorController == None)
		InstigatorController = Other.Controller;

	//want Instigator to be the one that caused the freeze
	OldInstigator = Instigator;
	PawnOwner = Other;
	
	if (PawnOwner != None)
	{
		WardInv = ComboWardInv(PawnOwner.FindInventoryType(Class'ComboWardInv'));
		if (WardInv != None && Rand(100) <= WardInv.EffectMultiplier)
		{
			if (Other.Controller != None && PlayerController(Other.Controller) != None)
				PlayerController(Other.Controller).ClientPlaySound(Sound'DEKRPG208AH.ComboSounds.Ward');
			Destroy();
			return;
		}
		
		if (PawnOwner.Weapon != None && PawnOwner.Weapon.IsA('RW_MagicalWard'))
		{
			W = RW_MagicalWard(PawnOwner.Weapon);
			if (Rand(100) <= W.Modifier*W.ChanceToWardPerModifier)
			{
				MWInv = MagicalWardProtectionInv(Other.FindInventoryType(class'MagicalWardProtectionInv'));
				if (MWInv == None)
				{
					MWInv = Other.Spawn(Class'MagicalWardProtectionInv');
					MWInv.GiveTo(Other);
				}
				else
				{
					MWInv.Lifespan = MWInv.default.Lifespan;
					MWInv.ProtectionMultiplier -= MWInv.ProtectionPerWardMultiplier;
					if (MWInv.ProtectionMultiplier < MWInv.MaxProtectionMultiplier)
						MWInv.ProtectionMultiplier = MWInv.MaxProtectionMultiplier;
				}
				if (Other.Controller != None && PlayerController(Other.Controller) != None)
					PlayerController(Other.Controller).ClientPlaySound(Sound'DEKRPG208AH.ComboSounds.Ward');
				Destroy();
				return;
			}
		}

		Instigator = OldInstigator;
		

		NInv = NecroInv(PawnOwner.FindInventoryType(class'NecroInv'));
		if(NInv != None)
		{
			Destroy();
			return;
		}
		PawnOwner.setOverlayMaterial(ModifierOverlay, (LifeSpan-2), true);
	
		MiInv = MissionInv(PawnOwner.FindInventoryType(class'MissionInv'));
		M1Inv = Mission1Inv(PawnOwner.FindInventoryType(class'Mission1Inv'));
		M2Inv = Mission2Inv(PawnOwner.FindInventoryType(class'Mission2Inv'));
		M3Inv = Mission3Inv(PawnOwner.FindInventoryType(class'Mission3Inv'));
	
		if (MiInv != None && !MiInv.WizardryComplete)
		{
			if (M1Inv != None && !M1Inv.Stopped && M1Inv.WizardryActive)
			{
				M1Inv.MissionCount++;
			}
			if (M2Inv != None && !M2Inv.Stopped && M2Inv.WizardryActive)
			{
				M2Inv.MissionCount++;
			}
			if (M3Inv != None && !M3Inv.Stopped && M3Inv.WizardryActive)
			{
				M3Inv.MissionCount++;
			}
		}
	}
	Super.GiveTo(Other);
}

simulated function Timer()
{
	Local Actor A;
	if(!stopped)
	{

		if (Level.NetMode != NM_DedicatedServer && PawnOwner != None)
		{
			if (PawnOwner.IsLocallyControlled() && PlayerController(PawnOwner.Controller) != None)
				PlayerController(PawnOwner.Controller).ReceiveLocalizedMessage(class'FreezeConditionMessage', 0);
		}
		if (Role == ROLE_Authority)
		{
			if(Owner != None)
				A = PawnOwner.spawn(class'IceSmoke', PawnOwner,, PawnOwner.Location, PawnOwner.Rotation);

			if(!class'RW_Freeze'.static.canTriggerPhysics(PawnOwner))
			{
				stopEffect();
				return;
			}

			if(LifeSpan <= 0.5)
			{
				stopEffect();
				return;
			}

			if (Owner == None)
			{
				Destroy();
				return;
			}

			if (Instigator == None && InstigatorController != None)
				Instigator = InstigatorController.Pawn;
			else if(PawnOwner != None)
				class'RW_Speedy'.static.quickfoot(-10 * Modifier, PawnOwner);
		}
	}
}

function stopEffect()
{
	if(stopped)
		return;
	else
		stopped = true;
	if(PawnOwner != None)
	{
		class'RW_Speedy'.static.quickfoot(0, PawnOwner);
	}
}

simulated function destroyed()
{
	stopEffect();
	super.destroyed();
}

defaultproperties
{
     ModifierOverlay=Shader'DEKRPGTexturesMaster208K.fX.PulseGreyShader'
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
