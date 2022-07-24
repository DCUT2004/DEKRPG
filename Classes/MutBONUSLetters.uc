class MutBONUSLetters extends Mutator
	config(MutBONUSLetters);
	
var bool bFoundB, bFoundO, bFoundN, bFoundU, bFoundS;			//Determines whether a letter was found or not, and will decide whether we should unlock bonus wave

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	bFoundB = false;
	bFoundO  = false;
	bFoundN = false;
	bFoundU = false;
	bFoundS = false;
}


defaultproperties
{
     FriendlyName="BONUS Letters"
     Description="Allows the Invasion gametype to unlock a bonus wave."
}
