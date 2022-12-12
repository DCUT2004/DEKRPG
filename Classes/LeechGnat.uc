class LeechGnat extends Razorfly
	config(UT2004RPG);

var Pawn Master;
var float HealthMultiplier;
var config int BiteDamage;

function RangedAttack(Actor A)
{
	if ( VSize(A.Location - Location) < MeleeRange + CollisionRadius + A.CollisionRadius )
	{
		bShotAnim = true;
		PlayAnim('Shoot1');
		if ( MeleeDamageTarget(BiteDamage, (15000.0 * Normal(A.Location - Location))) )
		{
			PlaySound(sound'injur1rf', SLOT_Talk);
			if (Master != None)
				Master.GiveHealth(BiteDamage*HealthMultiplier, Master.HealthMax);
		}
			
		Controller.Destination = Location + 110 * (Normal(Location - A.Location) + VRand());
		Controller.Destination.Z = Location.Z + 70;
		Velocity = AirSpeed * normal(Controller.Destination - Location);
		Controller.GotoState('TacticalMove', 'DoMove');
	}
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	Destroy();
}

defaultproperties
{
	 BiteDamage=20
     ControllerClass=Class'DEKRPG999X.DEKFriendlyMonsterController'
     HealthMax=200.000000
     Health=200
     AirSpeed=2000.000000
     AccelRate=2000.000000
     DrawScale=0.500000
     CollisionRadius=9.000000
     CollisionHeight=5.500000
     Skins(0)=FinalBlend'DEKMonstersTexturesMaster208.GenericMonsters.VGnatFB'
     Skins(1)=FinalBlend'DEKMonstersTexturesMaster208.GenericMonsters.VGnatFB'
}
