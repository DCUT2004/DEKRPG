class BlueShockwaveFX extends Emitter;

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
         ColorScale(1)=(RelativeTime=0.250000,Color=(B=158,G=64,R=19))
         ColorScale(2)=(RelativeTime=0.500000,Color=(B=201,G=177,R=40))
         ColorScale(3)=(RelativeTime=1.000000)
         InitialParticlesPerSecond=5.000000
         Texture=Texture'ONSstructureTextures.CoreGroup.CoreBreachShockRINGorange'
         LifetimeRange=(Min=0.500000,Max=0.500000)
     End Object
     Emitters(0)=SpriteEmitter'DEKRPG209F.BlueShockwaveFX.SpriteEmitter3'

     AutoDestroy=True
     bNoDelete=False
     bNetTemporary=True
     RemoteRole=ROLE_DumbProxy
}
