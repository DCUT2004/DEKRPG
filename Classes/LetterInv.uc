class LetterInv extends Inventory
	config(UT2004RPG);

var Pawn PawnOwner;
var config float CheckInterval;
var MutWaveRandomizer Randomizer;
var config class<Inventory> LetterClass;
var Inventory LetterInv;
var bool BonusAchieved;
var transient DruidsRPGKeysInteraction InteractionOwner;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
}

simulated function PostBeginPlay()
{
	local Mutator m;

	if (Level.Game != None)
		for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
			if (MutWaveRandomizer(m) != None)
			{
				Randomizer = MutWaveRandomizer(m);
				break;
			}
	BonusAchieved = False;
	Super.PostBeginPlay();
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	if(Other == None)
	{
		destroy();
		return;
	}

	PawnOwner = Other;
	SetTimer(CheckInterval, true);
	Super.GiveTo(Other);
}

simulated function Timer()
{
	local Controller C, NextC;
		
	if (Invasion(Level.Game) == None )
	{
		Destroy();
		return;
	}
	if (Invasion(Level.Game) != None && Randomizer != None)
	{
		if (Invasion(Level.Game).WaveNum == Invasion(Level.Game).FinalWave)	//Destroy on the Final Wave
		{
			if (Randomizer.bBunnyWaveAdded && Randomizer.SpecialWaveAdded)	//If we already Unlocked the bunny waves and its added to Randomizer
				Destroy();
			if (!Randomizer.bBunnyWaveAdded && Randomizer.BossWaveInitialized && Randomizer.BunnyWaveCompleted)	//Or if we haven't unlocked Bunny wave and we are already on the Boss wave. No BONUS when unlocking on Boss wave
				Destroy();
		}
	}
	
	if (PawnOwner != None && PawnOwner.Health > 0)
	{
		C = Level.ControllerList;
		while (C != None)
		{
			NextC = C.NextController;
			if (C != None && C.Pawn != None && C.Pawn.Health > 0 && C.SameTeamAs(PawnOwner.Controller) && !C.Pawn.IsA('Monster'))
			{
				LetterInv = LetterInv(C.Pawn.FindInventoryType(LetterClass));
				if (LetterInv == None)
				{
					LetterInv = C.Pawn.Spawn(LetterClass, C.Pawn);
					LetterInv.GiveTo(C.Pawn);
				}
			}
			C = NextC;
		}
		if (!BonusAchieved)
			CheckForLetters();
	}
}

simulated function CheckForLetters()
{
	local LetterBInv B;
	local LetterOInv O;
	local letterNInv N;
	local LetterUInv U;
	local LetterSInv S;
	
	B = LetterBInv(PawnOwner.FindInventoryType(class'LetterBInv'));
	O = LetterOInv(PawnOwner.FindInventoryType(class'LetterOInv'));
	N = LetterNInv(PawnOwner.FindInventoryType(class'LetterNInv'));
	U = LetterUInv(PawnOwner.FindInventoryType(class'LetterUInv'));
	S = LetterSInv(PawnOwner.FindInventoryType(class'LetterSInv'));
	if (Invasion(Level.Game) != None && B != None && O != None && N != None && U != None && S != None)
	{
		if (Randomizer != None && !Randomizer.bBunnyWaveAdded)
		{
			Randomizer.bBunnyWaveAdded = True;
			PlayBonusMessage();
			BonusAchieved = True;
		}
	}
}

simulated function PlayBonusMessage()
{
	if (PawnOwner != None)
		PawnOwner.ReceiveLocalizedMessage(class'BonusWaveMessage');
	if (PawnOwner.Controller != None && PlayerController(PawnOwner.Controller) != None)
		PlayerController(PawnOwner.Controller).ClientPlaySound(Sound'GameSounds.Fanfares.UT2k3Fanfare03');
}

defaultproperties
{
     CheckInterval=1.000000
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
