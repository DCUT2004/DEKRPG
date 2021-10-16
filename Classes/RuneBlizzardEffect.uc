class RuneBlizzardEffect extends IceSmoke
	config(UT2004RPG);


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
     mColorRange(0)=(B=189,G=97,R=40)
     mColorRange(1)=(B=189,G=62,R=40)
     mSizeRange(0)=500.000000
     mSizeRange(1)=1000.000000
     LightType=LT_None
     LightHue=144
     LightSaturation=150
     LightBrightness=0.000000
     LightRadius=0.000000
     bDynamicLight=False
     RemoteRole=ROLE_SimulatedProxy
     DrawScale=1.000000
}
