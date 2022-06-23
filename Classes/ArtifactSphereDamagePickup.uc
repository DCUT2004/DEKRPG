class ArtifactSphereDamagePickup extends RPGArtifactPickup;

defaultproperties
{
     InventoryType=Class'DEKRPG209C.ArtifactSphereDamage'
     PickupMessage="You got the Sphere of Damage!"
     PickupSound=Sound'PickupSounds.SniperRiflePickup'
     PickupForce="SniperRiflePickup"
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'Editor.TexPropSphere'
     bAcceptsProjectors=False
     DrawScale=0.075000
     Skins(0)=Shader'DEKRPGTexturesMaster209B.fX.SphereDamageShader'
     AmbientGlow=255
}
