class DruidSentinelSummon extends Summonifact
	config(UT2004RPG);

function bool SpawnIt(TranslocatorBeacon Beacon, Pawn P, EngineerPointsInv epi)
{
	local Vector SpawnLoc,SpawnLocCeiling;
	local bool bOnCeiling;

	if (ClassIsChildOf(SummonItem,class'DruidEnergyWall'))
		return SpawnEnergyWall(Beacon, P, epi);

	SpawnLoc = epi.GetSpawnHeight(Beacon.Location);	// look at the floor
	bOnCeiling = false;
	SpawnLocCeiling = epi.FindCeiling(Beacon.Location);		// see if can go on ceiling instead.
	if (SpawnLocCeiling != vect(0,0,0) && (SpawnLoc == vect(0,0,0) || VSize(SpawnLocCeiling - Beacon.Location) < VSize(SpawnLoc - Beacon.Location)))
	{
	    // closer to ceiling so spawn there
		bOnCeiling = true;
		SpawnLoc = SpawnLocCeiling;
    }
     
    if (SpawnLoc == vect(0,0,0))
    {
    	Instigator.ReceiveLocalizedMessage(MessageClass, 4000, None, None, Class);
    	bActive = false;
    	GotoState('');
    	return false;
    }

    // sentinels sometimes have a completely different ceiling mesh that is drawn inverted, otherwise it is the same model as the floor version (perhaps with a different swivel) that needs inverting
    switch (SummonItem) 
    {
    case class'AutoGun':
		if (bOnCeiling)
            return CreateSentinel(class'AutoGun',-36,80,-100,class'AutoGunController',32768, Points, P, SpawnLoc, epi);  
        else
            return CreateSentinel(class'AutoGun',36,80,100,class'AutoGunController',0, Points, P, SpawnLoc, epi);
    	break;
    case class'DEKMachineGunSentinel':
		if (bOnCeiling)
            return CreateSentinel(class'DEKCeilingMachineGunSentinel',-36,80,-100,class'DEKMachineGunSentinelController',32768, Points, P, SpawnLoc, epi);
        else
            return CreateSentinel(class'DEKMachineGunSentinel',36,80,100,class'DEKMachineGunSentinelController',0, Points, P, SpawnLoc, epi);
    	break;
    case class'DEKSniperSentinel':
		if (bOnCeiling)
            return CreateSentinel(class'DEKCeilingSniperSentinel',-36,80,-100,class'DEKSniperSentinelController',32768, Points, P, SpawnLoc, epi);
        else
            return CreateSentinel(class'DEKSniperSentinel',36,80,100,class'DEKSniperSentinelController',0, Points, P, SpawnLoc, epi);
    	break;
    case class'DruidSentinel':
		if (bOnCeiling)
            return CreateSentinel(class'DruidCeilingSentinel',-80,120,-160,class'DruidSentinelController',0, Points, P, SpawnLoc, epi);
        else
            return CreateSentinel(class'DruidSentinel',78,150,180,class'DruidSentinelController',0, Points, P, SpawnLoc, epi);
    	break;
    case class'DEKMercurySentinel':
		if (bOnCeiling)
            return CreateSentinel(class'DEKCeilingMercurySentinel',-80,120,-160,class'DEKMercuryController',0, Points, P, SpawnLoc, epi);
        else
            return CreateSentinel(class'DEKMercurySentinel',78,150,180,class'DEKMercuryController',0, Points, P, SpawnLoc, epi);
    	break;
    case class'DEKHellfireSentinel':
		if (bOnCeiling)
            return CreateSentinel(class'DEKCeilingHellfireSentinel',-80,120,-160,class'DEKHellfireSentinelController',0, Points, P, SpawnLoc, epi);
        else
            return CreateSentinel(class'DEKHellfireSentinel',78,150,180,class'DEKHellfireSentinelController',0, Points, P, SpawnLoc, epi);
    	break;
    case class'DEKRocketSentinel':
		if (bOnCeiling)
            return CreateSentinel(class'DEKCeilingRocketSentinel',-80,120,-160,class'DEKRocketSentinelController',0, Points, P, SpawnLoc, epi);
        else
            return CreateSentinel(class'DEKRocketSentinel',78,150,180,class'DEKRocketSentinelController',0, Points, P, SpawnLoc, epi);
    	break;
    case class'DEKBeamSentinel':
		if (bOnCeiling)
            return CreateSentinel(class'DEKCeilingBeamSentinel',-80,120,-160,class'DEKBeamSentinelController',0, Points, P, SpawnLoc, epi);
        else
            return CreateSentinel(class'DEKBeamSentinel',78,150,180,class'DEKBeamSentinelController',0, Points, P, SpawnLoc, epi);
    	break;
    case class'DruidLightningSentinel':
		if (bOnCeiling)
            return CreateSentinel(class'DruidCeilingLightningSentinel',-80,120,-160,class'DruidLightningSentinelController',0, Points, P, SpawnLoc, epi);
        else
            return CreateSentinel(class'DruidLightningSentinel',30,150,180,class'DruidLightningSentinelController',0, Points, P, SpawnLoc, epi);
    	break;
    case class'DruidTeslaSentinel':
		if (bOnCeiling)
            return CreateSentinel(class'DruidCeilingTeslaSentinel',-80,120,-160,class'DruidTeslaSentinelController',0, Points, P, SpawnLoc, epi);
        else
            return CreateSentinel(class'DruidTeslaSentinel',30,150,180,class'DruidTeslaSentinelController',0, Points, P, SpawnLoc, epi);
    	break;
    case class'DruidSuperDefenseSentinel':
		if (bOnCeiling)
            return CreateSentinel(class'DruidCeilingSuperDefenseSentinel',-80,120,-160,class'DruidSuperDefenseSentinelController',0, Points, P, SpawnLoc, epi);
        else
            return CreateSentinel(class'DruidSuperDefenseSentinel',30,150,180,class'DruidSuperDefenseSentinelController',0, Points, P, SpawnLoc, epi);
    	break;
    case class'DruidDefenseSentinel':
		if (bOnCeiling)
            return CreateSentinel(class'DruidCeilingDefenseSentinel',-80,120,-160,class'DruidDefenseSentinelController',0, Points, P, SpawnLoc, epi);
        else
            return CreateSentinel(class'DruidDefenseSentinel',30,150,180,class'DruidDefenseSentinelController',0, Points, P, SpawnLoc, epi);
    	break;
    case class'DruidDefenseSentinelCrimbo':
		if (bOnCeiling)
            return CreateSentinel(class'DruidCeilingDefenseSentinelCrimbo',-80,120,-160,class'DruidDefenseSentinelControllerCrimbo',0, Points, P, SpawnLoc, epi);
        else
            return CreateSentinel(class'DruidDefenseSentinelCrimbo',30,150,180,class'DruidDefenseSentinelControllerCrimbo',0, Points, P, SpawnLoc, epi);
    	break;
    case class'DEKDamageSentinel':
		if (bOnCeiling)
            return CreateSentinel(class'DEKCeilingDamageSentinel',-80,120,-160,class'DEKDamageSentinelController',0, Points, P, SpawnLoc, epi);
        else
            return CreateSentinel(class'DEKDamageSentinel',30,150,180,class'DEKDamageSentinelController',0, Points, P, SpawnLoc, epi);
    	break;
    case class'DEKExplosivesSentinel':
		if (bOnCeiling)
            return CreateSentinel(class'DEKCeilingExplosivesSentinel',-80,120,-160,class'DEKExplosivesSentinelController',0, Points, P, SpawnLoc, epi);
        else
            return CreateSentinel(class'DEKExplosivesSentinel',30,150,180,class'DEKDamageSentinelController',0, Points, P, SpawnLoc, epi);
    	break;
    case class'AASentinel':
		if (bOnCeiling)
            return CreateSentinel(class'AACeilingSentinel',-80,80,-100,class'AASentinelController',32768, Points, P, SpawnLoc, epi);
        else
            return CreateSentinel(class'AASentinel',28,80,100,class'AASentinelController',0, Points, P, SpawnLoc, epi);
    	break;
    case class'DEKAutoMachinegun':
		if (bOnCeiling)
            return CreateSentinel(class'DEKAutoMachinegun',-36,80,-100,class'DEKAutoMachinegunController',32768, Points, P, SpawnLoc, epi);
        else
            return CreateSentinel(class'DEKAutoMachinegun',36,80,100,class'DEKAutoMachinegunController',0, Points, P, SpawnLoc, epi);
    	break;
    case class'DEKAutoSniper':
		if (bOnCeiling)
            return CreateSentinel(class'DEKAutoSniper',-36,80,-100,class'DEKAutoSniperController',32768, Points, P, SpawnLoc, epi);
        else
            return CreateSentinel(class'DEKAutoSniper',36,80,100,class'DEKAutoSniperController',0, Points, P, SpawnLoc, epi);
    	break;
    case class'DEKAutoMercury':
		if (bOnCeiling)
            return CreateSentinel(class'DEKAutoMercury',-36,80,-100,class'DEKAutoMercuryController',32768, Points, P, SpawnLoc, epi);
        else
            return CreateSentinel(class'DEKAutoMercury',36,80,100,class'DEKAutoMercuryController',0, Points, P, SpawnLoc, epi);
    	break;
    case class'DruidLinkSentinel':
		if (bOnCeiling)
            return CreateSentinel(class'DruidLinkSentinel',-70,120,-160,class'DruidLinkSentinelController',32768, Points, P, SpawnLoc, epi);
        else
            return CreateSentinel(class'DruidLinkSentinel',67,150,180,class'DruidLinkSentinelController',0, Points, P, SpawnLoc, epi);
    	break;
    Default:
    	Log("DruidSentinelSummon invalid SummonItem used" @ SummonItem);
		if (bOnCeiling)
            return CreateSentinel(SummonItem,-80,80,-100,class'DruidBaseSentinelController',32768, Points, P, SpawnLoc, epi);
        else
            return CreateSentinel(SummonItem,28,80,100,class'DruidBaseSentinelController',0, Points, P, SpawnLoc, epi);
    	break;
    }
    
 	return true;
}

function bool  CreateSentinel(class<Pawn> SentinelClass,int SpawnHeightOffset,int hSize,int vSize,class<Controller> ControllerClass,int roll,int Points,Pawn P,Vector SpawnLoc, EngineerPointsInv epi)
{
	Local ASTurret NewSentinel;
	local rotator SpawnRotation;
    local Controller SentinelController;

    // Log("++++++ calling CreateSentinel for class" @ SentinelClass @ "controller" @ ControllerClass);

    SpawnLoc.z += SpawnHeightOffset;		// just off the floor or just below ceiling
    if (!CheckSpace(SpawnLoc,hSize,vSize))
    {
    	Instigator.ReceiveLocalizedMessage(MessageClass, 6000, None, None, Class);
    	bActive = false;
    	GotoState('');
    	return false;
    }

    if (roll != 0)
    {
        SpawnRotation.Yaw = rotator(SpawnLoc - Instigator.Location).Yaw;
        SpawnRotation.Roll = roll;          // upside down
        NewSentinel = epi.SummonRotatedSentinel(SentinelClass, Points, P, SpawnLoc, SpawnRotation);
    } 
    else
    {
		NewSentinel = epi.SummonBaseSentinel(SentinelClass, Points, P, SpawnLoc);
    }   
                
    if (NewSentinel == None)
    	return false;
    
    SentinelController = spawn(ControllerClass);
    if ( DruidSentinelController(SentinelController) != None )
    {
    	DruidSentinelController(SentinelController).Possess(NewSentinel);
    	DruidSentinelController(SentinelController).SetPlayerSpawner(Instigator.Controller);
    }
    else
    if ( DruidSuperDefenseSentinelController(SentinelController) != None )
    {
    	DruidSuperDefenseSentinelController(SentinelController).Possess(NewSentinel);
    	DruidSuperDefenseSentinelController(SentinelController).SetPlayerSpawner(Instigator.Controller);
    }
    else
    if ( DruidDefenseSentinelController(SentinelController) != None )
    {
    	DruidDefenseSentinelController(SentinelController).Possess(NewSentinel);
    	DruidDefenseSentinelController(SentinelController).SetPlayerSpawner(Instigator.Controller);
    }
    else
    if ( DruidDefenseSentinelControllerCrimbo(SentinelController) != None )
    {
    	DruidDefenseSentinelControllerCrimbo(SentinelController).Possess(NewSentinel);
    	DruidDefenseSentinelControllerCrimbo(SentinelController).SetPlayerSpawner(Instigator.Controller);
    }
    else
    if ( DruidLightningSentinelController(SentinelController) != None )
    {
    	DruidLightningSentinelController(SentinelController).Possess(NewSentinel);
    	DruidLightningSentinelController(SentinelController).SetPlayerSpawner(Instigator.Controller);
    }
    else
    if ( DruidTeslaSentinelController(SentinelController) != None )
    {
    	DruidTeslaSentinelController(SentinelController).Possess(NewSentinel);
    	DruidTeslaSentinelController(SentinelController).SetPlayerSpawner(Instigator.Controller);
    }
    else
    if ( AutoGunController(SentinelController) != None )
    {
    	AutoGunController(SentinelController).Possess(NewSentinel);
    	AutoGunController(SentinelController).SetPlayerSpawner(Instigator.Controller);
    }
    else
    if ( DruidBaseSentinelController(SentinelController) != None )
    {
    	DruidBaseSentinelController(SentinelController).Possess(NewSentinel);
    	DruidBaseSentinelController(SentinelController).SetPlayerSpawner(Instigator.Controller);
    }
    else
    if ( DruidLinkSentinelController(SentinelController) != None )
    {
    	DruidLinkSentinelController(SentinelController).Possess(NewSentinel);
    	DruidLinkSentinelController(SentinelController).SetPlayerSpawner(Instigator.Controller);
    }
   
    SetStartHealth(NewSentinel);
    
    // now allow player to get xp bonus
    ApplyStatsToConstruction(NewSentinel,Instigator);
    
    return true;          
}

function bool SpawnEnergyWall(TranslocatorBeacon Beacon, Pawn P, EngineerPointsInv epi)
{
	Local DruidEnergyWall NewEnergyWall;
	local DruidEnergyWallController EWC;
	local Actor A;
	local vector HitLocation, HitNormal;
	local vector Post1SpawnLoc, Post2SpawnLoc, SpawnLoc; 
	local vector Normalvect, XVect, YVect, ZVect;
	local class<DruidEnergyWall> WallSummonItem;
	
	WallSummonItem = class<DruidEnergyWall>(SummonItem);
	if (WallSummonItem == None)
	{
		bActive = false;
		GotoState('');
		return false;
	}
		
	SpawnLoc = epi.GetSpawnHeight(Beacon.Location);	// look at the floor
	SpawnLoc.z += 20 + (WallSummonItem.default.Height/2);								// step up a bit off the ground
	
	// now work out the position of the posts
	NormalVect = Normal(SpawnLoc-Instigator.Location);
	NormalVect.Z = 0;
	YVect = NormalVect;
	ZVect = vect(0,0,1);	// always vertical
	XVect = Normal(YVect cross ZVect);	// vector at 90 degrees to the other two

	// first check the height
	if (!FastTrace(SpawnLoc, SpawnLoc + (ZVect*WallSummonItem.default.Height)))
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 6000, None, None, Class);
		bActive = false;
		GotoState('');
		return false;
	}
	
	A = Trace(HitLocation, HitNormal, SpawnLoc + (XVect*WallSummonItem.default.MaxGap*0.5), SpawnLoc, true,, );
	if (A == None)
		Post1SpawnLoc = SpawnLoc + (XVect*WallSummonItem.default.MaxGap*0.5);
	else
		Post1SpawnLoc = HitLocation - 20*XVect;		// step back slightly from the object
	
	A = None;
	A = Trace(HitLocation, HitNormal, SpawnLoc - (XVect*WallSummonItem.default.MaxGap*0.5), SpawnLoc, true,, );
	if (A == None)
		Post2SpawnLoc = SpawnLoc - (XVect*WallSummonItem.default.MaxGap*0.5);
	else
		Post2SpawnLoc = HitLocation + 20*XVect;		// step back slightly from the object
		
	// ok now lets spawn it
	if ((Post1SpawnLoc == vect(0,0,0)) || (Post2SpawnLoc == vect(0,0,0)) || VSize(Post1SpawnLoc - Post2SpawnLoc) > WallSummonItem.default.MaxGap  || VSize(Post1SpawnLoc - Post2SpawnLoc) < WallSummonItem.default.MinGap)
	{
		// cant spawn one of the posts or one has gone awol
		Instigator.ReceiveLocalizedMessage(MessageClass, 4000, None, None, Class);
		bActive = false;
		GotoState('');
		return false;
	}

	// have 2 valid post positions and a gap inbetween
	NewEnergyWall = epi.SummonEnergyWall(WallSummonItem, Points, P, SpawnLoc, Post1SpawnLoc, Post2SpawnLoc);
	if (NewEnergyWall == None)
		return false;
	SetStartHealth(NewEnergyWall);
	
	// now lets add the controller
	if ( Role == Role_Authority )
	{
		// create the controller for this energy wall
		EWC = DruidEnergyWallController(spawn(NewEnergyWall.default.DefaultController));
		if ( EWC != None )
		{
			EWC.SetPlayerSpawner(Instigator.Controller);
			EWC.Possess(NewEnergyWall);

			// now allow player to get xp bonus
			ApplyStatsToConstruction(NewEnergyWall,Instigator);
		}
	}
	return true;
}

defaultproperties
{
     IconMaterial=Texture'DEKRPGTexturesMaster209B.Artifacts.SummonSentinelIcon'
     ItemName=""
}
