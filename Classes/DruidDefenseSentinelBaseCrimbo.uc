class DruidDefenseSentinelBaseCrimbo extends ASTurret_Base;

#exec OBJ LOAD FILE=..\StaticMeshes\DEKStaticsMaster208K.usx
#exec OBJ LOAD FILE=..\Textures\DEKRPGTexturesMaster208K.utx

defaultproperties
{
     StaticMesh=StaticMesh'DEKStaticsMaster208K.ChristmasMeshes.FloorCandyCane'
     DrawScale=0.300000
     Skins(0)=Shader'DEKRPGTexturesMaster208K.SkinsChristmas.FloorSentShader'
     Skins(1)=FinalBlend'DEKRPGTexturesMaster208K.fX.DefensePanFinal'
     AmbientGlow=1
     CollisionRadius=1.000000
     CollisionHeight=10.000000
}
