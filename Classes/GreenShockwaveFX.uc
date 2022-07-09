class GreenShockwaveFX extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         FadeOutStartTime=0.100000
         MaxParticles=1
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=10.000000)
         ColorScale(1)=(RelativeTime=0.250000,Color=(B=4,G=143,R=1))
         ColorScale(2)=(RelativeTime=0.500000,Color=(B=22,G=55,R=82))
         ColorScale(3)=(RelativeTime=1.000000)
         InitialParticlesPerSecond=5.000000
         Texture=Texture'ONSstructureTextures.CoreGroup.CoreBreachShockRINGorange'
         LifetimeRange=(Min=0.500000,Max=0.500000)
     End Object
     Emitters(0)=SpriteEmitter'DEKRPG209F.GreenShockwaveFX.SpriteEmitter3'

     AutoDestroy=True
     bNoDelete=False
     bNetTemporary=True
     RemoteRole=ROLE_DumbProxy
}
