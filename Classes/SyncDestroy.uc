//Simulates destroying a projectile on a client when called elsewhere, such as for Defense sentinels or Guard Rune
class SyncDestroy extends Sync;

//Needs to be replicated to sync projectiles that are currently accelerated
var Projectile Proj;
var float ProjLifespan;

replication
{
	reliable if(Role == ROLE_Authority && bNetInitial)
		Proj, ProjLifespan;
}

simulated function bool ClientFunction()
{
	if(Proj != None)
	{
		Proj.Lifespan = ProjLifespan;
	}
	
	return true;
}

defaultproperties
{
}
