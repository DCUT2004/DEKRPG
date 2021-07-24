class FlowerAdrenInv extends Inventory;

var Pawn PawnOwner;
var config float Interval;
var config float HealRadius;
var config float HealAmount, MaxHealAmount;
var config float MaxLifespan;
var Material EffectOverlay;
var FlowerAdrenHealFX FX;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	if (Other != None)
		PawnOwner = Other;
	SetTimer(Interval,True);
	FX = PawnOwner.Spawn(class'FlowerAdrenHealFX');
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
		FX = PawnOwner.Spawn(class'FlowerAdrenHealFX');
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
				PlayerController(C).ReceiveLocalizedMessage(class'FlowerAdrenBoostedMessage', 0);				
			if (C.Adrenaline < C.AdrenalineMax)
			{
				C.AwardAdrenaline(HealAmount);
				if (C.Pawn != PawnOwner)
					PlayerController(C).ReceiveLocalizedMessage(class'FlowerAdrenBoostedMessage', 0);
				C.Pawn.PlaySound(sound'PickupSounds.AdrenelinPickup',, 0.75 * C.Pawn.TransientSoundVolume,, 0.75 * C.Pawn.TransientSoundRadius);
				C.Pawn.SetOverlayMaterial(EffectOverlay, 0.5, false);
			}
		}
		C = C.NextController;
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
     EffectOverlay=Shader'DEKRPGTexturesMaster208K.fX.PulseOrangeShader1'
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
     LifeSpan=10.000000
}
