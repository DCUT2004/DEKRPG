class PlagueInv extends Inventory
	config(UT2004RPG);

var Pawn PawnOwner;
var Controller Necromancer;
var Pawn InfectorOne, InfectorTwo, InfectorThree;
var config int PlagueDamage;
var config float InfectRadius;
var config int PlagueLifespan, MaxLifespan;
var bool FatalPlague;
var PlagueRegenInv RInv;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner, Necromancer;

	reliable if (Role == ROLE_Authority)
		InfectorOne, InfectorTwo, InfectorThree, FatalPlague;
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	local FatalInv FInv;
	
	FInv = FatalInv(Other.FindInventoryType(class'FatalInv'));
	if (FatalPlague && FInv != None)
	{
		PlagueDamage += FInv.PlagueDamage;
		PlagueLifespan = FInv.PlagueLifespan;
		MaxLifespan= FInv.PlagueMaxLifespan;
	}
	PawnOwner = Other;
	RInv = PlagueRegenInv(Other.FindInventoryType(class'PlagueRegenInv'));
	SetTimer(1, True);
	
	Super.GiveTo(Other);
}

simulated function Timer()
{
	local Vehicle V;
	
	if (Necromancer == None || Necromancer.Pawn == None || Necromancer.Pawn.Health <= 0)
	{
		Destroy();
		return;
	}

	if (Owner == None)
	{
		Destroy();
		return;
	}

	if (PawnOwner == None)
	{
		Destroy();
		return;     // cant do anything
	}
	else
	{
		if(PlagueDamage > 0)
		{
			if (PawnOwner.Controller != None)
			{
				if (PawnOwner != Necromancer.Pawn)	//If this Pawn is not the Necromancer player
				{
					V = Vehicle(PawnOwner);
					if (V != None)	//If this pawn is in a vehicle, we want to directly damage their HP and not the vehicle's HP
					{
						V.Driver.TakeDamage(PlagueDamage, Necromancer.Pawn, V.Driver.Location, vect(0,0,0), class'DamTypePlague');
						if (InfectorOne != None)
							V.Driver.TakeDamage(PlagueDamage*0.85, InfectorOne, V.Driver.Location, vect(0,0,0), class'DamTypePlague');
						if (InfectorTwo != None)
							V.Driver.TakeDamage(PlagueDamage*0.65, InfectorTwo, V.Driver.Location, vect(0,0,0), class'DamTypePlague');	
						if (InfectorThree != None)
							V.Driver.TakeDamage(PlagueDamage*0.50, InfectorThree, V.Driver.Location, vect(0,0,0), class'DamTypePlague');								
					}
					else
					{
						PawnOwner.TakeDamage(PlagueDamage, Necromancer.Pawn, PawnOwner.Location, vect(0,0,0), class'DamTypePlague');
						if (InfectorOne != None)
							PawnOwner.TakeDamage(PlagueDamage*0.85, InfectorOne, PawnOwner.Location, vect(0,0,0), class'DamTypePlague');
						if (InfectorTwo != None)
							PawnOwner.TakeDamage(PlagueDamage*0.65, InfectorTwo, PawnOwner.Location, vect(0,0,0), class'DamTypePlague');
						if (InfectorThree != None)
							PawnOwner.TakeDamage(PlagueDamage*0.50, InfectorThree, PawnOwner.Location, vect(0,0,0), class'DamTypePlague');
					}
				}
				else if (PawnOwner == Necromancer.Pawn)	//If this Pawn is the Necromancer player
				{
					PlagueLifespan--;
					if (PlagueLifespan <= 0)
						Destroy();
				}
				if (EffectIsRelevant(PawnOwner.Location,false) )
				{
					if (FatalPlague)
					{
						Spawn(class'PlagueFatalSmoke',,, PawnOwner.Location, PawnOwner.Rotation);
					}
					else
					{
						Spawn(class'PlagueSmoke',,, PawnOwner.Location, PawnOwner.Rotation);
					}
				}
				if (PlayerController(PawnOwner.Controller) != None)
					PlayerController(PawnOwner.Controller).ReceiveLocalizedMessage(class'PlagueMessage', PlagueLifespan);
				Infect(InfectRadius);
			}
		}
		if (RInv != None)
			PawnOwner.GiveHealth(RInv.RegenAmount, PawnOwner.HealthMax);
	}
}

simulated function Infect(float Radius)
{
	local Controller C;
	local PlagueInv Inv;
	
	if (Necromancer == None || Necromancer.Pawn == None || Necromancer.Pawn.Health <= 0)
	{
		Destroy();
		return;
	}
	
	if (PawnOwner == None || PawnOwner.Health <= 0)
	{
		Destroy();
		return;
	}
	
	for ( C = Level.ControllerList; C != None; C = C.NextController )
	{
		if (C != None && C.Pawn != None && C.Pawn.Health > 0 && PawnOwner != None && C.Pawn != PawnOwner && Necromancer != None && !C.SameTeamAs(Necromancer) && VSize(C.Pawn.Location - PawnOwner.Location) <= Radius
		&& FastTrace(C.Pawn.Location, PawnOwner.Location) && C.bGodMode == False && InvulnerabilityInv(C.Pawn.FindInventoryType(class'InvulnerabilityInv')) == None && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow'))
		{
			Inv = PlagueInv(C.Pawn.FindInventoryType(class'PlagueInv'));
			if (Inv == None)
			{
				Inv = C.Pawn.Spawn(class'PlagueInv', C.Pawn, , C.Pawn.Location, C.Pawn.Rotation);
				Inv.Necromancer = Necromancer;
				Inv.PlagueDamage = PlagueDamage;
				Inv.GiveTo(C.Pawn);
				if (FatalPlague)
				{
					Inv.PlagueDamage = PlagueDamage;
					Inv.FatalPlague = True;
				}
			}
			else if (Inv != None)
			{
				if (PawnOwner != Necromancer)	//this must be a monster. Humans/bots will never have this inventory and not be a Necromancer
				{
					if (InfectorOne != None && Inv.InfectorOne == None)	//When a monster is infecting another monster, transfer all infector pawns to that monster
					{
						Inv.InfectorOne = InfectorOne;
					}
					if (InfectorTwo != None && Inv.InfectorTwo == None)
					{
						Inv.InfectorTwo = InfectorTwo;
					}
					if (InfectorThree != None && Inv.InfectorThree == None)
					{
						Inv.InfectorThree = InfectorThree;
					}
				}
				else if (PawnOwner == Necromancer && Inv.Necromancer != Necromancer)	//this must be a human/bot.
				{
					if (Inv.InfectorOne == None)	//When infecting a monster, see if we can fill one of the infector slots and get a piece of the cake
						Inv.InfectorOne = Necromancer.Pawn;
					else if (Inv.InfectorTwo == None)
						Inv.InfectorTwo = Necromancer.Pawn;
					else if (Inv.InfectorThree == None)
						Inv.InfectorThree = Necromancer.Pawn;
					if (FatalPlague && (Necromancer.Pawn == Inv.InfectorOne || Necromancer.Pawn == Inv.InfectorTwo || Necromancer.Pawn == Inv.InfectorThree))
					{
						Inv.PlagueDamage = PlagueDamage;
						Inv.FatalPlague = True;
					}
				}
			}
		}
	}
}


simulated function SpawnInfection()
{
	local PlagueActor Plague;
	
	if (Necromancer == None || Necromancer.Pawn == None || Necromancer.Pawn.Health <= 0)
		return;
	if (PawnOwner != None && Necromancer != None)
	{
		Plague = PawnOwner.Spawn(class'PlagueActor', PawnOwner,, PawnOwner.Location, PawnOwner.Rotation);
		if (Plague != None)
		{
			Plague.Necromancer = Necromancer;
			Plague.Explode();
		}
	}
}

simulated function Destroyed()
{
	if (PawnOwner != None && Necromancer != None && PawnOwner != Necromancer.Pawn)
		SpawnInfection();
	super.destroyed();
}

defaultproperties
{
     PlagueDamage=4
     InfectRadius=200.000000
     PlagueLifespan=10
     MaxLifespan=20
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
