class RuneAmmo extends Ammunition;

simulated function CheckOutOfAmmo()
{
}

simulated function bool UseAmmo(int AmountNeeded, optional bool bAmountNeededIsMax)
{
    return true;
}


defaultproperties
{
	 InitialAmount=5
     MaxAmmo=5		//Set to 5, as anything less is considered a super weapon in UT2004RPG. Allows us to have magic modifiers on runes
}
