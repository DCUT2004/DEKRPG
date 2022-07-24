class MutBONUSLetters extends Mutator
	config(MutBONUSLetters);
	
var bool bFoundB, bFoundO, bFoundN, bFoundU, bFoundS;			//Determines whether a letter was found or not, and will decide whether we should unlock bonus wave
var MutWaveRandomizer WaveRandomizer;							//So we can tell WaveRandomizer to unlock bonus wave
var bool bBONUSUnlocked;

simulated function PostBeginPlay()
{
	local Mutator M;
	
	Super.PostBeginPlay();
	for (M = Level.Game.BaseMutator; M != None; M = M.NextMutator)
		if (MutWaveRandomizer(M) != None)
		{
			WaveRandomizer = MutWaveRandomizer(M);
			break;
		}
	default.bFoundB = false;
	default.bFoundO  = false;
	default.bFoundN = false;
	default.bFoundU = false;
	default.bFoundS = false;
	default.bBONUSUnlocked = false;
}

static function UnlockLetterB()
{
	if (default.bFoundB || default.bBONUSUnlocked)
		return;
	default.bFoundB = true;
	UnlockBONUS();
}

static function UnlockLetterO()
{
	if (default.bFoundO || default.bBONUSUnlocked)
		return;
	default.bFoundO = true;
	UnlockBONUS();
}

static function UnlockLetterN()
{
	if (default.bFoundN || default.bBONUSUnlocked)
		return;
	default.bFoundN = true;
	UnlockBONUS();
}

static function UnlockLetterU()
{
	if (default.bFoundU || default.bBONUSUnlocked)
		return;
	default.bFoundU = true;
	UnlockBONUS();
}

static function UnlockLetterS()
{
	if (default.bFoundS || default.bBONUSUnlocked)
		return;
	default.bFoundS = true;
	UnlockBONUS();
}

static function UnlockBONUS()
{
	if (default.bBONUSUnlocked)
		return;
	if (!default.bFoundB || !default.bFoundO || !default.bFoundN || !default.bFoundU || !default.bFoundS)
		return;
	//To finish...
}

defaultproperties
{
     FriendlyName="BONUS Letters"
     Description="Allows the Invasion gametype to unlock a bonus wave."
}
