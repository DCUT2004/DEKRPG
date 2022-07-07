//Blocks hostile projectiles
//Friendly projectiles can pass through
class RuneGuard extends Actor;

var Pawn PawnOwner;

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
	SetRotation(Rotator(Location - PawnOwner.Location));
}

defaultproperties
{
	AmbientSound=Sound'DEKRPG209E.ArtifactSounds.ImmobilizeAmbient'
	LightType=LT_Steady
	LightEffect=LE_QuadraticNonIncidence
	LightHue=135
	LightBrightness=255.000000
	LightRadius=15.000000
	DrawType=DT_StaticMesh
	StaticMesh=StaticMesh'DEKStaticsMaster209C.Meshes.GuardShield'
	bDynamicLight=True
	bIgnoreVehicles=True
	Physics=PHYS_None
	//Skins(0)=FinalBlend'XEffectMat.Shield.RedShell'
	Skins(0)=Shader'ONSBPTextures.fX.RedShieldShader'
	CollisionRadius=60.000000
	CollisionHeight=60.000000
	bCollideActors=True
	bCollideWorld=True
	Mass=2000.000000
	Lifespan=8.0000
}
