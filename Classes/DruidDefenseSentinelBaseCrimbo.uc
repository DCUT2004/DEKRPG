class DruidDefenseSentinelBaseCrimbo extends ASTurret_Base;

#exec OBJ LOAD FILE=..\StaticMeshes\DEKStaticsMaster209B.usx
#exec OBJ LOAD FILE=..\Textures\DEKRPGTexturesMaster209B.utx

defaultproperties
{
     StaticMesh=StaticMesh'DEKStaticsMaster209B.ChristmasMeshes.FloorCandyCane'
     DrawScale=0.300000
     Skins(0)=Shader'DEKRPGTexturesMaster209B.SkinsChristmas.FloorSentShader'
     Skins(1)=FinalBlend'DEKRPGTexturesMaster209B.fX.DefensePanFinal'
     AmbientGlow=1
     CollisionRadius=1.000000
     CollisionHeight=10.000000
}
