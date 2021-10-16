//Blocks hostile projectiles
//Friendly projectiles can pass through
class RuneGuard extends Actor;

var Pawn PawnOwner;

simulated function Touch(Actor Other)
{
	local Projectile P;
	local Vector HitNormal;
	
    if (Other != None)
	{
		if (ClassIsChildOf(Other.Class, class'Projectile'))
		{
			P = Projectile(Other);
			if (P != None && P.InstigatorController != None && PawnOwner != None && PawnOwner.Controller != None && !P.InstigatorController.SameTeamAs(PawnOwner.Controller))
			{
				P.HitWall(-1*Normal(P.Velocity),self);
				P.Explode(P.Location, HitNormal);
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
	AmbientSound=Sound'DEKRPG209B.ArtifactSounds.ImmobilizeAmbient'
	LightType=LT_Steady
	LightEffect=LE_QuadraticNonIncidence
	LightHue=135
	LightBrightness=255.000000
	LightRadius=15.000000
	DrawType=DT_StaticMesh
	StaticMesh=StaticMesh'DEKStaticsMaster209B.Meshes.GuardShield'
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
	Lifespan=4.0000
}
