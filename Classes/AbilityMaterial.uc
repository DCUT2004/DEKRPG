//Materials are unlockable abilities that players can buy
//Certain events, once triggered in the game, allow these abilities to be purchased by the player from setting cost = 0 to some positive integer
//Materials can never be sold, and stay with the player forever

class AbilityMaterial extends CostRPGAbility
	config(UT2004RPG)
	abstract;

defaultproperties
{
     AbilityName="Material"
	 StartingCost=3
}
