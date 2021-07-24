class ImmobilizeBubble extends Actor;

function PostBeginPlay()
{
	SetCollision(False,False,False);
	bCollideWorld = true;
	Super.PostBeginPlay();
}

defaultproperties
{
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'AW-2004Particles.Weapons.PlasmaSphere'
     DrawScale=2.000000
     Skins(0)=Shader'ONSBPTextures.fX.RedShieldShader'
     bUnlit=True
     bHardAttach=True
     bCollideWorld=True
}
