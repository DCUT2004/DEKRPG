class DruidAdrenRegenInv extends Inventory
	config(UT2004RPG);

var config int RegenAmount;
var bool bAlwaysGive;
var int WaveNum;
var int WaveBonus;
var config float ReplenishAdrenPercent;

function Timer()
{
	local Controller C;
	local DiseasedInv DInv;
	local PlagueInv PInv;
	local int TempAmount;
	
	TempAmount = 0;

	if (Instigator == None || Instigator.Health <= 0)
	{
		Destroy();
		return;
	}
	
	DInv = DiseasedInv(Instigator.FindInventoryType(class'DiseasedInv'));
	PInv = PlagueInv(Instigator.FindInventoryType(class'PlagueInv'));
		
	C = Instigator.Controller;
	if (C == None && Instigator.DrivenVehicle != None)
		 C = Instigator.DrivenVehicle.Controller;

	if (C == None)
		return;

	if (DInv != None && PInv != None)
		C.AwardAdrenaline(0);
	else
		C.AwardAdrenaline(RegenAmount);

	// now check to see if in invasion and between waves. In which case get end of wave bonus.
	if (Level.Game.IsA('Invasion') && Invasion(Level.Game).WaveNum != WaveNum)
	{
	    WaveNum = Invasion(Level.Game).WaveNum;
	    C.AwardAdrenaline(WaveBonus * ReplenishAdrenPercent * C.AdrenalineMax);
	}
}

defaultproperties
{
     RegenAmount=1
     WaveNum=-1
     ReplenishAdrenPercent=0.100000
     RemoteRole=ROLE_DumbProxy
}
