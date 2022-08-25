/*
* This status effect holds information about a player's temporary max adrenaline
* Spawned when AdrenRegen status effect drips adrenaline above default max amount
*/

class StatusEffect_AdrenMax extends StatusEffect
	config(UT2004RPG);
	
var float OriginalMaxAdren;
var config int MaxIncrease;		//How much additional adren a player can have from AdrenRegen combo

function StartEffect(Pawn Target)
{
	SetTimer(0.1, True);
}

function Timer()
{
	if (Instigator == None || Instigator.Controller == None)
		Destroy();

	if (Instigator.Controller.Adrenaline > OriginalMaxAdren + MaxIncrease)	//In case combos increase the max adren cap to a high amount, this will limit the max according to MaxMultiplier
		Instigator.Controller.Adrenaline = OriginalMaxAdren + MaxIncrease;
	if (Instigator.Controller.Adrenaline < Instigator.Controller.AdrenalineMax)	//Continously reset the max adrenaline when the player consumes/loses adrenaline
		Instigator.Controller.AdrenalineMax = Instigator.Controller.Adrenaline;
	if (Instigator.Controller.Adrenaline < OriginalMaxAdren)	//When the current adrenaline falls below the original starting max adren amount, we no longer need this item
	{
		Instigator.Controller.AdrenalineMax = OriginalMaxAdren;
		Destroy();
		return;
	}
}

function StopEffect(Pawn Target)
{
}

defaultproperties
{
	MaxIncrease=100
}
