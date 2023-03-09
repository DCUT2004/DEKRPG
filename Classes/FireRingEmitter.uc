class FireRingEmitter extends Emitter
	placeable;

#exec OBJ LOAD FILE=EpicParticles.utx

defaultproperties
{
     Begin Object Class=MeshEmitter Name=MeshEmitter0
         StaticMesh=StaticMesh'ParticleMeshes.Complex.ExplosionRing'
         UseParticleColor=True
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScale(1)=(RelativeTime=0.200000,Color=(B=197,G=197,R=197))
         ColorScale(2)=(RelativeTime=0.400000,Color=(B=236,G=236,R=236))
         ColorScale(3)=(RelativeTime=0.500000,Color=(B=186,G=186,R=186))
         FadeOutStartTime=0.300000
         FadeInEndTime=0.100000
         MaxParticles=1
         StartSpinRange=(Y=(Max=1.000000),Z=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.100000)
         SizeScale(1)=(RelativeTime=0.280000,RelativeSize=2.200000)
         SizeScale(2)=(RelativeTime=0.480000,RelativeSize=4.800000)
         SizeScale(3)=(RelativeTime=1.10000,RelativeSize=5.300000)
         StartSizeRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000))
         InitialParticlesPerSecond=50000.000000
         Texture=Texture'EpicParticles.PlasmaCube.PlasmaField02aw'
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=0.500000,Max=0.500000)
     End Object
     Emitters(0)=MeshEmitter'DEKRPG999X.FireRingEmitter.MeshEmitter0'


     AutoDestroy=True
     bNoDelete=False
     bNetTemporary=True
     RemoteRole=ROLE_DumbProxy
     Style=STY_Masked
     bDirectional=True
     bGameRelevant=true
}
