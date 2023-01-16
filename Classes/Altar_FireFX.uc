class Altar_FireFX extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter4
         UseDirectionAs=PTDU_Right
         UseCollision=True
         UseColorScale=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ScaleSizeXByVelocity=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-300.000000)
         ColorScale(1)=(RelativeTime=0.100000,Color=(R=149))
         ColorScale(2)=(RelativeTime=0.750000,Color=(R=255))
         ColorScale(3)=(RelativeTime=1.000000)
         CoordinateSystem=PTCS_Relative
         MaxParticles=30
         StartLocationRange=(Z=(Min=10.000000,Max=10.000000))
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=4.000000,Max=10.000000)
         UseRotationFrom=PTRS_Actor
         SpinCCWorCW=(X=0.000000,Y=0.000000,Z=0.000000)
         SizeScale(0)=(RelativeSize=40.000000)
         SizeScale(1)=(RelativeTime=0.300000,RelativeSize=16.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=4.000000,Max=10.000000),Y=(Min=4.000000,Max=10.000000),Z=(Min=10.000000,Max=20.000000))
         ScaleSizeByVelocityMultiplier=(X=0.005000)
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'AW-2004Particles.Energy.BandFlash'
         LifetimeRange=(Min=0.500000,Max=1.000000)
     End Object
     Emitters(0)=SpriteEmitter'DEKRPG999X.Altar_FireFX.SpriteEmitter4'

     Begin Object Class=MeshEmitter Name=MeshEmitter0
         StaticMesh=StaticMesh'AW-2004Particles.Shapes.NodeHealRing'
         RenderTwoSided=True
         UseParticleColor=True
         UseColorScale=True
         SpinParticles=True
         ColorScale(1)=(RelativeTime=0.100000,Color=(R=166))
         ColorScale(2)=(RelativeTime=0.750000,Color=(R=255))
         ColorScale(3)=(RelativeTime=0.100000)
         CoordinateSystem=PTCS_Relative
         MaxParticles=5
         SpinCCWorCW=(X=0.000000,Y=0.000000,Z=0.000000)
         StartSpinRange=(X=(Max=10.000000),Y=(Max=10.000000))
         StartSizeRange=(X=(Min=0.600000,Max=0.600000),Y=(Min=0.600000,Max=0.600000),Z=(Min=0.600000,Max=0.600000))
     End Object
     Emitters(1)=MeshEmitter'DEKRPG999X.Altar_FireFX.MeshEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter5
         UseColorScale=True
         UseRevolution=True
         UseRevolutionScale=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseVelocityScale=True
         ColorScale(0)=(RelativeTime=0.100000,Color=(R=255))
         ColorScale(1)=(RelativeTime=0.750000,Color=(R=155))
         MaxParticles=3
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=4.000000,Max=10.000000)
         RevolutionsPerSecondRange=(X=(Min=-2.000000,Max=2.000000),Y=(Min=-2.000000,Max=2.000000),Z=(Min=-2.000000,Max=2.000000))
         SpinsPerSecondRange=(X=(Max=0.500000))
         StartSpinRange=(X=(Max=2.000000))
         StartSizeRange=(X=(Min=10.000000,Max=20.000000),Y=(Min=20.000000,Max=20.000000),Z=(Min=20.000000,Max=20.000000))
         Texture=Texture'AW-2004Particles.Weapons.HardSpot'
         LifetimeRange=(Min=0.200000,Max=0.500000)
         StartVelocityRadialRange=(Min=300.000000,Max=600.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
         VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
         VelocityScale(1)=(RelativeTime=1.000000)
     End Object
     Emitters(2)=SpriteEmitter'DEKRPG999X.Altar_FireFX.SpriteEmitter5'

     bNoDelete=False
     RemoteRole=ROLE_SimulatedProxy
     bNotOnDedServer=False
}
