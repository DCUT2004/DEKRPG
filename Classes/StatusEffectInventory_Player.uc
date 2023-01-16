/*
* StatusEffectInventory_Player is spawned on a Player through RPGClass
* It manages a Pawn's currently applied Status Effects, and properly adds or removes them
* Additionally, it searches for nearby Altars for depositing Geodes
*/

class StatusEffectInventory_Player extends StatusEffectInventory
	config (UT2004RPG);

var bool HasGeode;
var int DepositCounter;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer(1, True);
	DepositCounter = 0;
}

function Timer()
{
	local Altar Altar;

	Super.Timer();
	
	if (Instigator == None || Instigator.Controller == None)
		return;
	
	foreach Instigator.TouchingActors(Class'Altar', Altar)	//Use TouchingActors - much faster
	{
		if (Altar != None)
		{
			if (PlayerController(Instigator.Controller) != None)
				PlayerController(Instigator.Controller).ReceiveLocalizedMessage(Altar.AltarMessageClass, Altar.NumGeodes);
			if (Altar.NumGeodes < Altar.MaxGeodes && HasGeode)
			{
				DepositCounter++;
				if (DepositCounter >= Altar.DepositThreshold)
				{
					Altar.NumGeodes++;
					HasGeode = False;
					DepositCounter = 0;
				}
			}
		}
	}
}

defaultproperties
{
}
