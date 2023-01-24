//Blocks hostile projectiles
//Friendly projectiles can pass through
class RuneGuard extends Actor;

var Pawn PawnOwner;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer(0.2, True);
}

simulated function Touch(Actor Other)
{
	local Projectile P;
	local SyncDestroy Sync;
	
    if (Other != None)
	{
		if (ClassIsChildOf(Other.Class, class'Projectile'))
		{
			P = Projectile(Other);
			if (P != None && P.InstigatorController != None && PawnOwner != None && PawnOwner.Controller != None && !P.InstigatorController.SameTeamAs(PawnOwner.Controller))
			{
				//Want to simulate destroying the projectile on a client
				//Unfortunately, simply calling Destroy() does not do it (e.g. defense sentinel issue)
				//Instead, set the lifespan to a small value, and the lifespan should also be replicated to the client as well
				if (Role == ROLE_Authority)
				{
					P.Lifespan = 0.05;
					//Tell the clients
					if(Level.NetMode == NM_DedicatedServer)
					{
						Sync = P.Instigator.Spawn(class'SyncDestroy');
						Sync.Proj = P;
						Sync.ProjLifespan = 0.05;
					}
				}
			}
		}
	}
}

simulated function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);
    
	if (Instigator == None || Instigator.Controller == None)
		Destroy();
    else    
        if (PawnOwner == None)
            Destroy();
        // else
    	   // SetRotation(Rotator(Location - PawnOwner.Location));
}

simulated function Timer()
{
	if (Instigator == None || Instigator.Controller == None)
		Destroy();
}

defaultproperties
{
	AmbientSound=Sound'DEKRPG999X.ArtifactSounds.ImmobilizeAmbient'
	DrawType=DT_StaticMesh
	StaticMesh=StaticMesh'DEKStaticsMaster209C.Meshes.GuardShield'
	bDynamicLight=False
	bIgnoreVehicles=True
	Physics=PHYS_None
	Skins(0)=FinalBlend'XEffectMat.Shield.RedShell'
	CollisionRadius=60.000000
	CollisionHeight=60.000000
	bCollideActors=True
	bCollideWorld=True
	Mass=2000.000000
	Lifespan=0.0000
}
