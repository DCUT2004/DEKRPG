class NaliPriestProtector extends HealerNali
	config(UT2004RPG);
	
var TeamAdrenalineGameRules TARules;

simulated function PostBeginPlay()
{
	local GameRules G;
	
	Instigator = self;
	SummonedMonster = True;
	
	for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
	{
		if(G.isA('TeamAdrenalineGameRules'))
		{
			TARules = TeamAdrenalineGameRules(G);
			break;
		}
	}
	Super.PostBeginPlay();
}

function bool SameSpeciesAs(Pawn P)
{
	return True;
}

function AddHealth(float HealthDamage)
{
	return;
}

static function DropPickups(Controller Killed, Controller Killer, class<Pickup> PickupType, Inventory Inv, int Num)
{
	return;
}

simulated function PlayDirectionalHit(Vector HitLoc)
{
    local Vector X,Y,Z, Dir;

	bCringing = False;

    GetAxes(Rotation, X,Y,Z);
    HitLoc.Z = Location.Z;

    // random
    if ( VSize(Location - HitLoc) < 1.0 )
    {
        Dir = VRand();
    }
    // hit location based
    else
    {
        Dir = -Normal(Location - HitLoc);
    }

    if ( Dir Dot X > 0.7 || Dir == vect(0,0,0))
    {
        PlayAnim('HeadHit',, 0.1);
    }
    else if ( Dir Dot X < -0.7 )
    {
        PlayAnim('GutHit',, 0.1);
    }
    else if ( Dir Dot Y > 0 )
    {
        PlayAnim('RightHit',, 0.1);
    }
    else
    {
        PlayAnim('LeftHit',, 0.1);
    }
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	if (instigatedBy != None && instigatedBy.Controller != None && instigatedBy.Controller.SameTeamAs(Instigator.Controller))
		return;
	Super(SMPNali).TakeDamage(Damage, instigatedBy, hitlocation, momentum, damagetype);
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	local Actor A;
	
	A = spawn(class'NewTransEffectBlue', Self,, Self.Location, Self.Rotation);
	if (A != None)
		A.RemoteRole = ROLE_SimulatedProxy;
	Self.PlaySound(Sound'satoreMonsterPackv120.fear1n');
	
	if (SummonedMonster)
	{
		Destroy();	// do not want to execute the invasion Killed function which decrements the number of monsters
	}
	else
		Super.Died(Killer, damageType, HitLocation);
}

defaultproperties
{
     bCanDodge=True
	 bCanStrafe=True
     ScoringValue=0
     ControllerClass=Class'SkaarjPack.MonsterController'
}
