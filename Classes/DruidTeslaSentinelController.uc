class DruidTeslaSentinelController extends DruidLightningSentinelController
	config(UT2004RPG);
    
var int NoShootCount; 
var int FullyChargedCount;   

function Timer()
{
	// lets target some enemies
	local Controller C, NextC, SelectedC;
	local int DamageDealt;
	local xEmitter HitEmitter;
	local float damageScale, dist;
	local vector dir;
    local float SelectedEnemyDistance;

	if (PlayerSpawner == None || PlayerSpawner.Pawn == None)
		return;
        
    if (NoShootCount < FullyChargedCount)
        NoShootCount++;

    // find the nearest enemy and hit it.
    // if not enemy in range, let the counter increase as we build up charge.
    SelectedC = None;
    SelectedEnemyDistance = TargetRadius;
    
	C = Level.ControllerList;
	while (C != None)
	{
		// get next controller here because C may be destroyed if it's a nonplayer and C.Pawn is killed
		NextC = C.NextController;
			
		if (C != None && C.Pawn != None && Pawn != None && C.Pawn != Pawn && C.Pawn != PlayerSpawner.Pawn && C.Pawn.Health > 0
		  && VSize(C.Pawn.Location - Pawn.Location) < SelectedEnemyDistance && FastTrace(C.Pawn.Location, Pawn.Location) && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow') && !C.Pawn.IsA('MissionBalloon') && PhantomDeathGhostInv(C.Pawn.FindInventoryType(class'PhantomDeathGhostInv')) == None
		   && ((TeamGame(Level.Game) != None && !C.SameTeamAs(PlayerSpawner)) 	// on a different team
			|| (TeamGame(Level.Game) == None && C.Pawn.Owner != PlayerSpawner)))		// or just not me
		{
            SelectedC = C;
            SelectedEnemyDistance = VSize(C.Pawn.Location - Pawn.Location);
		}
		C = NextC;
	}
    
    if (SelectedC != None)
    {
		if (SelectedC != None && SelectedC.Pawn != None && Pawn != None)
		{
			HitEmitter = spawn(HitEmitterClass,,, Pawn.Location, rotator(SelectedC.Pawn.Location - Pawn.Location));
			if (HitEmitter != None)
				HitEmitter.mSpawnVecA = SelectedC.Pawn.Location;
		}

		// scale damage done according to distance from sentinel
		dir = SelectedC.Pawn.Location - Pawn.Location;
		dist = FMax(1,VSize(dir));
		damageScale = 1 - FMax(0,dist/TargetRadius);

		DamageDealt = (damageScale * (MaxDamagePerHit-MinDamagePerHit)) + MinDamagePerHit;
		DamageDealt *= NoShootCount;
        DamageDealt = class'BaseInstantFire'.static.UpdateDamageDueToLevel(Pawn, DamageDealt);
        // Log("++++ Tesla Sentinel count" @ NoShootCount @ "about to do" @ DamageDealt @ "damage to" @ SelectedC.Pawn @ "Current Health" @ SelectedC.Pawn.Health);
		SelectedC.Pawn.TakeDamage(DamageDealt, Pawn, SelectedC.Pawn.Location, vect(0,0,0), class'DamTypeTeslaSent');

		//hack for invasion monsters so they'll fight back
		if (SelectedC != None && SelectedC.Pawn != None && MonsterController(SelectedC) != None && DEKFriendlyMonsterController(SelectedC) == None && Pawn != None 
	     	  && SelectedC.Enemy != Pawn && FastTrace(Pawn.Location,SelectedC.Pawn.Location) && !ClassIsChildOf(SelectedC.Pawn.Class, class'SMPNali'))
	    {
	    	if (SelectedC.Enemy == None || FRand() < 0.15 )
				MonsterController(SelectedC).ChangeEnemy(Pawn, SelectedC.CanSee(Pawn));
		}
        
        NoShootCount = 0;
    }
}

defaultproperties
{
     HitEmitterClass=Class'DEKRPG999X.LightningBeamEmitter'
     MaxDamagePerHit=60
     MinDamagePerHit=25
     TargetRadius=1000.000000
     TimeBetweenShots=2.5
     FullyChargedCount=10
}
