class Flamethrower extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=Flame0
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UniformSize=True
         UseRegularSizeScale=False
         UseSizeScale=True
         UseRandomSubdivision=True
         Acceleration=(Z=10.000000)
         ColorMultiplierRange=(Z=(Min=0.000000))
         FadeOutStartTime=0.950000
         FadeInEndTime=0.010000
         CoordinateSystem=PTCS_Relative
         MaxParticles=12
         StartLocationRange=(X=(Max=-5.000000),Y=(Min=5.000000,Max=-5.000000),Z=(Max=1.000000))
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Max=50.000000)
         SpinsPerSecondRange=(X=(Min=-0.300000,Max=0.300000))
         SizeScale(0)=(RelativeSize=0.700000)
         SizeScale(1)=(RelativeTime=0.950000,RelativeSize=3.500000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=20.000000,Max=25.000000))
         UseSkeletalLocationAs=PTSU_Location
         SkeletalScale=(X=2.000000,Y=0.400000,Z=1.000000)
         Texture=Texture'EmitterTextures.MultiFrame.LargeFlames'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Min=5.000000,Max=-5.000000),Y=(Min=5.000000,Max=-5.000000),Z=(Min=5.000000,Max=-5.000000))
     End Object
     Emitters(0)=SpriteEmitter'DEKRPG999X.Flamethrower.Flame0'

     AutoDestroy=True
     bNoDelete=False
     bNetTemporary=True
     bAlwaysRelevant=True
     RemoteRole=ROLE_SimulatedProxy
     bHardAttach=True
}
