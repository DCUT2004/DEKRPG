//Releases soul projectiles when the pawn holding this inventory dies
//Necromancer class - Soul Sorcerer subclass

class MasterSoulSorcererInv extends Inventory;

var Pawn Necromancer;
var config float LockAim;
var config float MaxRange;
var config int ScoreDivider;

function SpawnSouls()
{
	local NecromancerSoulWeaponHomingSoul P;
	local Rotator rot1, rot1Target;
	local float BestAim, BestDist;
	local Monster M;
    local vector X,Y,Z;
	
	rot1 = Instigator.Controller.GetViewRotation();
	rot1.yaw += FRand()*12000-6000;
	rot1.roll += FRand()*12000-6000;
	//rot1.pitch += 1000;
	rot1Target = rot1;
	
    GetAxes(Instigator.Controller.Rotation,X,Y,Z);
	
	if (Instigator.IsA('Monster'))
		M = Monster(Instigator);
	if (M != None)
		P = Necromancer.Spawn(class'NecromancerSoulWeaponHomingSoul', Necromancer, , M.GetFireStart(X,Y,Z), rot1);
	else
		P = Necromancer.Spawn(class'NecromancerSoulWeaponHomingSoul', Necromancer, , Instigator.Location + Vect(5,5,5), rot1);	
	if (P != None)
	{
		BestAim = LockAim;
		P.Seeking = Necromancer.Controller.PickTarget(BestAim, BestDist, vector(rot1Target), Instigator.Location, MaxRange);
	}
}


simulated function Destroyed()
{
	local Monster M;
	local int x;
	
	if (Instigator != None && Instigator.Controller != None && Necromancer != None && Necromancer.Controller != None)
	{
		if (Instigator.IsA('Monster'))
			M = Monster(Instigator);
		if (M != None)
		{
			for (x = 0; x < 1 + (M.ScoringValue/5); x++)
				SpawnSouls();
		}
	}
	Super.Destroyed();
}

defaultproperties
{
     LockAim=0.000010
     MaxRange=90000.000000
	 ScoreDivider=7
}
