class RuneInstantFire extends InstantFire
	config(DEKWeapons);

var config int AdrenCost;

function DoFireEffect()
{
    local Vector StartTrace;
    local Rotator R, Aim;
	
	if (Instigator == None || Instigator.Controller == None)
		return;
	
	//First, check to see if we have enough adren
	
	if (Instigator.Controller.Adrenaline < AdrenCost)
		return;

    Instigator.MakeNoise(1.0);

    // the to-hit trace always starts right in front of the eye
    StartTrace = Instigator.Location + Instigator.EyePosition();
    Aim = AdjustAim(StartTrace, AimError);
	R = rotator(vector(Aim) + VRand()*FRand()*Spread);
    DoTrace(StartTrace, R);
	
	//Take off adren
	Instigator.Controller.Adrenaline -= AdrenCost;
}

defaultproperties
{
     TweenTime=0.000000
     AmmoClass=Class'DEKRPG209A.RuneAmmo'
     AmmoPerFire=0
}
