class LinkNodeController extends NodeController
	config(UT2004RPG);

var config float LinkRadius;
var config float VehicleHealPerShot;
var class<xEmitter> TurretLinkEmitterClass;        // for linking to turrets where we get xp
var class<xEmitter> VehicleLinkEmitterClass;       // for linking to vehicles where we do not get xp

var float SecondFraction;

var float PercentRangeIncreasePerLevel;
var float PercentHealIncreasePerLevel;

function Timer()
{
    // coming at at 0.3 instead of 1.0 to maintain links. But need to adjust timing of other calls.
    local Node node;

	if (Pawn == None || PlayerSpawner == None)
	    return;

    node = Node(Pawn);
	if (node.Charge >= ChargeDrainPerSecond)
	{
        // do linking
        DoLinks();
	}
    
    SecondFraction += TimeBetweenChecks;
    if (SecondFraction >= 1.0)
    {
        SecondFraction -= 1.0;
    	Super.Timer();           // this will reduce the charge remaining
    }        

}

function DoLinks()
{
	// lets see if we can link to anything
	Local Pawn LoopP;
	Local Controller C;
	local xEmitter HitEmitter;

	if (Pawn == None || PlayerSpawner == None)
	    return;
	    
	foreach DynamicActors(class'Pawn', LoopP)
	{
		// first check if the pawn is anywhere near
	    if (LoopP != None &&  LoopP.Health > 0 && Pawn != None && VSize(LoopP.Location - Pawn.Location) < LinkRadius && FastTrace(LoopP.Location, Pawn.Location) && LoopP != Pawn)
	    {
			// ok, let's go for it
			C = LoopP.Controller;
			// must be either not controlled, or on same team
			if (C == None || C.SameTeamAs(self) )
			{
				//ok lets see if we can help.
			    if (Vehicle(LoopP) != None || DruidEnergyWall(LoopP) != None)
			    {
			        // lets see what we can do to help. If a turret, then establish a link. If just a vehicle or sentinel, just heal if it needs it
			        if (DruidMinigunTurret(LoopP) != None || DruidBallTurret(LoopP) != None || DruidEnergyTurret(LoopP) != None || DruidIonCannon(LoopP) != None || DEKLynxTurret(LoopP) != None || DEKSolarTurret(LoopP) != None || DEKOdinTurret(LoopP) != None || DEKLightningTurret(LoopP) != None || DEKPlasmaTurret(LoopP) != None || DEKStingerTurret(LoopP) != None || DEKSkyMineTurret(LoopP) != None)
					{   // not a link turret :(
					    // estalish an xp link
						LoopP.HealDamage(VehicleHealPerShot, self, class'DamTypeLinkShaft');
						HitEmitter = spawn(TurretLinkEmitterClass,,, Pawn.Location, rotator(LoopP.Location - Pawn.Location));
						if (HitEmitter != None)
							HitEmitter.mSpawnVecA = LoopP.Location;
					}
				    else if (LoopP.Health < LoopP.HealthMax)
				    {
					    // can at least add some health
						LoopP.GiveHealth(VehicleHealPerShot, LoopP.HealthMax);
						HitEmitter = spawn(VehicleLinkEmitterClass,,, Pawn.Location, rotator(LoopP.Location - Pawn.Location));
						if (HitEmitter != None)
							HitEmitter.mSpawnVecA = LoopP.Location;
						// and probably ought to get same xp as armor healing powerup on defsent. But sadly that is zero, so nothing.
					}
				}
			}
		}
	}
}

function LevelUp(int NodeLevel)
{
     LinkRadius += default.LinkRadius * PercentRangeIncreasePerLevel;
     VehicleHealPerShot += default.VehicleHealPerShot * PercentHealIncreasePerLevel;
}

defaultproperties
{
	 ChargeDrainPerSecond=2
     TimeBetweenChecks=0.300000
     LinkRadius=700.000000
     VehicleHealPerShot=20.000000
     TurretLinkEmitterClass=Class'DEKRPG999X.DruidLinkSentinelBeamEffect'
     VehicleLinkEmitterClass=Class'DEKRPG999X.BronzeBoltEmitter'
     PercentRangeIncreasePerLevel=0.1
     PercentHealIncreasePerLevel=0.1
}
