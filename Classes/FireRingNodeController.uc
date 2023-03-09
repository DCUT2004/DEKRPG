class FireRingNodeController extends NodeController
	config(UT2004RPG);

var config float DamageRadius;
var config float HeightDifference;
var config float MaxDamage;
var config float MinDamage;
var class<xEmitter> RingEmitterClass;  

var float PercentRangeIncreasePerLevel;
var float PercentDamageIncreasePerLevel;

function Attack()
{
 	local Controller C, NextC;
 	local float dist;
    local float DamageScale;
    local float DamageDealt;
    local bool InHeightRange;
    local float ThisHeightDiff;

	spawn(class'DEKRPG999X.FireRingEmitter',,,Pawn.Location, rot(0,0,0));
    
	C = Level.ControllerList;
	while (C != None)
	{
		// loop round finding all enemies hit
		NextC = C.NextController;
		if ( C.Pawn != None && C.Pawn != Pawn && C.Pawn.Health > 0 && !C.SameTeamAs(self)
		     && VSize(C.Pawn.Location - Pawn.Location) < DamageRadius && FastTrace(C.Pawn.Location, Pawn.Location)
              && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow') && !C.Pawn.IsA('MissionBalloon'))
		{
            InHeightRange = false;
            if (abs(C.Pawn.Location.Z - Pawn.Location.Z) < HeightDifference)
            {
                InHeightRange = true;
            }
            else
            {
                ThisHeightDiff = C.Pawn.Location.Z - Pawn.Location.Z;
                if (ThisHeightDiff > HeightDifference)      // target has height Z than node
                {
                    if (ThisHeightDiff - C.Pawn.CollisionHeight < HeightDifference)
                        InHeightRange = true;
                }
                else                                // node has higher Z than target
                {
                    if (ThisHeightDiff + C.Pawn.CollisionHeight > 0 - HeightDifference)
                        InHeightRange = true;
                }
            }
            
                       
            if (InHeightRange)
            {
    			// scale damage done according to distance from node
    			dist = FMax(1,VSize(C.Pawn.Location - Pawn.Location));
    			DamageScale = 1 - FMax(0,dist/DamageRadius);
    
    			DamageDealt = ((MaxDamage - MinDamage) * DamageScale) + MinDamage;
    			DamageDealt = max(1, DamageDealt);
                // Log("++++++ FireRingNodeController doing" @ DamageDealt @ "to" @ C.Pawn @ "with Health" @ C.Pawn.Health @ "Height" @ C.Pawn.Location.Z @ "Node height" @ Pawn.Location.Z);	
    			C.Pawn.TakeDamage(DamageDealt, PlayerSpawner.Pawn, C.Pawn.Location, vect(0,0,0), class'DamTypeFireRingNode');
            }
		}
		C = NextC;
	}
}

function LevelUp(int NodeLevel)
{
     DamageRadius += default.DamageRadius * PercentRangeIncreasePerLevel;
     MaxDamage += default.MaxDamage * PercentDamageIncreasePerLevel;
     MinDamage += default.MinDamage * PercentDamageIncreasePerLevel;
}

defaultproperties
{
     AttackInterval=5
     DamageRadius=700.000000
     HeightDifference=50
     MaxDamage=30.000000
     MinDamage=10.000000
     PercentRangeIncreasePerLevel=0.1
     PercentDamageIncreasePerLevel=0.1
     RingEmitterClass=Class'DEKRPG999X.FireRingEmitter'
	 ChargeDrainPerSecond=2
}
