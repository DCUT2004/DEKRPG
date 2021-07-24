class FlowerResupplyInv extends Inventory;

var Pawn PawnOwner;
var config float Interval;
var config float HealRadius;
var config float HealAmount, MaxHealAmount;
var config float MaxLifespan;
var Material EffectOverlay;
var FlowerResupplyFX FX;

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
	FX = PawnOwner.Spawn(class'FlowerResupplyFX');
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
		FX = PawnOwner.Spawn(class'FlowerResupplyFX');
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
				PlayerController(C).ReceiveLocalizedMessage(class'FlowerResupplyMessage', 0);				
			if (C.Pawn.Weapon != None && C.Pawn.Weapon.AmmoClass[0] != None && !class'MutUT2004RPG'.static.IsSuperWeaponAmmo(C.Pawn.Weapon.AmmoClass[0])
				&& !C.Pawn.Weapon.AmmoMaxed(0))
			{
				C.Pawn.Weapon.AddAmmo(HealAmount * (1 + (C.Pawn.Weapon.MaxAmmo(0) / 100)),0);
				C.Pawn.PlaySound(sound'WeaponSounds.BaseGunTech.BReload9',, 0.75 * C.Pawn.TransientSoundVolume,, 0.75 * C.Pawn.TransientSoundRadius);
				if (C.Pawn != PawnOwner)
					PlayerController(C).ReceiveLocalizedMessage(class'FlowerResupplyMessage', 0);
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
     HealAmount=1.000000
     MaxHealAmount=10.000000
     MaxLifespan=20.000000
     EffectOverlay=Shader'DEKRPGTexturesMaster208K.fX.PulseRedShader1'
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
     LifeSpan=10.000000
}
