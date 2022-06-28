class ComboInaccuracyEffect extends Emitter;

#exec OBJ LOAD FILE=XEffectMat.utx

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         UniformSize=True
         UseVelocityScale=True
         ColorScale(0)=(Color=(B=220,G=244,R=66))
         ColorScale(1)=(RelativeTime=0.200000,Color=(R=255))
         ColorScale(2)=(RelativeTime=1.000000,Color=(R=255))
         FadeOutStartTime=1.300000
         FadeInEndTime=0.250000
         MaxParticles=30
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=108.000000,Max=108.000000)
         RevolutionsPerSecondRange=(Z=(Min=0.200000,Max=0.500000))
         RevolutionScale(0)=(RelativeRevolution=(Z=2.000000))
         RevolutionScale(1)=(RelativeTime=0.600000)
         RevolutionScale(2)=(RelativeTime=1.000000,RelativeRevolution=(Z=2.000000))
         SpinsPerSecondRange=(X=(Max=4.000000))
         StartSizeRange=(X=(Min=4.000000,Max=4.000000),Y=(Min=4.000000,Max=4.000000),Z=(Min=8.000000,Max=8.000000))
         Texture=Texture'EpicParticles.Flares.HotSpot'
         LifetimeRange=(Min=1.600000,Max=1.600000)
         StartVelocityRadialRange=(Min=-20.000000,Max=-20.000000)
         VelocityLossRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.200000,Max=0.200000),Z=(Min=1.000000,Max=1.000000))
         GetVelocityDirectionFrom=PTVD_AddRadial
         VelocityScale(0)=(RelativeVelocity=(X=2.000000,Y=2.000000,Z=2.000000))
         VelocityScale(1)=(RelativeTime=0.600000)
         VelocityScale(2)=(RelativeTime=1.000000,RelativeVelocity=(X=-10.000000,Y=-10.000000,Z=-10.000000))
     End Object
     Emitters(0)=SpriteEmitter'DEKRPG209E.ComboInaccuracyEffect.SpriteEmitter2'

     CullDistance=2000.000000
     bNoDelete=False
}
