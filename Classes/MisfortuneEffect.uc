class MisfortuneEffect extends FlightEffect;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=True
         FadeOut=True
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=51,G=51,R=214,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,A=255))
         FadeOutStartTime=1.500000
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=5.000000,Max=5.000000)
         UseRotationFrom=PTRS_Actor
         StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000),Z=(Min=10.000000,Max=10.000000))
         InitialParticlesPerSecond=5.000000
         Texture=Texture'EpicParticles.Flares.Sharpstreaks2'
         LifetimeRange=(Min=2.000000,Max=2.000000)
         StartVelocityRange=(Z=(Min=-15.000000,Max=-15.000000))
     End Object
     Emitters(0)=SpriteEmitter'DEKRPG999X.MisfortuneEffect.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=True
         FadeOut=True
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=51,G=51,R=214,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,A=255))
         FadeOutStartTime=1.500000
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=5.000000,Max=5.000000)
         UseRotationFrom=PTRS_Actor
         StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000),Z=(Min=10.000000,Max=10.000000))
         InitialParticlesPerSecond=5.000000
         Texture=Texture'EpicParticles.Flares.Sharpstreaks2'
         LifetimeRange=(Min=2.000000,Max=2.000000)
         StartVelocityRange=(Z=(Min=-15.000000,Max=-15.000000))
     End Object
     Emitters(1)=SpriteEmitter'DEKRPG999X.MisfortuneEffect.SpriteEmitter1'

     AutoDestroy=True
     bNoDelete=False
     bTrailerSameRotation=True
     bReplicateInstigator=True
     bReplicateMovement=False
     Physics=PHYS_Trailer
     RemoteRole=ROLE_SimulatedProxy
     bBlockZeroExtentTraces=False
     bBlockNonZeroExtentTraces=False
     bNetNotify=True
}
