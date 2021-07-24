class IceSmoke extends RocketExplosion
	config(ScoreFix);


simulated function PostBeginPlay()
{
	local PlayerController PC;

	PC = Level.GetLocalPlayerController();
	if (PC != None && ( PC.ViewTarget == None || VSize(PC.ViewTarget.Location - Location) > 2000))
	{
		LightType = LT_None;
		bDynamicLight = false;
	}
	else 
	{
		Spawn(class'RocketSmokeRing');
		if (Level.bDropDetail)
			LightRadius = 7;	
	}
	//dont call super. The Super classes's postbeginplay is messed up.
}

defaultproperties
{
     LightType=LT_None
     LightHue=144
     LightSaturation=150
     LightBrightness=0.000000
     LightRadius=0.000000
     bDynamicLight=False
     RemoteRole=ROLE_SimulatedProxy
     DrawScale=0.000100
}
