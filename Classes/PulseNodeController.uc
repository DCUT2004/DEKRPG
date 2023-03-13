class PulseNodeController extends NodeController
	config(UT2004RPG);

var config float DamageRadius;
var config float MaxDamage;
var config float MinDamage;
var class<Emitter> PulseEmitterClass;  

var float PercentRangeIncreasePerLevel;
var float PercentDamageIncreasePerLevel;

function Attack()
{
 	local Controller C, NextC;
 	local float dist;
    local float DamageScale;
    local float DamageDealt;

	spawn(PulseEmitterClass,,,Pawn.Location, rot(0,0,0));
    
	C = Level.ControllerList;
	while (C != None)
	{
		// loop round finding all enemies hit
		NextC = C.NextController;
		if ( C.Pawn != None && C.Pawn != Pawn && C.Pawn.Health > 0 && !C.SameTeamAs(self)
		     && VSize(C.Pawn.Location - Pawn.Location) < DamageRadius && FastTrace(C.Pawn.Location, Pawn.Location)
              && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow') && !C.Pawn.IsA('MissionBalloon'))
		{
			// scale damage done according to distance from node
			dist = FMax(1,VSize(C.Pawn.Location - Pawn.Location));
			DamageScale = 1 - FMax(0,dist/DamageRadius);

			DamageDealt = ((MaxDamage - MinDamage) * DamageScale) + MinDamage;
			DamageDealt = max(1, DamageDealt);
            // Log("++++++ PulseNodeController doing" @ DamageDealt @ "to" @ C.Pawn @ "with Health" @ C.Pawn.Health @ "distance" @ dist);	
			C.Pawn.TakeDamage(DamageDealt, PlayerSpawner.Pawn, C.Pawn.Location, vect(0,0,0), class'DamTypePulseNode');
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
     DamageRadius=2000.000000
     MaxDamage=40.000000
     MinDamage=15.000000
     PercentRangeIncreasePerLevel=0.1
     PercentDamageIncreasePerLevel=0.1
     PulseEmitterClass=class'DEKRPG999X.PulseNodeEmitter'
	 ChargeDrainPerSecond=2
}
