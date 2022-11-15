class PlagueActor extends Actor;

var PlagueDeathSmoke FX;
var PlagueFatalDeathSmoke FX1;
var Controller Necromancer;
var config float InfectRadius;
var config float PlagueLifespan;
var config float WaitTime;
var int Counter;
var int SpreadCounter;
var config float PlagueBlastDamage, PlagueBlastRadius;
var config int PlagueBlastChance;

replication
{
	reliable if (Role == ROLE_Authority)
		SpreadCounter;
}

simulated function PostBeginPlay()
{
    SetTimer(1, true);
	Counter = 0;
	SpreadCounter = 0;
	Super.PostBeginPlay();
}

simulated function Explode()
{
	local float damageScale, dist;
	local vector dir;
	local Controller C, NextC;
	local DiseasedInv DInv;
	local int Chance;
	
	if (Necromancer == None || Necromancer.Pawn == None || Necromancer.Pawn.Health <= 0)
		return;

	DInv = DiseasedInv(Necromancer.Pawn.FindInventoryType(class'DiseasedInv'));
	if (DInv != None)
	{
		Chance = Rand(100);
		PlagueBlastDamage *= DInv.PlagueBlastDamageMultiplier;
		PlagueBlastRadius *= DInv.PlagueBlastRadiusMultiplier;
	}
	else
		return;
		
	if (Chance <= PlagueBlastChance)
	{
		C = Level.ControllerList;
		while (C != None)
		{
			// get next controller here because C may be destroyed if it's a nonplayer and C.Pawn is killed
			NextC = C.NextController;
			if ( DInv != None && C != None && C.Pawn != None && C.Pawn != Necromancer && C.Pawn.Health > 0 && !C.SameTeamAs(Necromancer)
				 && VSize(C.Pawn.Location - Location) < PlagueBlastRadius && FastTrace(C.Pawn.Location, Location) )
			{
				dir = C.Pawn.Location - Location;
				dist = FMax(1,VSize(dir));
				dir = dir/dist;
				damageScale = 1 - FMax(0,dist/PlagueBlastRadius);
				C.Pawn.TakeDamage(damageScale * PlagueBlastDamage, Necromancer.Pawn, C.Pawn.Location, vect(0,0,0), class'DamTypePlague');
				C.Pawn.Spawn(class'PlagueExplosion',,,C.Pawn.Location);

				//now see if we killed it
				if (C == None || C.Pawn == None || C.Pawn.Health <= 0 )
					class'EnhancedRPGArtifact'.static.AddArtifactKill(Instigator, class'WeaponPlague');	// assume killed
			}
			C = NextC;
		}
	}
}

simulated function Timer()
{
	local Controller C;
	local PlagueInv Inv;
	local PlagueSpreader PInv;
	local FatalInv FInv;
	local int Num;
	
	if (Necromancer == None || Necromancer.Pawn == None || Necromancer.Pawn.Health <= 0)
	{
		Destroy();
		return;
	}
	
	if (FInv == None)
		FInv = FatalInv(Necromancer.Pawn.FindInventoryType(class'FatalInv'));
	
	for ( C = Level.ControllerList; C != None; C = C.NextController )
	{
		if (C != None && C.Pawn != None && C.Pawn.Health > 0 && Necromancer != None && VSize(C.Pawn.Location - Self.Location) <= InfectRadius
		&& FastTrace(C.Pawn.Location, Self.Location) && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow'))
		{
			Inv = PlagueInv(C.Pawn.FindInventoryType(class'PlagueInv'));
			PInv = PlagueSpreader(C.Pawn.FindInventoryType(class'PlagueSpreader'));
			if (C.SameTeamAs(Necromancer) && PInv != None)
			{
				SpreadCounter++;
				if (SpreadCounter >= WaitTime)
				{
					if (Inv == None)
					{
						Inv = C.Pawn.Spawn(class'PlagueInv', C.Pawn, , C.Pawn.Location, C.Pawn.Rotation);
						Inv.Necromancer = C; //Everyone who comes to the plague cloud becomes the Necromancer spreader
						if (FInv != None)
						{
							Inv.PlagueDamage = FInv.PlagueDamage;
							Inv.FatalPlague = True;
						}
						if (FInv == None)
							Inv.FatalPlague = False;
						Inv.GiveTo(C.Pawn);
					}
					else if (Inv != None)
					{
						Inv.PlagueLifespan += 5;
						if (Inv.PlagueLifespan > Inv.MaxLifespan)
							Inv.PlagueLifespan = Inv.MaxLifespan;
					}
					SpreadCounter = 0;
				}
			}
			else if (!C.SameTeamAs(Necromancer))
			{
				if (Inv == None)
				{
					Inv = C.Pawn.Spawn(class'PlagueInv', C.Pawn, , C.Pawn.Location, C.Pawn.Rotation);
					Inv.Necromancer = Necromancer;
					if (FInv != None)
					{
						Inv.PlagueDamage = FInv.PlagueDamage;
						Inv.FatalPlague = True;
					}
					else
						Inv.FatalPlague = False;
					Inv.GiveTo(C.Pawn);
				}
				else if (Inv != None)
				{
					if (Inv.Necromancer != Necromancer)
					{
						if (Inv.InfectorOne == None)
							Inv.InfectorOne = Necromancer.Pawn;
						else if (Inv.InfectorTwo == None)
							Inv.InfectorTwo = Necromancer.Pawn;
						else if (Inv.InfectorThree == None)
							Inv.InfectorThree = Necromancer.Pawn;
						if (FInv != None && (Necromancer.Pawn == Inv.InfectorOne || Necromancer.Pawn == Inv.InfectorTwo || Necromancer.Pawn == Inv.InfectorThree))
						{
							Inv.PlagueDamage = FInv.PlagueDamage;
							Inv.FatalPlague = True;
						}
						if (FInv == None)
							Inv.FatalPlague = False;
					}
				}
			}
		}
	}
	Num = Necromancer.Pawn.GetTeamNum();
	if (FInv != None && FX1 == None)
	{
		FX1 = Spawn(class'PlagueFatalDeathSmoke', Self,, Self.Location, Self.Rotation);
		if (FX1 != None)
		{
			FX1.Lifespan=PlagueLifespan;
			FX1.SetBase(Self);
		}
	}
	if (FInv == None && FX == None)
	{
		FX = Spawn(class'PlagueDeathSmoke', Self,, Self.Location, Self.Rotation);
		if (FX != None)
		{
			FX.Lifespan=PlagueLifespan;
			FX.SetBase(Self);
		}
	}
	Counter++;
	if (Counter >= PlagueLifespan)
	{
		Destroy();
		return;
	}
}

simulated function Destroyed()
{
	if (FX != None)
		FX.Destroy();
	if (FX1 != None)
		FX1.Destroy();
	Super.Destroyed();
}

defaultproperties
{
     InfectRadius=400.000000
     PlagueLifespan=10.000000
     WaitTime=3.000000
     PlagueBlastDamage=200.000000
     PlagueBlastRadius=400.000000
     PlagueBlastChance=50
     DrawType=DT_None
     Texture=Texture'XEffectMat.Shock.shock_core'
     DrawScale=0.080000
}
