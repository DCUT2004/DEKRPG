class MutBONUSLetters extends Mutator;
	
var bool bFoundB, bFoundO, bFoundN, bFoundU, bFoundS;			//Determines whether a letter was found or not, and will decide whether we should unlock bonus wave

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	default.bFoundB = false;
	default.bFoundO  = false;
	default.bFoundN = false;
	default.bFoundU = false;
	default.bFoundS = false;
}

static function bool IsLetterBUnlocked()
{
	return default.bFoundB;
}

static function bool IsLetterOUnlocked()
{
	return default.bFoundO;
}

static function bool IsLetterNUnlocked()
{
	return default.bFoundN;
}

static function bool IsLetterUUnlocked()
{
	return default.bFoundU;
}

static function bool IsLetterSUnlocked()
{
	return default.bFoundS;
}

static function bool UnlockLetterB()
{
	if (default.bFoundB || class'MutWaveRandomizer'.static.IsBONUSUnlocked())
		return false;
	default.bFoundB = true;
	CheckBONUS();
	return true;
}

static function bool UnlockLetterO()
{
	if (default.bFoundO || class'MutWaveRandomizer'.static.IsBONUSUnlocked())
		return false;
	default.bFoundO = true;
	CheckBONUS();
	return true;
}

static function bool UnlockLetterN()
{
	if (default.bFoundN || class'MutWaveRandomizer'.static.IsBONUSUnlocked())
		return false;
	default.bFoundN = true;
	CheckBONUS();
	return true;
}

static function bool UnlockLetterU()
{
	if (default.bFoundU || class'MutWaveRandomizer'.static.IsBONUSUnlocked())
		return false;
	default.bFoundU = true;
	CheckBONUS();
	return true;
}

static function bool UnlockLetterS()
{
	if (default.bFoundS || class'MutWaveRandomizer'.static.IsBONUSUnlocked())
		return false;
	default.bFoundS = true;
	CheckBONUS();
	return true;
}

static function CheckBONUS()
{
	if (class'MutWaveRandomizer'.static.IsBONUSUnlocked())
		return;
	if (!default.bFoundB || !default.bFoundO || !default.bFoundN || !default.bFoundU || !default.bFoundS)
		return;
	class'MutWaveRandomizer'.static.UnlockBONUSWave();
}

defaultproperties
{
     FriendlyName="BONUS Letters"
     Description="Allows the Invasion gametype to unlock a bonus wave."
}
